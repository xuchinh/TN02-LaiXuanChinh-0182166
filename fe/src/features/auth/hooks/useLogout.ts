import { useMutation } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { authApi } from "@/features/auth/api/auth.api";
import { useAuthStore } from "@/store/auth.store";

export function useLogout() {
  const router = useRouter();
  const clearSession = useAuthStore((state) => state.logout);
  const refreshToken = useAuthStore((state) => state.refreshToken);

  return useMutation({
    mutationFn: () => authApi.logout(refreshToken),
    onSettled: () => {
      clearSession();
      router.push("/login");
    }
  });
}
