-- =============================================
-- SaoVietDB Database Creation Script
-- Project: SaoViet API - Trung tâm tin học Sao Việt
-- Author: Nguyen Xuan Nhan
-- Team: 4FT
-- Copyright (C) 2023 4FT. All rights reserved
-- License: MIT
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SaoVietDB')
BEGIN
    CREATE DATABASE SaoVietDB;
END
GO

USE SaoVietDB;
GO

-- =============================================
-- ASP.NET Identity Tables
-- =============================================

-- AspNetUsers Table (ApplicationUser)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUsers' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUsers] (
        [Id] NVARCHAR(450) NOT NULL PRIMARY KEY,
        [UserName] NVARCHAR(256) NULL,
        [NormalizedUserName] NVARCHAR(256) NULL,
        [Email] NVARCHAR(256) NULL,
        [NormalizedEmail] NVARCHAR(256) NULL,
        [EmailConfirmed] BIT NOT NULL DEFAULT 0,
        [PasswordHash] NVARCHAR(MAX) NULL,
        [SecurityStamp] NVARCHAR(MAX) NULL,
        [ConcurrencyStamp] NVARCHAR(MAX) NULL,
        [PhoneNumber] NVARCHAR(MAX) NULL,
        [PhoneNumberConfirmed] BIT NOT NULL DEFAULT 0,
        [TwoFactorEnabled] BIT NOT NULL DEFAULT 0,
        [LockoutEnd] DATETIMEOFFSET NULL,
        [LockoutEnabled] BIT NOT NULL DEFAULT 0,
        [AccessFailedCount] INT NOT NULL DEFAULT 0
    );
    
    CREATE INDEX [IX_AspNetUsers_NormalizedEmail] ON [dbo].[AspNetUsers] ([NormalizedEmail]);
    CREATE UNIQUE INDEX [IX_AspNetUsers_NormalizedUserName] ON [dbo].[AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;
END
GO

-- AspNetRoles Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetRoles' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetRoles] (
        [Id] NVARCHAR(450) NOT NULL PRIMARY KEY,
        [Name] NVARCHAR(256) NULL,
        [NormalizedName] NVARCHAR(256) NULL,
        [ConcurrencyStamp] NVARCHAR(MAX) NULL
    );
    
    CREATE UNIQUE INDEX [IX_AspNetRoles_NormalizedName] ON [dbo].[AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;
END
GO

-- AspNetUserRoles Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserRoles' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserRoles] (
        [UserId] NVARCHAR(450) NOT NULL,
        [RoleId] NVARCHAR(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles] ([RoleId]);
END
GO

-- AspNetUserClaims Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserClaims' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserClaims] (
        [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [UserId] NVARCHAR(450) NOT NULL,
        [ClaimType] NVARCHAR(MAX) NULL,
        [ClaimValue] NVARCHAR(MAX) NULL,
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims] ([UserId]);
END
GO

-- AspNetUserLogins Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserLogins' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserLogins] (
        [LoginProvider] NVARCHAR(450) NOT NULL,
        [ProviderKey] NVARCHAR(450) NOT NULL,
        [ProviderDisplayName] NVARCHAR(MAX) NULL,
        [UserId] NVARCHAR(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins] ([UserId]);
END
GO

-- AspNetUserTokens Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetUserTokens' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetUserTokens] (
        [UserId] NVARCHAR(450) NOT NULL,
        [LoginProvider] NVARCHAR(450) NOT NULL,
        [Name] NVARCHAR(450) NOT NULL,
        [Value] NVARCHAR(MAX) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END
GO

-- AspNetRoleClaims Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AspNetRoleClaims' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[AspNetRoleClaims] (
        [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleId] NVARCHAR(450) NOT NULL,
        [ClaimType] NVARCHAR(MAX) NULL,
        [ClaimValue] NVARCHAR(MAX) NULL,
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims] ([RoleId]);
END
GO

-- =============================================
-- Application Tables
-- =============================================

-- RefreshTokens Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RefreshTokens' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[RefreshTokens] (
        [id] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [userId] NVARCHAR(450) NULL,
        [token] VARCHAR(MAX) NULL,
        [jwtId] NVARCHAR(450) NULL,
        [isUsed] BIT NOT NULL DEFAULT 0,
        [isRevoked] BIT NOT NULL DEFAULT 0,
        [addedDate] DATETIME2 NULL,
        [expiryDate] DATETIME2 NULL
    );
END
GO

-- Teachers Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Teachers' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Teachers] (
        [id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [fullName] NVARCHAR(50) NOT NULL,
        [email] VARCHAR(50) NOT NULL,
        [phone] CHAR(10) NULL,
        [customerId] NVARCHAR(450) NULL,
        CONSTRAINT [FK_Teachers_AspNetUsers_customerId] FOREIGN KEY ([customerId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE SET NULL
    );
    
    CREATE INDEX [IX_Teachers_customerId] ON [dbo].[Teachers] ([customerId]);
END
GO

-- Branches Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Branches' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Branches] (
        [id] CHAR(5) NOT NULL PRIMARY KEY,
        [name] NVARCHAR(50) NOT NULL,
        [address] NVARCHAR(80) NULL
    );
END
GO

-- Classes Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Classes' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Classes] (
        [id] CHAR(7) NOT NULL PRIMARY KEY,
        [name] NVARCHAR(25) NOT NULL,
        [startDate] DATE NOT NULL,
        [endDate] DATE NOT NULL,
        [teacherId] UNIQUEIDENTIFIER NULL,
        [branchId] CHAR(5) NULL,
        CONSTRAINT [FK_Classes_Teachers_teacherId] FOREIGN KEY ([teacherId]) REFERENCES [dbo].[Teachers] ([id]) ON DELETE SET NULL,
        CONSTRAINT [FK_Classes_Branches_branchId] FOREIGN KEY ([branchId]) REFERENCES [dbo].[Branches] ([id]) ON DELETE SET NULL
    );
    
    CREATE INDEX [IX_Classes_teacherId] ON [dbo].[Classes] ([teacherId]);
    CREATE INDEX [IX_Classes_branchId] ON [dbo].[Classes] ([branchId]);
END
GO

-- Students Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Students' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Students] (
        [id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [fullName] NVARCHAR(50) NOT NULL,
        [dob] DATE NULL,
        [email] VARCHAR(50) NOT NULL,
        [phone] CHAR(10) NULL
    );
END
GO

-- ClassStudents Table (Many-to-Many relationship between Classes and Students)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ClassStudents' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[ClassStudents] (
        [classId] CHAR(7) NOT NULL,
        [studentId] UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT [PK_ClassStudents] PRIMARY KEY ([classId], [studentId]),
        CONSTRAINT [FK_ClassStudents_Classes_classId] FOREIGN KEY ([classId]) REFERENCES [dbo].[Classes] ([id]) ON DELETE CASCADE,
        CONSTRAINT [FK_ClassStudents_Students_studentId] FOREIGN KEY ([studentId]) REFERENCES [dbo].[Students] ([id]) ON DELETE NO ACTION
    );
    
    CREATE INDEX [IX_ClassStudents_studentId] ON [dbo].[ClassStudents] ([studentId]);
END
GO

-- Categories Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Categories' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Categories] (
        [id] CHAR(5) NOT NULL PRIMARY KEY,
        [name] NVARCHAR(25) NOT NULL
    );
END
GO

-- Courses Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Courses] (
        [id] CHAR(5) NOT NULL PRIMARY KEY,
        [name] NVARCHAR(20) NOT NULL,
        [description] NVARCHAR(MAX) NULL,
        [categoryId] CHAR(5) NULL,
        CONSTRAINT [FK_Courses_Categories_categoryId] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[Categories] ([id]) ON DELETE SET NULL
    );
    
    CREATE INDEX [IX_Courses_categoryId] ON [dbo].[Courses] ([categoryId]);
END
GO

-- Lessons Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Lessons' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Lessons] (
        [id] CHAR(10) NOT NULL PRIMARY KEY,
        [name] NVARCHAR(50) NOT NULL,
        [description] NVARCHAR(MAX) NULL,
        [courseId] CHAR(5) NULL,
        CONSTRAINT [FK_Lessons_Courses_courseId] FOREIGN KEY ([courseId]) REFERENCES [dbo].[Courses] ([id]) ON DELETE SET NULL
    );
    
    CREATE INDEX [IX_Lessons_courseId] ON [dbo].[Lessons] ([courseId]);
END
GO

-- Attendance Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Attendance' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Attendance] (
        [classId] CHAR(7) NOT NULL,
        [lessonId] CHAR(10) NOT NULL,
        [date] DATE NOT NULL,
        [comment] NVARCHAR(70) NULL,
        [evaluation] TINYINT NULL,
        [attendance] TINYINT NULL,
        CONSTRAINT [PK_Attendance] PRIMARY KEY ([classId], [lessonId]),
        CONSTRAINT [FK_Attendance_Lessons_lessonId] FOREIGN KEY ([lessonId]) REFERENCES [dbo].[Lessons] ([id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Attendance_Classes_classId] FOREIGN KEY ([classId]) REFERENCES [dbo].[Classes] ([id]) ON DELETE NO ACTION
    );
    
    CREATE INDEX [IX_Attendance_lessonId] ON [dbo].[Attendance] ([lessonId]);
END
GO

-- =============================================
-- Entity Framework Migrations History Table
-- =============================================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='__EFMigrationsHistory' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[__EFMigrationsHistory] (
        [MigrationId] NVARCHAR(150) NOT NULL PRIMARY KEY,
        [ProductVersion] NVARCHAR(32) NOT NULL
    );
END
GO

PRINT N'SaoVietDB database created successfully!';
GO
