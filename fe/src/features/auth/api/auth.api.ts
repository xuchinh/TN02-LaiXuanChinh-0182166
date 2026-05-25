import { apiClient } from "@/services/api-client";
import type { ApiResponse } from "@/types/api.types";
import type {
  LoginRequest,
  LoginResponse,
  RefreshTokenResponse,
  RegisterRequest,
  RegisterResponse
} from "@/features/auth/types/auth.types";

export const authApi = {
  async register(payload: RegisterRequest) {
    const response = await apiClient.post<ApiResponse<RegisterResponse>>("/auth/register", payload);
    return response.data;
  },

  async login(payload: LoginRequest) {
    const response = await apiClient.post<ApiResponse<LoginResponse>>("/auth/login", payload);
    return response.data;
  },

  async refresh() {
    const response = await apiClient.post<ApiResponse<RefreshTokenResponse>>("/auth/refresh", {});
    return response.data;
  },

  async logout(refreshToken?: string | null) {
    const response = await apiClient.post<ApiResponse<null>>(
      "/auth/logout",
      refreshToken ? { refreshToken } : {}
    );
    return response.data;
  }
};
