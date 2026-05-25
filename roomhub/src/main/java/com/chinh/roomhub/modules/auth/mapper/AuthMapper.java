package com.chinh.roomhub.auth.mapper;

import com.chinh.roomhub.auth.dto.response.AuthUserResponse;
import com.chinh.roomhub.auth.dto.response.RegisterResponse;
import com.chinh.roomhub.common.enums.UserStatus;
import com.chinh.roomhub.users.entity.User;
import org.springframework.stereotype.Component;

@Component
public class AuthMapper {

    public AuthUserResponse toAuthUserResponse(User user) {
        return new AuthUserResponse(
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getRole().getName(),
                user.getAvatarUrl(),
                resolveStatus(user)
        );
    }

    public RegisterResponse toRegisterResponse(User user) {
        return new RegisterResponse(
                user.getId(),
                user.getEmail(),
                user.getFullName(),
                user.getRole().getName(),
                user.getCreatedAt()
        );
    }

    private UserStatus resolveStatus(User user) {
        if (!user.isActive()) {
            return UserStatus.INACTIVE;
        }
        if (user.getLockedUntil() != null && user.getLockedUntil().isAfter(java.time.LocalDateTime.now())) {
            return UserStatus.LOCKED;
        }
        return UserStatus.ACTIVE;
    }
}
