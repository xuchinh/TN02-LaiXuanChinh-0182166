import "antd/dist/reset.css";
import "@ant-design/v5-patch-for-react-19";
import "./globals.css";
import type { Metadata } from "next";
import { AppProviders } from "@/providers/app-providers";

export const metadata: Metadata = {
  title: "RoomHub",
  description: "Nền tảng quản lý và tìm thuê phòng trọ"
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="vi">
      <body>
        <AppProviders>{children}</AppProviders>
      </body>
    </html>
  );
}
