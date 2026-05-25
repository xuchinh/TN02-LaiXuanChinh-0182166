-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 24, 2026 lúc 01:01 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `roomhub`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `action` varchar(100) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `blog_posts`
--

CREATE TABLE `blog_posts` (
  `id` bigint(20) NOT NULL,
  `author_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `excerpt` varchar(500) DEFAULT NULL,
  `content` longtext NOT NULL,
  `thumbnail_url` varchar(500) DEFAULT NULL,
  `status` enum('DRAFT','PUBLISHED','ARCHIVED') NOT NULL DEFAULT 'DRAFT',
  `view_count` bigint(20) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) NOT NULL,
  `tenant_id` bigint(20) NOT NULL,
  `landlord_id` bigint(20) NOT NULL,
  `post_id` bigint(20) NOT NULL,
  `room_id` bigint(20) NOT NULL,
  `booking_date` datetime NOT NULL DEFAULT current_timestamp(),
  `message` varchar(1000) DEFAULT NULL,
  `status` enum('PENDING','CONFIRMED','REJECTED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupons`
--

CREATE TABLE `coupons` (
  `id` bigint(20) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `discount_type` enum('PERCENTAGE','FIXED') NOT NULL,
  `discount_value` decimal(12,2) NOT NULL,
  `minimum_order_amount` decimal(12,2) DEFAULT 0.00,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `expires_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `description`, `discount_type`, `discount_value`, `minimum_order_amount`, `usage_limit`, `used_count`, `expires_at`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'WELCOME10', '10 percent discount for new landlord', 'PERCENTAGE', 10.00, 50000.00, 100, 0, '2027-12-31 23:59:59', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(2, 'ROOMHUB50K', 'Flat 50k discount', 'FIXED', 50000.00, 100000.00, 50, 0, '2027-12-31 23:59:59', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon_usages`
--

CREATE TABLE `coupon_usages` (
  `id` bigint(20) NOT NULL,
  `coupon_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `subscription_order_id` bigint(20) NOT NULL,
  `used_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `favorites`
--

CREATE TABLE `favorites` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `post_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `motels`
--

CREATE TABLE `motels` (
  `id` bigint(20) NOT NULL,
  `owner_id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `ward` varchar(100) DEFAULT NULL,
  `district` varchar(100) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payment_transactions`
--

CREATE TABLE `payment_transactions` (
  `id` bigint(20) NOT NULL,
  `subscription_order_id` bigint(20) NOT NULL,
  `payment_provider` varchar(50) NOT NULL,
  `transaction_reference` varchar(150) DEFAULT NULL,
  `provider_response_code` varchar(50) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'VND',
  `status` enum('PENDING','SUCCESS','FAILED','CANCELLED','REFUNDED') NOT NULL DEFAULT 'PENDING',
  `paid_at` datetime DEFAULT NULL,
  `raw_response` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `posts`
--

CREATE TABLE `posts` (
  `id` bigint(20) NOT NULL,
  `landlord_id` bigint(20) NOT NULL,
  `motel_id` bigint(20) NOT NULL,
  `room_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` enum('DRAFT','PENDING','APPROVED','REJECTED','EXPIRED','ARCHIVED') NOT NULL DEFAULT 'PENDING',
  `is_boosted` tinyint(1) NOT NULL DEFAULT 0,
  `boosted_until` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `view_count` bigint(20) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `post_images`
--

CREATE TABLE `post_images` (
  `id` bigint(20) NOT NULL,
  `post_id` bigint(20) NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked` tinyint(1) NOT NULL DEFAULT 0,
  `device_info` varchar(255) DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked`, `device_info`, `ip_address`, `created_at`) VALUES
(1, 2, 'c9d9db96364e3cff86efeedbb88651c6627255b530b2cc6a5a4faf245dea753e', '2026-05-29 17:16:40', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '0:0:0:0:0:0:0:1', '2026-05-22 17:16:40'),
(2, 3, 'fa8d1cee6a8408f14617d3a3c027ffc70446c7ee4ae8bd187d0d96aea78f762e', '2026-05-29 17:20:41', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '0:0:0:0:0:0:0:1', '2026-05-22 17:20:41'),
(3, 3, '28a29f9629d9d6b7c7a29b8e795530c502fd0d3d22608b92069aef0c71b07e84', '2026-05-31 17:42:55', 0, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '0:0:0:0:0:0:0:1', '2026-05-24 17:42:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reports`
--

CREATE TABLE `reports` (
  `id` bigint(20) NOT NULL,
  `reporter_id` bigint(20) NOT NULL,
  `target_type` enum('POST','REVIEW','USER','BLOG') NOT NULL,
  `target_id` bigint(20) NOT NULL,
  `reason` varchar(1000) NOT NULL,
  `status` enum('OPEN','IN_REVIEW','RESOLVED','REJECTED') NOT NULL DEFAULT 'OPEN',
  `admin_note` varchar(1000) DEFAULT NULL,
  `resolved_by` bigint(20) DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) NOT NULL,
  `booking_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `motel_id` bigint(20) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'ADMIN', 'System administrator', '2026-05-22 16:41:59'),
(2, 'LANDLORD', 'Property owner / landlord', '2026-05-22 16:41:59'),
(3, 'TENANT', 'Tenant / renter', '2026-05-22 16:41:59');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `role_feature_permissions`
--

CREATE TABLE `role_feature_permissions` (
  `id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `feature_id` bigint(20) NOT NULL,
  `can_access` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `role_feature_permissions`
--

INSERT INTO `role_feature_permissions` (`id`, `role_id`, `feature_id`, `can_access`, `created_at`) VALUES
(1, 1, 1, 1, '2026-05-22 16:42:00'),
(2, 1, 2, 1, '2026-05-22 16:42:00'),
(3, 1, 3, 1, '2026-05-22 16:42:00'),
(4, 1, 4, 1, '2026-05-22 16:42:00'),
(5, 1, 5, 1, '2026-05-22 16:42:00'),
(6, 1, 6, 1, '2026-05-22 16:42:00'),
(7, 1, 7, 1, '2026-05-22 16:42:00'),
(8, 1, 8, 1, '2026-05-22 16:42:00'),
(16, 2, 1, 1, '2026-05-22 16:42:00'),
(17, 2, 2, 1, '2026-05-22 16:42:00'),
(18, 2, 3, 0, '2026-05-22 16:42:00'),
(19, 2, 4, 1, '2026-05-22 16:42:00'),
(20, 2, 5, 1, '2026-05-22 16:42:00'),
(21, 2, 6, 1, '2026-05-22 16:42:00'),
(22, 2, 7, 0, '2026-05-22 16:42:00'),
(23, 2, 8, 0, '2026-05-22 16:42:00'),
(24, 3, 1, 0, '2026-05-22 16:42:00'),
(25, 3, 2, 0, '2026-05-22 16:42:00'),
(26, 3, 3, 0, '2026-05-22 16:42:00'),
(27, 3, 4, 1, '2026-05-22 16:42:00'),
(28, 3, 5, 1, '2026-05-22 16:42:00'),
(29, 3, 6, 0, '2026-05-22 16:42:00'),
(30, 3, 7, 0, '2026-05-22 16:42:00'),
(31, 3, 8, 0, '2026-05-22 16:42:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `rooms`
--

CREATE TABLE `rooms` (
  `id` bigint(20) NOT NULL,
  `motel_id` bigint(20) NOT NULL,
  `room_number` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(12,2) NOT NULL,
  `deposit` decimal(12,2) NOT NULL DEFAULT 0.00,
  `area` decimal(8,2) DEFAULT NULL,
  `capacity` int(11) NOT NULL DEFAULT 1,
  `electricity_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `water_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `internet_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('AVAILABLE','RESERVED','RENTED','MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `room_images`
--

CREATE TABLE `room_images` (
  `id` bigint(20) NOT NULL,
  `room_id` bigint(20) NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `service_plans`
--

CREATE TABLE `service_plans` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `price` decimal(12,2) NOT NULL,
  `duration_days` int(11) NOT NULL,
  `boost_quota` int(11) NOT NULL DEFAULT 0,
  `analytics_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `featured_listing_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `priority_support_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `service_plans`
--

INSERT INTO `service_plans` (`id`, `name`, `description`, `price`, `duration_days`, `boost_quota`, `analytics_enabled`, `featured_listing_enabled`, `priority_support_enabled`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'FREE', 'Default free landlord plan', 0.00, 30, 0, 0, 0, 0, 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(2, 'STANDARD', 'Standard subscription plan', 99000.00, 30, 3, 1, 0, 0, 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(3, 'PREMIUM', 'Premium subscription plan', 199000.00, 30, 10, 1, 1, 1, 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint(20) NOT NULL,
  `landlord_id` bigint(20) NOT NULL,
  `service_plan_id` bigint(20) NOT NULL,
  `status` enum('ACTIVE','EXPIRED','CANCELLED','PENDING') NOT NULL DEFAULT 'PENDING',
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `remaining_boost_quota` int(11) NOT NULL DEFAULT 0,
  `auto_renew` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `subscription_orders`
--

CREATE TABLE `subscription_orders` (
  `id` bigint(20) NOT NULL,
  `landlord_id` bigint(20) NOT NULL,
  `service_plan_id` bigint(20) NOT NULL,
  `coupon_id` bigint(20) DEFAULT NULL,
  `original_amount` decimal(12,2) NOT NULL,
  `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `final_amount` decimal(12,2) NOT NULL,
  `status` enum('PENDING','PAID','FAILED','CANCELLED','REFUNDED') NOT NULL DEFAULT 'PENDING',
  `order_reference` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `system_features`
--

CREATE TABLE `system_features` (
  `id` bigint(20) NOT NULL,
  `feature_key` varchar(100) NOT NULL,
  `feature_name` varchar(150) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `system_features`
--

INSERT INTO `system_features` (`id`, `feature_key`, `feature_name`, `description`, `is_enabled`, `created_at`, `updated_at`) VALUES
(1, 'POST_BOOST', 'Post Boost', 'Allow landlords to boost rental listings', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(2, 'ADVANCED_ANALYTICS', 'Advanced Analytics', 'Allow access to premium analytics dashboard', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(3, 'BLOG_MANAGEMENT', 'Blog Management', 'Allow blog content management', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(4, 'REVIEW_SYSTEM', 'Review System', 'Allow tenant reviews and ratings', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(5, 'BOOKING_SYSTEM', 'Booking System', 'Allow booking / rental requests', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(6, 'PAYMENT_SYSTEM', 'Payment System', 'Allow subscription payment features', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(7, 'USER_MANAGEMENT', 'User Management', 'Admin user management access', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00'),
(8, 'REPORT_MODERATION', 'Report Moderation', 'Admin moderation workflow', 1, '2026-05-22 16:42:00', '2026-05-22 16:42:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `email_verified` tinyint(1) NOT NULL DEFAULT 0,
  `email_verified_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `failed_login_attempts` int(11) NOT NULL DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `role_id`, `full_name`, `email`, `password_hash`, `phone`, `avatar_url`, `email_verified`, `email_verified_at`, `is_active`, `failed_login_attempts`, `locked_until`, `last_login_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'System Administrator', 'admin@roomhub.com', '$2a$10$TEMP_REPLACE_WITH_BCRYPT_HASH', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, '2026-05-22 16:41:59', '2026-05-22 16:41:59', NULL),
(2, 3, 'Nguyễn Văn A', 'guest@gmail.com', '$2a$10$SZCISLUyOxf7tKAt3bQmsuqdieFpr90tpTASXxUi8ajsCetv0Mnh6', '0912345678', NULL, 0, NULL, 1, 0, NULL, '2026-05-22 17:16:40', '2026-05-22 17:16:30', '2026-05-22 17:16:40', NULL),
(3, 2, 'Địa Chủ Bóc Lột', 'tenant@gmail.com', '$2a$10$B.rFJmWBxjUGvgs6wciNreoKrJ7OLn7Jyvlz/cVOCOcgRMF6T314K', '0912345679', NULL, 0, NULL, 1, 0, NULL, '2026-05-24 17:42:55', '2026-05-22 17:20:31', '2026-05-24 17:42:55', NULL);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activity_user` (`user_id`);

--
-- Chỉ mục cho bảng `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_blog_author` (`author_id`),
  ADD KEY `idx_blog_status` (`status`),
  ADD KEY `idx_blog_slug` (`slug`);

--
-- Chỉ mục cho bảng `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_booking_post` (`post_id`),
  ADD KEY `idx_booking_tenant` (`tenant_id`),
  ADD KEY `idx_booking_landlord` (`landlord_id`),
  ADD KEY `idx_booking_room` (`room_id`),
  ADD KEY `idx_booking_status` (`status`);

--
-- Chỉ mục cho bảng `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_coupon_code` (`code`),
  ADD KEY `idx_coupon_active` (`is_active`);

--
-- Chỉ mục cho bảng `coupon_usages`
--
ALTER TABLE `coupon_usages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_coupon_usage_order` (`subscription_order_id`),
  ADD KEY `idx_coupon_usage_coupon` (`coupon_id`),
  ADD KEY `idx_coupon_usage_user` (`user_id`);

--
-- Chỉ mục cho bảng `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_post_favorite` (`user_id`,`post_id`),
  ADD KEY `fk_favorite_post` (`post_id`),
  ADD KEY `idx_favorite_user` (`user_id`);

--
-- Chỉ mục cho bảng `motels`
--
ALTER TABLE `motels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_motel_owner` (`owner_id`),
  ADD KEY `idx_motel_city` (`city`),
  ADD KEY `idx_motel_district` (`district`),
  ADD KEY `idx_motel_active` (`is_active`);

--
-- Chỉ mục cho bảng `payment_transactions`
--
ALTER TABLE `payment_transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transaction_reference` (`transaction_reference`),
  ADD KEY `idx_payment_order` (`subscription_order_id`),
  ADD KEY `idx_payment_status` (`status`),
  ADD KEY `idx_payment_reference` (`transaction_reference`);

--
-- Chỉ mục cho bảng `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_post_motel` (`motel_id`),
  ADD KEY `idx_post_landlord` (`landlord_id`),
  ADD KEY `idx_post_room` (`room_id`),
  ADD KEY `idx_post_status` (`status`),
  ADD KEY `idx_post_boosted` (`is_boosted`),
  ADD KEY `idx_post_created` (`created_at`);

--
-- Chỉ mục cho bảng `post_images`
--
ALTER TABLE `post_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_post_image_post` (`post_id`);

--
-- Chỉ mục cho bảng `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_refresh_user` (`user_id`),
  ADD KEY `idx_refresh_expiry` (`expires_at`);

--
-- Chỉ mục cho bảng `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_report_resolver` (`resolved_by`),
  ADD KEY `idx_report_status` (`status`),
  ADD KEY `idx_report_target` (`target_type`,`target_id`),
  ADD KEY `idx_report_reporter` (`reporter_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_booking_review` (`booking_id`),
  ADD KEY `idx_review_motel` (`motel_id`),
  ADD KEY `idx_review_user` (`user_id`);

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Chỉ mục cho bảng `role_feature_permissions`
--
ALTER TABLE `role_feature_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_role_feature` (`role_id`,`feature_id`),
  ADD KEY `fk_role_permission_feature` (`feature_id`),
  ADD KEY `idx_role_permission_role` (`role_id`);

--
-- Chỉ mục cho bảng `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_room_number_per_motel` (`motel_id`,`room_number`),
  ADD KEY `idx_room_motel` (`motel_id`),
  ADD KEY `idx_room_status` (`status`),
  ADD KEY `idx_room_price` (`price`),
  ADD KEY `idx_room_active` (`is_active`);

--
-- Chỉ mục cho bảng `room_images`
--
ALTER TABLE `room_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_room_image_room` (`room_id`);

--
-- Chỉ mục cho bảng `service_plans`
--
ALTER TABLE `service_plans`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `idx_plan_active` (`is_active`);

--
-- Chỉ mục cho bảng `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_subscription_plan` (`service_plan_id`),
  ADD KEY `idx_subscription_landlord` (`landlord_id`),
  ADD KEY `idx_subscription_status` (`status`),
  ADD KEY `idx_subscription_expiry` (`ends_at`);

--
-- Chỉ mục cho bảng `subscription_orders`
--
ALTER TABLE `subscription_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_reference` (`order_reference`),
  ADD KEY `fk_order_plan` (`service_plan_id`),
  ADD KEY `fk_order_coupon` (`coupon_id`),
  ADD KEY `idx_order_landlord` (`landlord_id`),
  ADD KEY `idx_order_status` (`status`),
  ADD KEY `idx_order_reference` (`order_reference`);

--
-- Chỉ mục cho bảng `system_features`
--
ALTER TABLE `system_features`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `feature_key` (`feature_key`),
  ADD KEY `idx_feature_enabled` (`is_enabled`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_role` (`role_id`),
  ADD KEY `idx_users_active` (`is_active`),
  ADD KEY `idx_users_deleted` (`deleted_at`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `blog_posts`
--
ALTER TABLE `blog_posts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `coupon_usages`
--
ALTER TABLE `coupon_usages`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `motels`
--
ALTER TABLE `motels`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `payment_transactions`
--
ALTER TABLE `payment_transactions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `post_images`
--
ALTER TABLE `post_images`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `reports`
--
ALTER TABLE `reports`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `role_feature_permissions`
--
ALTER TABLE `role_feature_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT cho bảng `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `room_images`
--
ALTER TABLE `room_images`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `service_plans`
--
ALTER TABLE `service_plans`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `subscription_orders`
--
ALTER TABLE `subscription_orders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `system_features`
--
ALTER TABLE `system_features`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `blog_posts`
--
ALTER TABLE `blog_posts`
  ADD CONSTRAINT `fk_blog_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_booking_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `fk_booking_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  ADD CONSTRAINT `fk_booking_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `coupon_usages`
--
ALTER TABLE `coupon_usages`
  ADD CONSTRAINT `fk_coupon_usage_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
  ADD CONSTRAINT `fk_coupon_usage_order` FOREIGN KEY (`subscription_order_id`) REFERENCES `subscription_orders` (`id`),
  ADD CONSTRAINT `fk_coupon_usage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `fk_favorite_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `motels`
--
ALTER TABLE `motels`
  ADD CONSTRAINT `fk_motel_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `payment_transactions`
--
ALTER TABLE `payment_transactions`
  ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`subscription_order_id`) REFERENCES `subscription_orders` (`id`);

--
-- Các ràng buộc cho bảng `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `fk_post_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_post_motel` FOREIGN KEY (`motel_id`) REFERENCES `motels` (`id`),
  ADD CONSTRAINT `fk_post_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);

--
-- Các ràng buộc cho bảng `post_images`
--
ALTER TABLE `post_images`
  ADD CONSTRAINT `fk_post_image_post` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`);

--
-- Các ràng buộc cho bảng `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `fk_refresh_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `fk_report_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_report_resolver` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_review_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  ADD CONSTRAINT `fk_review_motel` FOREIGN KEY (`motel_id`) REFERENCES `motels` (`id`),
  ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `role_feature_permissions`
--
ALTER TABLE `role_feature_permissions`
  ADD CONSTRAINT `fk_role_permission_feature` FOREIGN KEY (`feature_id`) REFERENCES `system_features` (`id`),
  ADD CONSTRAINT `fk_role_permission_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Các ràng buộc cho bảng `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `fk_room_motel` FOREIGN KEY (`motel_id`) REFERENCES `motels` (`id`);

--
-- Các ràng buộc cho bảng `room_images`
--
ALTER TABLE `room_images`
  ADD CONSTRAINT `fk_room_image_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);

--
-- Các ràng buộc cho bảng `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `fk_subscription_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_subscription_plan` FOREIGN KEY (`service_plan_id`) REFERENCES `service_plans` (`id`);

--
-- Các ràng buộc cho bảng `subscription_orders`
--
ALTER TABLE `subscription_orders`
  ADD CONSTRAINT `fk_order_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`),
  ADD CONSTRAINT `fk_order_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_order_plan` FOREIGN KEY (`service_plan_id`) REFERENCES `service_plans` (`id`);

--
-- Các ràng buộc cho bảng `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
