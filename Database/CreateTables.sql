-- =============================================
-- Script tạo Database cho SaoViet API
-- Project: ASP.NET Core 7.0
-- Author: Nguyen Xuan Nhan
-- Team: 4FT
-- Copyright (C) 2023 4FT. All rights reserved
-- License: MIT
-- =============================================

USE master;
GO

-- Tạo Database nếu chưa tồn tại
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SaoVietDB')
BEGIN
    CREATE DATABASE SaoVietDB;
    PRINT 'Database SaoVietDB đã được tạo thành công.';
END
ELSE
BEGIN
    PRINT 'Database SaoVietDB đã tồn tại.';
END
GO

USE SaoVietDB;
GO

-- =============================================
-- 1. Tạo bảng ASP.NET Identity (AspNetUsers, AspNetRoles, etc.)
-- =============================================

-- AspNetUsers (ApplicationUser)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetUsers')
BEGIN
    CREATE TABLE AspNetUsers (
        Id NVARCHAR(450) NOT NULL PRIMARY KEY,
        UserName NVARCHAR(256) NULL,
        NormalizedUserName NVARCHAR(256) NULL,
        Email NVARCHAR(256) NULL,
        NormalizedEmail NVARCHAR(256) NULL,
        EmailConfirmed BIT NOT NULL DEFAULT 0,
        PasswordHash NVARCHAR(MAX) NULL,
        SecurityStamp NVARCHAR(MAX) NULL,
        ConcurrencyStamp NVARCHAR(MAX) NULL,
        PhoneNumber NVARCHAR(MAX) NULL,
        PhoneNumberConfirmed BIT NOT NULL DEFAULT 0,
        TwoFactorEnabled BIT NOT NULL DEFAULT 0,
        LockoutEnd DATETIMEOFFSET(7) NULL,
        LockoutEnabled BIT NOT NULL DEFAULT 0,
        AccessFailedCount INT NOT NULL DEFAULT 0
    );
    
    CREATE UNIQUE INDEX IX_AspNetUsers_NormalizedUserName 
        ON AspNetUsers(NormalizedUserName) WHERE NormalizedUserName IS NOT NULL;
    
    CREATE INDEX IX_AspNetUsers_NormalizedEmail 
        ON AspNetUsers(NormalizedEmail) WHERE NormalizedEmail IS NOT NULL;
    
    PRINT 'Bảng AspNetUsers đã được tạo thành công.';
END
GO

-- AspNetRoles
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetRoles')
BEGIN
    CREATE TABLE AspNetRoles (
        Id NVARCHAR(450) NOT NULL PRIMARY KEY,
        Name NVARCHAR(256) NULL,
        NormalizedName NVARCHAR(256) NULL,
        ConcurrencyStamp NVARCHAR(MAX) NULL
    );
    
    CREATE UNIQUE INDEX IX_AspNetRoles_NormalizedName 
        ON AspNetRoles(NormalizedName) WHERE NormalizedName IS NOT NULL;
    
    PRINT 'Bảng AspNetRoles đã được tạo thành công.';
END
GO

-- AspNetUserRoles
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetUserRoles')
BEGIN
    CREATE TABLE AspNetUserRoles (
        UserId NVARCHAR(450) NOT NULL,
        RoleId NVARCHAR(450) NOT NULL,
        PRIMARY KEY (UserId, RoleId),
        CONSTRAINT FK_AspNetUserRoles_AspNetUsers FOREIGN KEY (UserId) 
            REFERENCES AspNetUsers(Id) ON DELETE CASCADE,
        CONSTRAINT FK_AspNetUserRoles_AspNetRoles FOREIGN KEY (RoleId) 
            REFERENCES AspNetRoles(Id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_AspNetUserRoles_RoleId ON AspNetUserRoles(RoleId);
    
    PRINT 'Bảng AspNetUserRoles đã được tạo thành công.';
END
GO

-- AspNetUserClaims
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetUserClaims')
BEGIN
    CREATE TABLE AspNetUserClaims (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        UserId NVARCHAR(450) NOT NULL,
        ClaimType NVARCHAR(MAX) NULL,
        ClaimValue NVARCHAR(MAX) NULL,
        CONSTRAINT FK_AspNetUserClaims_AspNetUsers FOREIGN KEY (UserId) 
            REFERENCES AspNetUsers(Id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_AspNetUserClaims_UserId ON AspNetUserClaims(UserId);
    
    PRINT 'Bảng AspNetUserClaims đã được tạo thành công.';
END
GO

-- AspNetUserLogins
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetUserLogins')
BEGIN
    CREATE TABLE AspNetUserLogins (
        LoginProvider NVARCHAR(450) NOT NULL,
        ProviderKey NVARCHAR(450) NOT NULL,
        ProviderDisplayName NVARCHAR(MAX) NULL,
        UserId NVARCHAR(450) NOT NULL,
        PRIMARY KEY (LoginProvider, ProviderKey),
        CONSTRAINT FK_AspNetUserLogins_AspNetUsers FOREIGN KEY (UserId) 
            REFERENCES AspNetUsers(Id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_AspNetUserLogins_UserId ON AspNetUserLogins(UserId);
    
    PRINT 'Bảng AspNetUserLogins đã được tạo thành công.';
END
GO

-- AspNetUserTokens
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetUserTokens')
BEGIN
    CREATE TABLE AspNetUserTokens (
        UserId NVARCHAR(450) NOT NULL,
        LoginProvider NVARCHAR(450) NOT NULL,
        Name NVARCHAR(450) NOT NULL,
        Value NVARCHAR(MAX) NULL,
        PRIMARY KEY (UserId, LoginProvider, Name),
        CONSTRAINT FK_AspNetUserTokens_AspNetUsers FOREIGN KEY (UserId) 
            REFERENCES AspNetUsers(Id) ON DELETE CASCADE
    );
    
    PRINT 'Bảng AspNetUserTokens đã được tạo thành công.';
END
GO

-- AspNetRoleClaims
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AspNetRoleClaims')
BEGIN
    CREATE TABLE AspNetRoleClaims (
        Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        RoleId NVARCHAR(450) NOT NULL,
        ClaimType NVARCHAR(MAX) NULL,
        ClaimValue NVARCHAR(MAX) NULL,
        CONSTRAINT FK_AspNetRoleClaims_AspNetRoles FOREIGN KEY (RoleId) 
            REFERENCES AspNetRoles(Id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_AspNetRoleClaims_RoleId ON AspNetRoleClaims(RoleId);
    
    PRINT 'Bảng AspNetRoleClaims đã được tạo thành công.';
END
GO

-- =============================================
-- 2. Tạo bảng RefreshTokens (JWT Authentication)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RefreshTokens')
BEGIN
    CREATE TABLE RefreshTokens (
        id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        userId NVARCHAR(450) NULL,
        token VARCHAR(MAX) NULL,
        jwtId NVARCHAR(450) NULL,
        isUsed BIT NOT NULL DEFAULT 0,
        isRevoked BIT NOT NULL DEFAULT 0,
        addedDate DATETIME2 NULL,
        expiryDate DATETIME2 NULL
    );
    
    CREATE INDEX IX_RefreshTokens_userId ON RefreshTokens(userId);
    CREATE INDEX IX_RefreshTokens_jwtId ON RefreshTokens(jwtId);
    
    PRINT 'Bảng RefreshTokens đã được tạo thành công.';
END
GO

-- =============================================
-- 3. Tạo bảng Branches (Chi nhánh)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Branches')
BEGIN
    CREATE TABLE Branches (
        id CHAR(5) NOT NULL PRIMARY KEY,
        name NVARCHAR(50) NOT NULL,
        address NVARCHAR(80) NULL
    );
    
    PRINT 'Bảng Branches đã được tạo thành công.';
END
GO

-- =============================================
-- 4. Tạo bảng Teachers (Giáo viên)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Teachers')
BEGIN
    CREATE TABLE Teachers (
        id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        fullName NVARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        phone CHAR(10) NULL,
        customerId NVARCHAR(450) NULL,
        CONSTRAINT FK_Teachers_AspNetUsers FOREIGN KEY (customerId) 
            REFERENCES AspNetUsers(Id) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_Teachers_customerId ON Teachers(customerId);
    CREATE INDEX IX_Teachers_email ON Teachers(email);
    
    PRINT 'Bảng Teachers đã được tạo thành công.';
END
GO

-- =============================================
-- 5. Tạo bảng Classes (Lớp học)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Classes')
BEGIN
    CREATE TABLE Classes (
        id CHAR(7) NOT NULL PRIMARY KEY,
        name NVARCHAR(25) NOT NULL,
        startDate DATE NOT NULL,
        endDate DATE NOT NULL,
        teacherId UNIQUEIDENTIFIER NULL,
        branchId CHAR(5) NULL,
        CONSTRAINT FK_Classes_Teachers FOREIGN KEY (teacherId) 
            REFERENCES Teachers(id) ON DELETE SET NULL,
        CONSTRAINT FK_Classes_Branches FOREIGN KEY (branchId) 
            REFERENCES Branches(id) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_Classes_teacherId ON Classes(teacherId);
    CREATE INDEX IX_Classes_branchId ON Classes(branchId);
    CREATE INDEX IX_Classes_startDate ON Classes(startDate);
    CREATE INDEX IX_Classes_endDate ON Classes(endDate);
    
    PRINT 'Bảng Classes đã được tạo thành công.';
END
GO

-- =============================================
-- 6. Tạo bảng Students (Học viên)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Students')
BEGIN
    CREATE TABLE Students (
        id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        fullName NVARCHAR(50) NOT NULL,
        dob DATE NULL,
        email VARCHAR(50) NOT NULL,
        phone CHAR(10) NULL
    );
    
    CREATE INDEX IX_Students_email ON Students(email);
    CREATE INDEX IX_Students_phone ON Students(phone);
    
    PRINT 'Bảng Students đã được tạo thành công.';
END
GO

-- =============================================
-- 7. Tạo bảng ClassStudents (Quan hệ nhiều-nhiều: Lớp-Học viên)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ClassStudents')
BEGIN
    CREATE TABLE ClassStudents (
        classId CHAR(7) NOT NULL,
        studentId UNIQUEIDENTIFIER NOT NULL,
        PRIMARY KEY (classId, studentId),
        CONSTRAINT FK_ClassStudents_Classes FOREIGN KEY (classId) 
            REFERENCES Classes(id) ON DELETE CASCADE,
        CONSTRAINT FK_ClassStudents_Students FOREIGN KEY (studentId) 
            REFERENCES Students(id) ON DELETE NO ACTION
    );
    
    CREATE INDEX IX_ClassStudents_studentId ON ClassStudents(studentId);
    
    PRINT 'Bảng ClassStudents đã được tạo thành công.';
END
GO

-- =============================================
-- 8. Tạo bảng Categories (Danh mục khóa học)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
    CREATE TABLE Categories (
        id CHAR(5) NOT NULL PRIMARY KEY,
        name NVARCHAR(25) NOT NULL
    );
    
    PRINT 'Bảng Categories đã được tạo thành công.';
END
GO

-- =============================================
-- 9. Tạo bảng Courses (Khóa học)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Courses')
BEGIN
    CREATE TABLE Courses (
        id CHAR(5) NOT NULL PRIMARY KEY,
        name NVARCHAR(20) NOT NULL,
        description NVARCHAR(MAX) NULL,
        categoryId CHAR(5) NULL,
        CONSTRAINT FK_Courses_Categories FOREIGN KEY (categoryId) 
            REFERENCES Categories(id) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_Courses_categoryId ON Courses(categoryId);
    
    PRINT 'Bảng Courses đã được tạo thành công.';
END
GO

-- =============================================
-- 10. Tạo bảng Lessons (Bài học)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Lessons')
BEGIN
    CREATE TABLE Lessons (
        id CHAR(10) NOT NULL PRIMARY KEY,
        name NVARCHAR(50) NOT NULL,
        description NVARCHAR(MAX) NULL,
        courseId CHAR(5) NULL,
        CONSTRAINT FK_Lessons_Courses FOREIGN KEY (courseId) 
            REFERENCES Courses(id) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_Lessons_courseId ON Lessons(courseId);
    
    PRINT 'Bảng Lessons đã được tạo thành công.';
END
GO

-- =============================================
-- 11. Tạo bảng Attendance (Điểm danh)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Attendance')
BEGIN
    CREATE TABLE Attendance (
        classId CHAR(7) NOT NULL,
        lessonId CHAR(10) NOT NULL,
        date DATE NOT NULL,
        comment NVARCHAR(70) NULL,
        evaluation TINYINT NULL,
        attendance TINYINT NULL,
        PRIMARY KEY (classId, lessonId),
        CONSTRAINT FK_Attendance_Classes FOREIGN KEY (classId) 
            REFERENCES Classes(id) ON DELETE NO ACTION,
        CONSTRAINT FK_Attendance_Lessons FOREIGN KEY (lessonId) 
            REFERENCES Lessons(id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Attendance_date ON Attendance(date);
    
    PRINT 'Bảng Attendance đã được tạo thành công.';
END
GO

-- =============================================
-- 12. Thêm dữ liệu mẫu (Optional - Roles)
-- =============================================

-- Thêm các Role cơ bản
IF NOT EXISTS (SELECT * FROM AspNetRoles WHERE Name = 'Admin')
BEGIN
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (NEWID(), 'Admin', 'ADMIN', NEWID());
    PRINT 'Role Admin đã được thêm.';
END

IF NOT EXISTS (SELECT * FROM AspNetRoles WHERE Name = 'Teacher')
BEGIN
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (NEWID(), 'Teacher', 'TEACHER', NEWID());
    PRINT 'Role Teacher đã được thêm.';
END

IF NOT EXISTS (SELECT * FROM AspNetRoles WHERE Name = 'Student')
BEGIN
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (NEWID(), 'Student', 'STUDENT', NEWID());
    PRINT 'Role Student đã được thêm.';
END

IF NOT EXISTS (SELECT * FROM AspNetRoles WHERE Name = 'President')
BEGIN
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp)
    VALUES (NEWID(), 'President', 'PRESIDENT', NEWID());
    PRINT 'Role President đã được thêm.';
END
GO

-- =============================================
-- Kết thúc Script
-- =============================================

PRINT '';
PRINT '==============================================';
PRINT 'Hoàn tất tạo tất cả các bảng cho SaoViet API!';
PRINT '==============================================';
PRINT '';
PRINT 'Tổng số bảng đã tạo:';
PRINT '  - 7 bảng ASP.NET Identity (Users, Roles, Claims, etc.)';
PRINT '  - 1 bảng RefreshTokens';
PRINT '  - 1 bảng Branches';
PRINT '  - 1 bảng Teachers';
PRINT '  - 1 bảng Classes';
PRINT '  - 1 bảng Students';
PRINT '  - 1 bảng ClassStudents';
PRINT '  - 1 bảng Categories';
PRINT '  - 1 bảng Courses';
PRINT '  - 1 bảng Lessons';
PRINT '  - 1 bảng Attendance';
PRINT '';
PRINT 'Bạn có thể bắt đầu sử dụng API ngay bây giờ!';
GO
