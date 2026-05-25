import { AuthPanel } from "@/features/auth/components/AuthPanel";

export default function DashboardPage() {
  return (
    <main className="dashboard-shell">
      <aside className="dashboard-sidebar">
        <div className="sidebar-brand">RoomHub</div>
        <nav>
          <a className="active" href="/dashboard">Dashboard</a>
          <span>Người dùng</span>
          <span>Nhà trọ</span>
          <span>Phòng trọ</span>
        </nav>
      </aside>

      <section className="dashboard-main">
        <header className="dashboard-header">
          <div>
            <h1>Bảng điều khiển Phase 2</h1>
            <p>Xác nhận đăng nhập, vai trò, trạng thái tài khoản và thao tác đăng xuất.</p>
          </div>
        </header>

        <AuthPanel />
      </section>
    </main>
  );
}
