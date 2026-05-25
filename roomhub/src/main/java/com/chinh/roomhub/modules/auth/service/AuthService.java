package com.chinh.roomhub.auth.service;

import com.chinh.roomhub.auth.dto.request.LoginRequest;
import com.chinh.roomhub.auth.dto.request.RegisterRequest;
import com.chinh.roomhub.auth.dto.response.LoginResponse;
import com.chinh.roomhub.auth.dto.response.RefreshTokenResponse;
import com.chinh.roomhub.auth.dto.response.RegisterResponse;
import jakarta.servlet.http.HttpServletRequest;

public interface AuthService {

    RegisterResponse register(RegisterRequest request);

    LoginResponse login(LoginRequest request, HttpServletRequest httpRequest);

    RefreshTokenResponse refresh(String refreshToken, HttpServletRequest httpRequest);

    void logout(String refreshToken);
}
