"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Alert, Button, Col, Divider, Input, Row, Typography } from "antd";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { Controller, useForm } from "react-hook-form";
import { extractApiErrorMessage } from "@/lib/error";
import { useLogin } from "@/features/auth/hooks/useLogin";
import { loginSchema, type LoginFormValues } from "@/features/auth/schemas/login.schema";

export function LoginForm() {
  const searchParams = useSearchParams();
  const loginMutation = useLogin();
  const {
    control,
    handleSubmit,
    formState: { errors }
  } = useForm<LoginFormValues>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: "",
      password: ""
    }
  });

  return (
    <Row justify="center" className="auth-row">
      <Col xs={24} sm={20} md={14} lg={9} xl={7}>
        <fieldset className="auth-fieldset">
          <legend>Đăng nhập</legend>

          <div className="auth-copy">
            <Typography.Title level={3}>RoomHub</Typography.Title>
            <Typography.Text>Truy cập tài khoản để quản lý hoặc tìm thuê phòng trọ.</Typography.Text>
          </div>

          {searchParams.get("registered") === "1" && (
            <Alert
              className="form-alert"
              type="success"
              message="Đăng ký thành công. Bạn có thể đăng nhập ngay."
              showIcon
            />
          )}

          {loginMutation.isError && (
            <Alert
              className="form-alert"
              type="error"
              message={extractApiErrorMessage(loginMutation.error)}
              showIcon
            />
          )}

          <form className="auth-form" onSubmit={handleSubmit((values) => loginMutation.mutate(values))}>
            <label>
              <span>Email</span>
              <Controller
                name="email"
                control={control}
                render={({ field }) => (
                  <Input {...field} size="large" status={errors.email ? "error" : ""} placeholder="ban@example.com" />
                )}
              />
              {errors.email && <small>{errors.email.message}</small>}
            </label>

            <label>
              <span>Mật khẩu</span>
              <Controller
                name="password"
                control={control}
                render={({ field }) => (
                  <Input.Password
                    {...field}
                    size="large"
                    status={errors.password ? "error" : ""}
                    placeholder="Nhập mật khẩu"
                  />
                )}
              />
              {errors.password && <small>{errors.password.message}</small>}
            </label>

            <Button type="primary" htmlType="submit" size="large" loading={loginMutation.isPending} block>
              Đăng nhập
            </Button>
          </form>

          <Link className="back-home" href="/">← Quay lại trang chủ</Link>
          <Divider />
          <div className="auth-footer">
            Chưa có tài khoản? <Link href="/register">Đăng ký tại đây</Link>
          </div>
        </fieldset>
      </Col>
    </Row>
  );
}
