"use client";

import { Button, Card, Descriptions, Result, Tag } from "antd";
import { useLogout } from "@/features/auth/hooks/useLogout";
import { useAuthStore } from "@/store/auth.store";
import type { UserRole, UserStatus } from "@/features/auth/types/auth.types";

const roleLabels: Record<UserRole, string> = {
  ADMIN: "Quản trị viên",
  LANDLORD: "Chủ trọ",
  TENANT: "Người thuê"
};

const statusLabels: Record<UserStatus, string> = {
  ACTIVE: "Đang hoạt động",
  LOCKED: "Đã khóa",
  INACTIVE: "Chưa kích hoạt"
};

export function AuthPanel() {
  const user = useAuthStore((state) => state.user);
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const logoutMutation = useLogout();

  if (!isAuthenticated || !user) {
    return (
      <Result
        status="403"
        title="Bạn chưa đăng nhập"
        subTitle="Vui lòng đăng nhập để kiểm tra phiên xác thực Phase 2."
        extra={<Button href="/login" type="primary">Đăng nhập</Button>}
      />
    );
  }

  return (
    <Card className="dashboard-card" title="Phiên đăng nhập hiện tại">
      <Descriptions bordered column={1}>
        <Descriptions.Item label="Họ tên">{user.fullName}</Descriptions.Item>
        <Descriptions.Item label="Email">{user.email}</Descriptions.Item>
        <Descriptions.Item label="Vai trò">
          <Tag color={user.role === "LANDLORD" ? "blue" : user.role === "TENANT" ? "green" : "red"}>
            {roleLabels[user.role]}
          </Tag>
        </Descriptions.Item>
        <Descriptions.Item label="Trạng thái">{statusLabels[user.status] ?? user.status}</Descriptions.Item>
      </Descriptions>

      <Button className="dashboard-action" danger loading={logoutMutation.isPending} onClick={() => logoutMutation.mutate()}>
        Đăng xuất
      </Button>
    </Card>
  );
}
