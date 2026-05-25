import { create } from "zustand";
import { createJSONStorage, persist } from "zustand/middleware";
import type { AuthUser } from "@/features/auth/types/auth.types";

interface AuthState {
  accessToken: string | null;
  refreshToken: string | null;
  user: AuthUser | null;
  isAuthenticated: boolean;
  setSession: (accessToken: string, refreshToken: string | null, user: AuthUser) => void;
  setAccessToken: (accessToken: string) => void;
  setRefreshToken: (refreshToken: string | null) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      accessToken: null,
      refreshToken: null,
      user: null,
      isAuthenticated: false,
      setSession: (accessToken, refreshToken, user) =>
        set({ accessToken, refreshToken, user, isAuthenticated: true }),
      setAccessToken: (accessToken) => set({ accessToken, isAuthenticated: true }),
      setRefreshToken: (refreshToken) => set({ refreshToken }),
      logout: () => set({ accessToken: null, refreshToken: null, user: null, isAuthenticated: false })
    }),
    {
      name: "roomhub-auth-session",
      storage: createJSONStorage(() => sessionStorage)
    }
  )
);
