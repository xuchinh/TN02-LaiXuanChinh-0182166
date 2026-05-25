package com.chinh.roomhub.auth.repository;

import java.util.Optional;

import com.chinh.roomhub.auth.entity.RefreshToken;
import com.chinh.roomhub.users.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {

    Optional<RefreshToken> findByTokenHashAndRevokedFalse(String tokenHash);

    Optional<RefreshToken> findByTokenHash(String tokenHash);

    void deleteByUser(User user);
}
