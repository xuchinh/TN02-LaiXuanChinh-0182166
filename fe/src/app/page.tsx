import { Button } from "antd";
import Link from "next/link";

export default function HomePage() {
  return (
    <main className="public-shell">
      <header className="topbar">
        <Link className="brand" href="/">RoomHub</Link>
        <nav className="nav-actions">
          <Link href="/login">Đăng nhập</Link>
          <Link href="/register">Đăng ký</Link>
        </nav>
      </header>

      <section className="hero">
        <div>
          <h1>Quản lý và tìm thuê phòng trọ rõ ràng hơn</h1>
          <p>
            RoomHub kết nối chủ trọ, người thuê và quản trị viên trong một hệ thống có phân quyền,
            xác thực JWT và nền tảng API thống nhất.
          </p>
          <div className="hero-actions">
            <Button type="primary" size="large" href="/register">Tạo tài khoản</Button>
            <Button size="large" href="/login">Đăng nhập</Button>
          </div>
        </div>

        <div className="feature-list">
          <div className="feature-item">Đăng ký theo vai trò người thuê hoặc chủ trọ</div>
          <div className="feature-item">Đăng nhập bằng JWT access token và refresh token</div>
          <div className="feature-item">Nền tảng sẵn sàng mở rộng sang quản lý nhà trọ, phòng và tin đăng</div>
        </div>
      </section>
    </main>
  );
}
