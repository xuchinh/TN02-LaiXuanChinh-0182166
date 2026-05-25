import { AxiosError } from "axios";
import type { ApiResponse } from "@/types/api.types";

export function extractApiErrorMessage(error: unknown): string {
  const axiosError = error as AxiosError<ApiResponse<unknown>>;
  return axiosError.response?.data?.message ?? "Không thể kết nối đến hệ thống. Vui lòng thử lại.";
}
