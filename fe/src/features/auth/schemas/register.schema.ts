import { z } from "zod";

export const registerSchema = z
  .object({
    fullName: z
      .string()
      .min(2, "Họ tên phải có ít nhất 2 ký tự")
      .max(100, "Họ tên không được vượt quá 100 ký tự"),
    email: z.string().min(1, "Vui lòng nhập email").email("Email không hợp lệ"),
    phoneNumber: z
      .string()
      .optional()
      .refine((value) => !value || /^0\d{9}$/.test(value), "Số điện thoại không hợp lệ"),
    role: z.enum(["TENANT", "LANDLORD"], {
      required_error: "Vui lòng chọn vai trò"
    }),
    password: z
      .string()
      .min(8, "Mật khẩu phải có ít nhất 8 ký tự")
      .regex(/[a-z]/, "Mật khẩu cần có chữ thường")
      .regex(/[A-Z]/, "Mật khẩu cần có chữ hoa")
      .regex(/\d/, "Mật khẩu cần có số")
      .regex(/[^A-Za-z0-9]/, "Mật khẩu cần có ký tự đặc biệt"),
    confirmPassword: z.string().min(1, "Vui lòng xác nhận mật khẩu")
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Mật khẩu xác nhận không khớp",
    path: ["confirmPassword"]
  });

export type RegisterFormValues = z.infer<typeof registerSchema>;
