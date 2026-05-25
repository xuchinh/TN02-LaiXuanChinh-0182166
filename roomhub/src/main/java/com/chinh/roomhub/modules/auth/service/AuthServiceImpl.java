package com.chinh.roomhub.auth.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.HexFormat;
import java.util.UUID;

import com.chinh.roomhub.auth.dto.request.LoginRequest;
import com.chinh.roomhub.auth.dto.request.RegisterRequest;
import com.chinh.roomhub.auth.dto.response.LoginResponse;
import com.chinh.roomhub.auth.dto.response.RefreshTokenResponse;
import com.chinh.roomhub.auth.dto.response.RegisterResponse;
import com.chinh.roomhub.auth.entity.RefreshToken;
import com.chinh.roomhub.auth.mapper.AuthMapper;
import com.chinh.roomhub.auth.repository.RefreshTokenRepository;
import com.chinh.roomhub.common.enums.UserRole;
import com.chinh.roomhub.exception.custom.ConflictException;
import com.chinh.roomhub.exception.custom.UnauthorizedException;
import com.chinh.roomhub.security.jwt.JwtService;
import com.chinh.roomhub.security.principal.CustomUserPrincipal;
import com.chinh.roomhub.users.entity.Role;
import com.chinh.roomhub.users.entity.User;
import com.chinh.roomhub.users.repository.RoleRepository;
import com.chinh.roomhub.users.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthServiceImpl implements AuthService {

    private static final String GENERIC_AUTH_FAILURE = "Invalid email or password";

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthMapper authMapper;
    private final long refreshTokenExpirationMs;

    public AuthServiceImpl(
            UserRepository userRepository,
            RoleRepository roleRepository,
            RefreshTokenRepository refreshTokenRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            AuthMapper authMapper,
            @Value("${application.security.jwt.refresh-token-expiration:604800000}") long refreshTokenExpirationMs
    ) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.authMapper = authMapper;
        this.refreshTokenExpirationMs = refreshTokenExpirationMs;
    }

    @Override
    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        if (request.role() == UserRole.ADMIN) {
            throw new ConflictException("Public admin registration is not allowed");
        }

        String normalizedEmail = normalizeEmail(request.email());
        if (userRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new ConflictException("Email is already registered");
        }

        Role role = roleRepository.findByName(request.role())
                .orElseThrow(() -> new ConflictException("Selected role is not available"));

        User user = new User();
        user.setRole(role);
        user.setFullName(request.fullName().trim());
        user.setEmail(normalizedEmail);
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setPhone(normalizeBlank(request.phoneNumber()));
        user.setEmailVerified(false);
        user.setActive(true);

        return authMapper.toRegisterResponse(userRepository.save(user));
    }

    @Override
    @Transactional
    public LoginResponse login(LoginRequest request, HttpServletRequest httpRequest) {
        User user = userRepository.findByEmailIgnoreCaseAndDeletedAtIsNull(normalizeEmail(request.email()))
                .orElseThrow(() -> new UnauthorizedException(GENERIC_AUTH_FAILURE));

        if (!passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new UnauthorizedException(GENERIC_AUTH_FAILURE);
        }

        validateUserCanLogin(user);

        user.setFailedLoginAttempts(0);
        user.setLastLoginAt(LocalDateTime.now());

        CustomUserPrincipal principal = new CustomUserPrincipal(user);
        String accessToken = jwtService.generateAccessToken(principal);
        String refreshToken = createRefreshToken(user, httpRequest);

        return new LoginResponse(
                accessToken,
                refreshToken,
                jwtService.getAccessTokenExpirationSeconds(),
                authMapper.toAuthUserResponse(user)
        );
    }

    @Override
    @Transactional
    public RefreshTokenResponse refresh(String refreshToken, HttpServletRequest httpRequest) {
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new UnauthorizedException("Invalid refresh token");
        }

        RefreshToken currentToken = refreshTokenRepository.findByTokenHashAndRevokedFalse(hashToken(refreshToken))
                .orElseThrow(() -> new UnauthorizedException("Invalid refresh token"));

        if (currentToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            currentToken.setRevoked(true);
            throw new UnauthorizedException("Invalid refresh token");
        }

        User user = currentToken.getUser();
        validateUserCanLogin(user);

        currentToken.setRevoked(true);
        CustomUserPrincipal principal = new CustomUserPrincipal(user);
        String newAccessToken = jwtService.generateAccessToken(principal);
        String newRefreshToken = createRefreshToken(user, httpRequest);

        return new RefreshTokenResponse(
                newAccessToken,
                newRefreshToken,
                jwtService.getAccessTokenExpirationSeconds()
        );
    }

    @Override
    @Transactional
    public void logout(String refreshToken) {
        if (refreshToken == null || refreshToken.isBlank()) {
            return;
        }

        refreshTokenRepository.findByTokenHash(hashToken(refreshToken))
                .ifPresent(token -> token.setRevoked(true));
    }

    private String createRefreshToken(User user, HttpServletRequest httpRequest) {
        String rawToken = UUID.randomUUID() + "." + UUID.randomUUID();

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUser(user);
        refreshToken.setTokenHash(hashToken(rawToken));
        refreshToken.setExpiresAt(LocalDateTime.now().plusNanos(refreshTokenExpirationMs * 1_000_000));
        refreshToken.setRevoked(false);
        refreshToken.setIpAddress(httpRequest.getRemoteAddr());
        refreshToken.setDeviceInfo(httpRequest.getHeader("User-Agent"));

        refreshTokenRepository.save(refreshToken);
        return rawToken;
    }

    private void validateUserCanLogin(User user) {
        if (!user.isActive()) {
            throw new UnauthorizedException(GENERIC_AUTH_FAILURE);
        }
        if (user.getLockedUntil() != null && user.getLockedUntil().isAfter(LocalDateTime.now())) {
            throw new UnauthorizedException(GENERIC_AUTH_FAILURE);
        }
    }

    private String normalizeEmail(String email) {
        return email == null ? null : email.trim().toLowerCase();
    }

    private String normalizeBlank(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private String hashToken(String token) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(token.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException("SHA-256 algorithm is not available", exception);
        }
    }
}
