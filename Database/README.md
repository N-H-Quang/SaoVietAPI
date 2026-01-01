# Hướng Dẫn Sử Dụng SQL Scripts

## Mô Tả

Thư mục này chứa các SQL scripts để tạo database và các bảng cần thiết cho SaoVietAPI.

## File SQL

### CreateTables.sql

Script SQL hoàn chỉnh để tạo toàn bộ database schema cho SaoVietAPI.

**Bao gồm:**
- Database `SaoVietDB`
- 7 bảng ASP.NET Identity (Users, Roles, UserRoles, UserClaims, UserLogins, UserTokens, RoleClaims)
- 1 bảng RefreshTokens (JWT Authentication)
- 1 bảng Branches (Chi nhánh)
- 1 bảng Teachers (Giáo viên)
- 1 bảng Classes (Lớp học)
- 1 bảng Students (Học viên)
- 1 bảng ClassStudents (Quan hệ Lớp-Học viên)
- 1 bảng Categories (Danh mục khóa học)
- 1 bảng Courses (Khóa học)
- 1 bảng Lessons (Bài học)
- 1 bảng Attendance (Điểm danh)
- Dữ liệu mẫu cho 4 Roles: Admin, Teacher, Student, President

## Cách Sử Dụng

### Phương Pháp 1: SQL Server Management Studio (SSMS)

1. Mở SQL Server Management Studio
2. Kết nối đến SQL Server instance của bạn
3. Mở file `CreateTables.sql`
4. Nhấn `F5` hoặc click nút "Execute" để chạy script
5. Kiểm tra Messages để xem kết quả

### Phương Pháp 2: Command Line (sqlcmd)

```bash
sqlcmd -S <server_name> -U <username> -P <password> -i CreateTables.sql
```

Ví dụ:
```bash
sqlcmd -S localhost -U sa -P YourPassword123 -i CreateTables.sql
```

### Phương Pháp 3: Azure Data Studio

1. Mở Azure Data Studio
2. Kết nối đến SQL Server
3. Mở file `CreateTables.sql`
4. Nhấn `F5` hoặc click "Run" để thực thi
5. Xem kết quả trong tab Messages

### Phương Pháp 4: Từ .NET Core (Alternative)

Nếu bạn muốn sử dụng Entity Framework Migrations thay vì SQL script:

```bash
# Xóa các migrations cũ (nếu có)
dotnet ef migrations remove

# Tạo migration mới
dotnet ef migrations add InitialCreate --project Infrastructure --startup-project WebAPI/WebAPI

# Cập nhật database
dotnet ef database update --project Infrastructure --startup-project WebAPI/WebAPI
```

## Cấu Trúc Database

### Sơ Đồ Quan Hệ

```
AspNetUsers (ApplicationUser)
    └── Teachers (1-n)
            └── Classes (1-n)
                    ├── ClassStudents (n-n) ── Students
                    └── Attendance (1-n) ── Lessons
                                                └── Courses (1-n)
                                                        └── Categories (1-n)
Branches
    └── Classes (1-n)
```

### Các Bảng Chính

#### 1. AspNetUsers
- **Mục đích:** Quản lý tài khoản người dùng (ASP.NET Identity)
- **Primary Key:** Id (NVARCHAR(450))
- **Quan hệ:** 1-n với Teachers

#### 2. Teachers
- **Mục đích:** Quản lý thông tin giáo viên
- **Primary Key:** id (UNIQUEIDENTIFIER)
- **Foreign Keys:** customerId → AspNetUsers.Id

#### 3. Students
- **Mục đích:** Quản lý thông tin học viên
- **Primary Key:** id (UNIQUEIDENTIFIER)
- **Quan hệ:** n-n với Classes qua ClassStudents

#### 4. Classes
- **Mục đích:** Quản lý lớp học
- **Primary Key:** id (CHAR(7))
- **Foreign Keys:** 
  - teacherId → Teachers.id
  - branchId → Branches.id

#### 5. ClassStudents
- **Mục đích:** Bảng trung gian quản lý học viên trong lớp
- **Composite Primary Key:** (classId, studentId)
- **Foreign Keys:**
  - classId → Classes.id
  - studentId → Students.id

#### 6. Courses
- **Mục đích:** Quản lý khóa học
- **Primary Key:** id (CHAR(5))
- **Foreign Keys:** categoryId → Categories.id

#### 7. Lessons
- **Mục đích:** Quản lý bài học trong khóa
- **Primary Key:** id (CHAR(10))
- **Foreign Keys:** courseId → Courses.id

#### 8. Attendance
- **Mục đích:** Quản lý điểm danh
- **Composite Primary Key:** (classId, lessonId)
- **Foreign Keys:**
  - classId → Classes.id
  - lessonId → Lessons.id

#### 9. RefreshTokens
- **Mục đích:** Quản lý JWT refresh tokens
- **Primary Key:** id (BIGINT IDENTITY)
- **Foreign Keys:** userId → AspNetUsers.Id (implicit)

## Kiểm Tra Sau Khi Chạy Script

Để kiểm tra các bảng đã được tạo thành công:

```sql
USE SaoVietDB;
GO

-- Liệt kê tất cả các bảng
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- Kiểm tra số lượng bảng
SELECT COUNT(*) AS TotalTables
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

-- Kiểm tra Roles đã được thêm
SELECT * FROM AspNetRoles;
```

## Connection String

Cập nhật connection string trong `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=SaoVietDB;User Id=sa;Password=YourPassword123;TrustServerCertificate=True"
  }
}
```

Hoặc sử dụng Windows Authentication:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=SaoVietDB;Integrated Security=True;TrustServerCertificate=True"
  }
}
```

## Lưu Ý

1. **Script an toàn:** Tất cả các lệnh CREATE TABLE đều có kiểm tra `IF NOT EXISTS`, nên có thể chạy nhiều lần mà không gây lỗi.

2. **Foreign Keys:** Script đã thiết lập đầy đủ các foreign key constraints với các hành động ON DELETE phù hợp:
   - `CASCADE`: Xóa cascade khi xóa parent
   - `SET NULL`: Set NULL khi xóa parent
   - `NO ACTION`: Không cho phép xóa nếu có child records

3. **Indexes:** Script tạo indexes cho các foreign keys và các cột thường xuyên được query để tối ưu performance.

4. **Default Values:** Các trường như GUID, IDENTITY, và DEFAULT constraints đã được thiết lập sẵn.

## Troubleshooting

### Lỗi: Database already exists
Script sẽ bỏ qua và sử dụng database hiện tại. Điều này là bình thường.

### Lỗi: Login failed
Kiểm tra lại username/password và quyền của user trên SQL Server.

### Lỗi: Cannot create table
Kiểm tra xem database đã được tạo và bạn đang kết nối đúng database.

## Xóa Database (Nếu Cần)

**⚠️ CẢNH BÁO:** Lệnh này sẽ xóa toàn bộ database và dữ liệu!

```sql
USE master;
GO

DROP DATABASE IF EXISTS SaoVietDB;
GO
```

## Hỗ Trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra SQL Server error log
2. Đảm bảo SQL Server service đang chạy
3. Kiểm tra user có đủ quyền CREATE DATABASE và CREATE TABLE
4. Liên hệ team qua email: nguyenxuannhan407@gmail.com

---

**Copyright (C) 2023 4FT. All rights reserved**  
**License:** MIT
