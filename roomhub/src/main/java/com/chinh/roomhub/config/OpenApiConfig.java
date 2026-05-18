package com.chinh.roomhub.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI roomHubOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("RoomHub API")
                        .version("v1")
                        .description("Production-ready REST API documentation for RoomHub."));
    }
}
