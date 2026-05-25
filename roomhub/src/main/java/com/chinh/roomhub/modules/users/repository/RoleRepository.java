package com.chinh.roomhub.users.repository;

import java.util.Optional;

import com.chinh.roomhub.common.enums.UserRole;
import com.chinh.roomhub.users.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long> {

    Optional<Role> findByName(UserRole name);

    boolean existsByName(UserRole name);
}
