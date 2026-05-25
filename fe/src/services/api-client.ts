import axios from "axios";
import type { AxiosError, InternalAxiosRequestConfig } from "axios";
import { env } from "@/config/env";
import { useAuthStore } from "@/store/auth.store";
import type { ApiResponse } from "@/types/api.types";
import type { RefreshTokenResponse } from "@/features/auth/types/auth.types";

type RetriableRequestConfig = InternalAxiosRequestConfig & {
  _retry?: boolean;
};

export const apiClient = axios.create({
  baseURL: env.apiBaseUrl,
  timeout: 15000,
  withCredentials: true,
  headers: {
    "Content-Type": "application/json"
  }
});

apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().accessToken;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

apiClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as RetriableRequestConfig | undefined;
    const status = error.response?.status;
    const url = originalRequest?.url ?? "";

    if (!originalRequest || status !== 401 || originalRequest._retry || url.includes("/auth/")) {
      return Promise.reject(error);
    }

    originalRequest._retry = true;

    try {
      const refreshToken = useAuthStore.getState().refreshToken;
      const response = await apiClient.post<ApiResponse<RefreshTokenResponse>>(
        "/auth/refresh",
        refreshToken ? { refreshToken } : {}
      );

      useAuthStore.getState().setAccessToken(response.data.data.accessToken);
      useAuthStore.getState().setRefreshToken(response.data.data.refreshToken);
      originalRequest.headers.Authorization = `Bearer ${response.data.data.accessToken}`;

      return apiClient(originalRequest);
    } catch (refreshError) {
      useAuthStore.getState().logout();
      return Promise.reject(refreshError);
    }
  }
);
