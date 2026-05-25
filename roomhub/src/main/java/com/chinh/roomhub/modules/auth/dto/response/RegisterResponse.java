package com.chinh.roomhub.auth.dto.response;

import java.time.LocalDateTime;

import com.chinh.roomhub.common.enums.UserRole;

public record RegisterResponse(
        Long id,
        String email,
        String fullName,
        UserRole role,
        LocalDateTime createdAt
) {
}
