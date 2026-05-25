import { useMutation } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { authApi } from "@/features/auth/api/auth.api";
import type { LoginRequest } from "@/features/auth/types/auth.types";
import { useAuthStore } from "@/store/auth.store";

export function useLogin() {
  const router = useRouter();
  const setSession = useAuthStore((state) => state.setSession);

  return useMutation({
    mutationFn: (payload: LoginRequest) => authApi.login(payload),
    onSuccess: (response) => {
      setSession(response.data.accessToken, response.data.refreshToken, response.data.user);
      router.push("/dashboard");
    }
  });
}
