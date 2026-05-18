package com.chinh.roomhub.health;

import java.time.Instant;

import com.chinh.roomhub.common.ApiResponse;
import com.chinh.roomhub.common.HealthResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    private final String applicationName;
    private final JdbcTemplate jdbcTemplate;

    public HealthController(
            @Value("${spring.application.name}") String applicationName,
            JdbcTemplate jdbcTemplate
    ) {
        this.applicationName = applicationName;
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/health")
    public ApiResponse<HealthResponse> health() {
        String databaseStatus = getDatabaseStatus();
        String applicationStatus = "UP".equals(databaseStatus) ? "UP" : "DEGRADED";

        HealthResponse response = new HealthResponse(
                applicationStatus,
                applicationName,
                "v1",
                databaseStatus,
                Instant.now()
        );

        return ApiResponse.success("RoomHub backend is running", response);
    }

    private String getDatabaseStatus() {
        try {
            Integer result = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            return Integer.valueOf(1).equals(result) ? "UP" : "DOWN";
        } catch (Exception exception) {
            return "DOWN";
        }
    }
}
