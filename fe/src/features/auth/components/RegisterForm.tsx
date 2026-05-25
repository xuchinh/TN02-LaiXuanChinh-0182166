"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Alert, Button, Col, Divider, Input, Radio, Row, Typography } from "antd";
import Link from "next/link";
import { Controller, useForm } from "react-hook-form";
import { extractApiErrorMessage } from "@/lib/error";
import { useRegister } from "@/features/auth/hooks/useRegister";
import { registerSchema, type RegisterFormValues } from "@/features/auth/schemas/register.schema";

export function RegisterForm() {
  const registerMutation = useRegister();
  const {
    control,
    handleSubmit,
    formState: { errors }
  } = useForm<RegisterFormValues>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      fullName: "",
      email: "",
      phoneNumber: "",
      role: "TENANT",
      password: "",
      confirmPassword: ""
    }
  });

  return (
    <Row justify="center" className="auth-row">
      <Col xs={24} sm={22} md={18} lg={12} xl={10}>
        <fieldset className="auth-fieldset">
          <legend>Đăng ký tài khoản</legend>

          <div className="auth-copy">
            <Typography.Title level={3}>Tạo tài khoản RoomHub</Typography.Title>
            <Typography.Text>Chọn đúng vai trò để RoomHub cấp quyền phù hợp cho bạn.</Typography.Text>
          </div>

          {registerMutation.isError && (
            <Alert
              className="form-alert"
              type="error"
              message={extractApiErrorMessage(registerMutation.error)}
              showIcon
            />
          )}

          <form className="auth-form two-columns" onSubmit={handleSubmit((values) => {
            registerMutation.mutate({
              fullName: values.fullName,
              email: values.email,
              phoneNumber: values.phoneNumber,
              role: values.role,
              password: values.password
            });
          })}>
            <label>
              <span>Họ tên</span>
              <Controller
                name="fullName"
                control={control}
                render={({ field }) => (
                  <Input {...field} size="large" status={errors.fullName ? "error" : ""} placeholder="Nguyễn Văn A" />
                )}
              />
              {errors.fullName && <small>{errors.fullName.message}</small>}
            </label>

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
              <span>Số điện thoại</span>
              <Controller
                name="phoneNumber"
                control={control}
                render={({ field }) => (
                  <Input {...field} size="large" status={errors.phoneNumber ? "error" : ""} placeholder="0900000000" />
                )}
              />
              {errors.phoneNumber && <small>{errors.phoneNumber.message}</small>}
            </label>

            <label>
              <span>Vai trò</span>
              <Controller
                name="role"
                control={control}
                render={({ field }) => (
                  <Radio.Group {...field} size="large" className="role-group">
                    <Radio.Button value="TENANT">Người thuê</Radio.Button>
                    <Radio.Button value="LANDLORD">Chủ trọ</Radio.Button>
                  </Radio.Group>
                )}
              />
              {errors.role && <small>{errors.role.message}</small>}
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
                    placeholder="Tối thiểu 8 ký tự"
                  />
                )}
              />
              {errors.password && <small>{errors.password.message}</small>}
            </label>

            <label>
              <span>Xác nhận mật khẩu</span>
              <Controller
                name="confirmPassword"
                control={control}
                render={({ field }) => (
                  <Input.Password
                    {...field}
                    size="large"
                    status={errors.confirmPassword ? "error" : ""}
                    placeholder="Nhập lại mật khẩu"
                  />
                )}
              />
              {errors.confirmPassword && <small>{errors.confirmPassword.message}</small>}
            </label>

            <div className="form-actions">
              <Button type="primary" htmlType="submit" size="large" loading={registerMutation.isPending} block>
                Tạo tài khoản
              </Button>
            </div>
          </form>

          <Link className="back-home" href="/">← Quay lại trang chủ</Link>
          <Divider />
          <div className="auth-footer">
            Đã có tài khoản? <Link href="/login">Đăng nhập</Link>
          </div>
        </fieldset>
      </Col>
    </Row>
  );
}
