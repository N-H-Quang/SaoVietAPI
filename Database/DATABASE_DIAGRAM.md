# Sơ đồ Cơ sở dữ liệu SaoVietDB

## Mục lục

- [Tổng quan](#tổng-quan)
- [Sơ đồ quan hệ (ER Diagram)](#sơ-đồ-quan-hệ-er-diagram)
- [Chi tiết các bảng](#chi-tiết-các-bảng)
  - [Bảng ASP.NET Identity](#bảng-aspnet-identity)
  - [Bảng ứng dụng](#bảng-ứng-dụng)
- [Quan hệ giữa các bảng](#quan-hệ-giữa-các-bảng)
- [Hướng dẫn tạo Database](#hướng-dẫn-tạo-database)

## Tổng quan

Cơ sở dữ liệu SaoVietDB được thiết kế để quản lý hệ thống trung tâm tin học Sao Việt, bao gồm:

- **Quản lý người dùng và xác thực**: Sử dụng ASP.NET Identity
- **Quản lý giáo viên**: Thông tin giáo viên, liên kết với tài khoản người dùng
- **Quản lý chi nhánh**: Các chi nhánh của trung tâm
- **Quản lý lớp học**: Các lớp học, ngày bắt đầu/kết thúc, giáo viên phụ trách
- **Quản lý học sinh**: Thông tin học sinh
- **Quản lý khóa học**: Danh mục, khóa học và bài học
- **Quản lý điểm danh**: Theo dõi điểm danh và đánh giá

## Sơ đồ quan hệ (ER Diagram)

```mermaid
erDiagram
    AspNetUsers ||--o{ AspNetUserRoles : has
    AspNetUsers ||--o{ AspNetUserClaims : has
    AspNetUsers ||--o{ AspNetUserLogins : has
    AspNetUsers ||--o{ AspNetUserTokens : has
    AspNetUsers ||--o{ Teachers : manages
    
    AspNetRoles ||--o{ AspNetUserRoles : has
    AspNetRoles ||--o{ AspNetRoleClaims : has
    
    Teachers ||--o{ Classes : teaches
    
    Branches ||--o{ Classes : contains
    
    Classes ||--o{ ClassStudents : has
    Classes ||--o{ Attendance : tracks
    
    Students ||--o{ ClassStudents : enrolled
    
    Categories ||--o{ Courses : contains
    
    Courses ||--o{ Lessons : has
    
    Lessons ||--o{ Attendance : recorded
    
    AspNetUsers {
        nvarchar(450) Id PK
        nvarchar(256) UserName
        nvarchar(256) NormalizedUserName
        nvarchar(256) Email
        nvarchar(256) NormalizedEmail
        bit EmailConfirmed
        nvarchar(max) PasswordHash
        nvarchar(max) SecurityStamp
        nvarchar(max) ConcurrencyStamp
        nvarchar(max) PhoneNumber
        bit PhoneNumberConfirmed
        bit TwoFactorEnabled
        datetimeoffset LockoutEnd
        bit LockoutEnabled
        int AccessFailedCount
    }
    
    AspNetRoles {
        nvarchar(450) Id PK
        nvarchar(256) Name
        nvarchar(256) NormalizedName
        nvarchar(max) ConcurrencyStamp
    }
    
    AspNetUserRoles {
        nvarchar(450) UserId PK_FK
        nvarchar(450) RoleId PK_FK
    }
    
    AspNetUserClaims {
        int Id PK
        nvarchar(450) UserId FK
        nvarchar(max) ClaimType
        nvarchar(max) ClaimValue
    }
    
    AspNetUserLogins {
        nvarchar(450) LoginProvider PK
        nvarchar(450) ProviderKey PK
        nvarchar(max) ProviderDisplayName
        nvarchar(450) UserId FK
    }
    
    AspNetUserTokens {
        nvarchar(450) UserId PK_FK
        nvarchar(450) LoginProvider PK
        nvarchar(450) Name PK
        nvarchar(max) Value
    }
    
    AspNetRoleClaims {
        int Id PK
        nvarchar(450) RoleId FK
        nvarchar(max) ClaimType
        nvarchar(max) ClaimValue
    }
    
    RefreshTokens {
        bigint id PK
        nvarchar(450) userId
        varchar(max) token
        nvarchar(450) jwtId
        bit isUsed
        bit isRevoked
        datetime2 addedDate
        datetime2 expiryDate
    }
    
    Teachers {
        uniqueidentifier id PK
        nvarchar(50) fullName
        varchar(50) email
        char(10) phone
        nvarchar(450) customerId FK
    }
    
    Branches {
        char(5) id PK
        nvarchar(50) name
        nvarchar(80) address
    }
    
    Classes {
        char(7) id PK
        nvarchar(25) name
        date startDate
        date endDate
        uniqueidentifier teacherId FK
        char(5) branchId FK
    }
    
    Students {
        uniqueidentifier id PK
        nvarchar(50) fullName
        date dob
        varchar(50) email
        char(10) phone
    }
    
    ClassStudents {
        char(7) classId PK_FK
        uniqueidentifier studentId PK_FK
    }
    
    Categories {
        char(5) id PK
        nvarchar(25) name
    }
    
    Courses {
        char(5) id PK
        nvarchar(20) name
        nvarchar(max) description
        char(5) categoryId FK
    }
    
    Lessons {
        char(10) id PK
        nvarchar(50) name
        nvarchar(max) description
        char(5) courseId FK
    }
    
    Attendance {
        char(7) classId PK_FK
        char(10) lessonId PK_FK
        date date
        nvarchar(70) comment
        tinyint evaluation
        tinyint attendance
    }
```

## Chi tiết các bảng

### Bảng ASP.NET Identity

#### AspNetUsers
Bảng lưu trữ thông tin người dùng của hệ thống.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| Id | NVARCHAR(450) | Khóa chính |
| UserName | NVARCHAR(256) | Tên đăng nhập |
| NormalizedUserName | NVARCHAR(256) | Tên đăng nhập chuẩn hóa |
| Email | NVARCHAR(256) | Email |
| NormalizedEmail | NVARCHAR(256) | Email chuẩn hóa |
| EmailConfirmed | BIT | Xác nhận email |
| PasswordHash | NVARCHAR(MAX) | Mật khẩu đã hash |
| SecurityStamp | NVARCHAR(MAX) | Dấu bảo mật |
| ConcurrencyStamp | NVARCHAR(MAX) | Dấu đồng thời |
| PhoneNumber | NVARCHAR(MAX) | Số điện thoại |
| PhoneNumberConfirmed | BIT | Xác nhận số điện thoại |
| TwoFactorEnabled | BIT | Bật xác thực 2 yếu tố |
| LockoutEnd | DATETIMEOFFSET | Thời gian kết thúc khóa |
| LockoutEnabled | BIT | Bật khóa tài khoản |
| AccessFailedCount | INT | Số lần đăng nhập thất bại |

#### AspNetRoles
Bảng lưu trữ các vai trò trong hệ thống.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| Id | NVARCHAR(450) | Khóa chính |
| Name | NVARCHAR(256) | Tên vai trò |
| NormalizedName | NVARCHAR(256) | Tên vai trò chuẩn hóa |
| ConcurrencyStamp | NVARCHAR(MAX) | Dấu đồng thời |

#### AspNetUserRoles
Bảng liên kết người dùng với vai trò (quan hệ nhiều-nhiều).

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| UserId | NVARCHAR(450) | Khóa ngoại tới AspNetUsers |
| RoleId | NVARCHAR(450) | Khóa ngoại tới AspNetRoles |

### Bảng ứng dụng

#### RefreshTokens
Bảng lưu trữ refresh token cho JWT authentication.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | BIGINT | Khóa chính (tự tăng) |
| userId | NVARCHAR(450) | ID người dùng |
| token | VARCHAR(MAX) | Token |
| jwtId | NVARCHAR(450) | ID của JWT |
| isUsed | BIT | Đã sử dụng |
| isRevoked | BIT | Đã thu hồi |
| addedDate | DATETIME2 | Ngày tạo |
| expiryDate | DATETIME2 | Ngày hết hạn |

#### Teachers
Bảng lưu trữ thông tin giáo viên.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | UNIQUEIDENTIFIER | Khóa chính |
| fullName | NVARCHAR(50) | Họ và tên |
| email | VARCHAR(50) | Email |
| phone | CHAR(10) | Số điện thoại |
| customerId | NVARCHAR(450) | Khóa ngoại tới AspNetUsers |

#### Branches
Bảng lưu trữ thông tin chi nhánh.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | CHAR(5) | Khóa chính |
| name | NVARCHAR(50) | Tên chi nhánh |
| address | NVARCHAR(80) | Địa chỉ |

#### Classes
Bảng lưu trữ thông tin lớp học.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | CHAR(7) | Khóa chính |
| name | NVARCHAR(25) | Tên lớp |
| startDate | DATE | Ngày bắt đầu |
| endDate | DATE | Ngày kết thúc |
| teacherId | UNIQUEIDENTIFIER | Khóa ngoại tới Teachers |
| branchId | CHAR(5) | Khóa ngoại tới Branches |

#### Students
Bảng lưu trữ thông tin học sinh.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | UNIQUEIDENTIFIER | Khóa chính |
| fullName | NVARCHAR(50) | Họ và tên |
| dob | DATE | Ngày sinh |
| email | VARCHAR(50) | Email |
| phone | CHAR(10) | Số điện thoại |

#### ClassStudents
Bảng liên kết lớp học với học sinh (quan hệ nhiều-nhiều).

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| classId | CHAR(7) | Khóa ngoại tới Classes |
| studentId | UNIQUEIDENTIFIER | Khóa ngoại tới Students |

#### Categories
Bảng lưu trữ danh mục khóa học.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | CHAR(5) | Khóa chính |
| name | NVARCHAR(25) | Tên danh mục |

#### Courses
Bảng lưu trữ thông tin khóa học.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | CHAR(5) | Khóa chính |
| name | NVARCHAR(20) | Tên khóa học |
| description | NVARCHAR(MAX) | Mô tả |
| categoryId | CHAR(5) | Khóa ngoại tới Categories |

#### Lessons
Bảng lưu trữ thông tin bài học.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| id | CHAR(10) | Khóa chính |
| name | NVARCHAR(50) | Tên bài học |
| description | NVARCHAR(MAX) | Mô tả |
| courseId | CHAR(5) | Khóa ngoại tới Courses |

#### Attendance
Bảng lưu trữ thông tin điểm danh.

| Cột | Kiểu dữ liệu | Mô tả |
|-----|--------------|-------|
| classId | CHAR(7) | Khóa ngoại tới Classes |
| lessonId | CHAR(10) | Khóa ngoại tới Lessons |
| date | DATE | Ngày điểm danh |
| comment | NVARCHAR(70) | Ghi chú |
| evaluation | TINYINT | Đánh giá |
| attendance | TINYINT | Trạng thái điểm danh |

## Quan hệ giữa các bảng

### Quan hệ 1-N (One-to-Many)

| Bảng cha | Bảng con | Mô tả | Hành vi xóa |
|----------|----------|-------|-------------|
| AspNetUsers | Teachers | Một người dùng có thể quản lý nhiều giáo viên | SET NULL |
| Teachers | Classes | Một giáo viên có thể dạy nhiều lớp | SET NULL |
| Branches | Classes | Một chi nhánh có thể có nhiều lớp | SET NULL |
| Categories | Courses | Một danh mục có thể có nhiều khóa học | SET NULL |
| Courses | Lessons | Một khóa học có thể có nhiều bài học | SET NULL |

### Quan hệ N-N (Many-to-Many)

| Bảng 1 | Bảng 2 | Bảng liên kết | Mô tả |
|--------|--------|---------------|-------|
| Classes | Students | ClassStudents | Một lớp có nhiều học sinh, một học sinh có thể học nhiều lớp |
| Classes | Lessons | Attendance | Theo dõi điểm danh của lớp theo bài học |

## Hướng dẫn tạo Database

### Cách 1: Sử dụng SQL Script

1. Mở SQL Server Management Studio (SSMS)
2. Kết nối đến SQL Server
3. Mở file `Database/SaoVietDB.sql`
4. Thực thi script

```bash
sqlcmd -S your_server -U your_username -P your_password -i Database/SaoVietDB.sql
```

### Cách 2: Sử dụng Entity Framework Migrations

1. Cấu hình connection string trong `appsettings.json`:

```json
"ConnectionStrings": {
    "DefaultConnection": "Data Source=your_server;Initial Catalog=SaoVietDB;User ID=your_username;Password=your_password;Integrated Security=True;TrustServerCertificate=True"
}
```

2. Tạo database từ migrations:

```bash
cd WebAPI
dotnet ef database update --project ../Infrastructure
```

### Cách 3: Restore từ Backup

Sử dụng file backup `SaoVietDB.bak` có sẵn trong repository:

```sql
RESTORE DATABASE SaoVietDB 
FROM DISK = 'path/to/SaoVietDB.bak'
WITH MOVE 'SaoVietDB' TO 'C:\Data\SaoVietDB.mdf',
     MOVE 'SaoVietDB_log' TO 'C:\Data\SaoVietDB_log.ldf'
```

---

@Copyright (C) 2023 4FT. All rights reserved
