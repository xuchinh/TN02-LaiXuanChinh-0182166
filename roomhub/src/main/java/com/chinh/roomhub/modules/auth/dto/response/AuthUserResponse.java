package com.chinh.roomhub.auth.dto.response;

import com.chinh.roomhub.common.enums.UserRole;
import com.chinh.roomhub.common.enums.UserStatus;

public record AuthUserResponse(
        Long id,
        String fullName,
        String email,
        UserRole role,
        String avatarUrl,
        UserStatus status
) {
}
