export type UserRole = "ADMIN" | "LANDLORD" | "TENANT";
export type UserStatus = "ACTIVE" | "LOCKED" | "INACTIVE";

export interface AuthUser {
  id: number;
  fullName: string;
  email: string;
  role: UserRole;
  avatarUrl: string | null;
  status: UserStatus;
}

export interface RegisterRequest {
  fullName: string;
  email: string;
  password: string;
  phoneNumber?: string;
  role: Exclude<UserRole, "ADMIN">;
}

export interface RegisterResponse {
  id: number;
  email: string;
  fullName: string;
  role: Exclude<UserRole, "ADMIN">;
  createdAt: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  user: AuthUser;
}

export interface RefreshTokenResponse {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}
