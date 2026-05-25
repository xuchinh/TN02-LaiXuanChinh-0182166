package com.chinh.roomhub.auth.dto.response;

public record LoginResponse(
        String accessToken,
        String refreshToken,
        long expiresIn,
        AuthUserResponse user
) {
}
