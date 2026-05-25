package com.chinh.roomhub.auth.controller;

import com.chinh.roomhub.auth.dto.request.LoginRequest;
import com.chinh.roomhub.auth.dto.request.LogoutRequest;
import com.chinh.roomhub.auth.dto.request.RefreshTokenRequest;
import com.chinh.roomhub.auth.dto.request.RegisterRequest;
import com.chinh.roomhub.auth.dto.response.LoginResponse;
import com.chinh.roomhub.auth.dto.response.RefreshTokenResponse;
import com.chinh.roomhub.auth.dto.response.RegisterResponse;
import com.chinh.roomhub.auth.service.AuthService;
import com.chinh.roomhub.common.ApiResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private static final String REFRESH_TOKEN_COOKIE = "roomhub_refresh_token";

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<RegisterResponse>> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success("Registration successful", authService.register(request)));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(
            @Valid @RequestBody LoginRequest request,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse
    ) {
        LoginResponse response = authService.login(request, httpRequest);
        addRefreshCookie(httpResponse, response.refreshToken());
        return ResponseEntity.ok(ApiResponse.success("Login successful", response));
    }

    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<RefreshTokenResponse>> refresh(
            @RequestBody(required = false) RefreshTokenRequest request,
            @CookieValue(value = REFRESH_TOKEN_COOKIE, required = false) String cookieRefreshToken,
            HttpServletRequest httpRequest,
            HttpServletResponse httpResponse
    ) {
        String refreshToken = resolveRefreshToken(request == null ? null : request.refreshToken(), cookieRefreshToken);
        RefreshTokenResponse response = authService.refresh(refreshToken, httpRequest);
        addRefreshCookie(httpResponse, response.refreshToken());
        return ResponseEntity.ok(ApiResponse.success("Token refreshed successfully", response));
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(
            @RequestBody(required = false) LogoutRequest request,
            @CookieValue(value = REFRESH_TOKEN_COOKIE, required = false) String cookieRefreshToken,
            HttpServletResponse httpResponse
    ) {
        authService.logout(resolveRefreshToken(request == null ? null : request.refreshToken(), cookieRefreshToken));
        clearRefreshCookie(httpResponse);
        return ResponseEntity.ok(ApiResponse.success("Logout successful"));
    }

    private String resolveRefreshToken(String requestToken, String cookieToken) {
        if (requestToken != null && !requestToken.isBlank()) {
            return requestToken;
        }
        return cookieToken;
    }

    private void addRefreshCookie(HttpServletResponse response, String refreshToken) {
        ResponseCookie cookie = ResponseCookie.from(REFRESH_TOKEN_COOKIE, refreshToken)
                .httpOnly(true)
                .secure(false)
                .sameSite("Lax")
                .path("/")
                .maxAge(7 * 24 * 60 * 60)
                .build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());
    }

    private void clearRefreshCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(REFRESH_TOKEN_COOKIE, "");
        cookie.setHttpOnly(true);
        cookie.setSecure(false);
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }
}
