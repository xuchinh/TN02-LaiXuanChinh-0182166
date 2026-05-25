import { useMutation } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { authApi } from "@/features/auth/api/auth.api";
import type { RegisterRequest } from "@/features/auth/types/auth.types";

export function useRegister() {
  const router = useRouter();

  return useMutation({
    mutationFn: (payload: RegisterRequest) => authApi.register(payload),
    onSuccess: () => {
      router.push("/login?registered=1");
    }
  });
}
