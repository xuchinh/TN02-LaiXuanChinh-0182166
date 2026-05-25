package com.chinh.roomhub.config;

import com.chinh.roomhub.common.enums.UserRole;
import com.chinh.roomhub.users.entity.Role;
import com.chinh.roomhub.users.repository.RoleRepository;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataInitializer {

    @Bean
    ApplicationRunner seedRoles(RoleRepository roleRepository) {
        return args -> {
            createRoleIfMissing(roleRepository, UserRole.ADMIN, "System administrator");
            createRoleIfMissing(roleRepository, UserRole.LANDLORD, "Property owner / landlord");
            createRoleIfMissing(roleRepository, UserRole.TENANT, "Tenant / renter");
        };
    }

    private void createRoleIfMissing(RoleRepository roleRepository, UserRole role, String description) {
        if (!roleRepository.existsByName(role)) {
            roleRepository.save(new Role(role, description));
        }
    }
}
