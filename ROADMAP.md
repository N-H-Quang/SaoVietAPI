# 🗺️ Lộ trình phát triển dự án SaoVietAPI

Tài liệu này mô tả chi tiết lộ trình từng bước từ **0 đến hoàn thành** dự án API trung tâm tin học Sao Việt.

---

## 📋 Mục lục

- [Giai đoạn 1: Chuẩn bị môi trường phát triển](#giai-đoạn-1-chuẩn-bị-môi-trường-phát-triển)
- [Giai đoạn 2: Khởi tạo dự án và cấu trúc thư mục](#giai-đoạn-2-khởi-tạo-dự-án-và-cấu-trúc-thư-mục)
- [Giai đoạn 3: Xây dựng tầng Domain](#giai-đoạn-3-xây-dựng-tầng-domain)
- [Giai đoạn 4: Xây dựng tầng Infrastructure](#giai-đoạn-4-xây-dựng-tầng-infrastructure)
- [Giai đoạn 5: Xây dựng tầng Application](#giai-đoạn-5-xây-dựng-tầng-application)
- [Giai đoạn 6: Xây dựng tầng WebAPI](#giai-đoạn-6-xây-dựng-tầng-webapi)
- [Giai đoạn 7: Xác thực và phân quyền](#giai-đoạn-7-xác-thực-và-phân-quyền)
- [Giai đoạn 8: Logging và Monitoring](#giai-đoạn-8-logging-và-monitoring)
- [Giai đoạn 9: Caching](#giai-đoạn-9-caching)
- [Giai đoạn 10: Testing](#giai-đoạn-10-testing)
- [Giai đoạn 11: Docker và Container hóa](#giai-đoạn-11-docker-và-container-hóa)
- [Giai đoạn 12: Triển khai và vận hành](#giai-đoạn-12-triển-khai-và-vận-hành)

---

## Giai đoạn 1: Chuẩn bị môi trường phát triển

### 1.1 Cài đặt công cụ cần thiết

| Công cụ | Phiên bản | Mục đích |
|---------|-----------|----------|
| .NET SDK | 7.0+ | Framework phát triển |
| Visual Studio / VS Code | Mới nhất | IDE |
| SQL Server | 2019+ | Cơ sở dữ liệu |
| Docker Desktop | Mới nhất | Container hóa |
| Git | Mới nhất | Quản lý mã nguồn |
| Postman / Insomnia | Mới nhất | Test API |

### 1.2 Cài đặt .NET SDK

```bash
# Windows (PowerShell)
winget install Microsoft.DotNet.SDK.7

# macOS
brew install dotnet-sdk

# Linux (Ubuntu)
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update && sudo apt-get install -y dotnet-sdk-7.0
```

### 1.3 Cài đặt SQL Server

```bash
# Sử dụng Docker
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Lưu ý: Thay thế YourStrong@Password bằng mật khẩu mạnh của bạn
# Trong môi trường production, sử dụng Docker secrets hoặc biến môi trường
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrong@Password" \
   -p 1433:1433 --name sql_server \
   -d mcr.microsoft.com/mssql/server:2022-latest
```

> ⚠️ **Bảo mật:** Không sử dụng mật khẩu mặc định trong môi trường production. Sử dụng Docker secrets hoặc biến môi trường để quản lý mật khẩu.

### 1.4 Kiểm tra cài đặt

```bash
dotnet --version    # Kiểm tra .NET SDK
docker --version    # Kiểm tra Docker
git --version       # Kiểm tra Git
```

---

## Giai đoạn 2: Khởi tạo dự án và cấu trúc thư mục

### 2.1 Tạo Solution và các Project

```bash
# Tạo thư mục dự án
mkdir SaoVietAPI && cd SaoVietAPI

# Tạo Solution
dotnet new sln -n WebAPI

# Tạo các project theo Clean Architecture
dotnet new classlib -n Domain
dotnet new classlib -n Application
dotnet new classlib -n Infrastructure
dotnet new webapi -n WebAPI -o WebAPI/WebAPI

# Thêm các project vào Solution
dotnet sln add Domain/Domain.csproj
dotnet sln add Application/Application.csproj
dotnet sln add Infrastructure/Infrastructure.csproj
dotnet sln add WebAPI/WebAPI/WebAPI.csproj
```

### 2.2 Thiết lập tham chiếu giữa các Project

```bash
# Infrastructure tham chiếu đến Domain
dotnet add Infrastructure/Infrastructure.csproj reference Domain/Domain.csproj

# Application tham chiếu đến Domain và Infrastructure
dotnet add Application/Application.csproj reference Domain/Domain.csproj
dotnet add Application/Application.csproj reference Infrastructure/Infrastructure.csproj

# WebAPI tham chiếu đến tất cả các project
dotnet add WebAPI/WebAPI/WebAPI.csproj reference Domain/Domain.csproj
dotnet add WebAPI/WebAPI/WebAPI.csproj reference Application/Application.csproj
dotnet add WebAPI/WebAPI/WebAPI.csproj reference Infrastructure/Infrastructure.csproj
```

### 2.3 Cấu trúc thư mục hoàn chỉnh

```
SaoVietAPI/
├── Domain/                     # Tầng Domain (Entities, Interfaces)
│   ├── Entities/              # Các entity đại diện bảng CSDL
│   │   ├── Student.cs
│   │   ├── Teacher.cs
│   │   ├── Class.cs
│   │   ├── Course.cs
│   │   ├── Branch.cs
│   │   ├── Category.cs
│   │   ├── Lesson.cs
│   │   ├── Attendance.cs
│   │   └── ApplicationUser.cs
│   └── Interfaces/            # Các interface repository
│       ├── IGenericRepository.cs
│       ├── IStudentRepository.cs
│       └── ...
├── Infrastructure/             # Tầng Infrastructure (Data Access)
│   ├── ApplicationDbContext.cs
│   ├── Repositories/          # Triển khai Repository Pattern
│   │   ├── GenericRepository.cs
│   │   └── ...
│   ├── Migrations/            # EF Core Migrations
│   └── Converter/             # Value Converters
├── Application/               # Tầng Application (Business Logic)
│   ├── Services/              # Business Services
│   │   ├── StudentService.cs
│   │   └── ...
│   ├── Cache/                 # Caching Logic
│   ├── Middleware/            # Custom Middleware
│   └── Transaction/           # Transaction Management
├── WebAPI/                    # Tầng Presentation
│   └── WebAPI/
│       ├── Controllers/       # API Controllers
│       ├── Models/            # DTOs, View Models
│       ├── Program.cs         # Entry Point
│       └── appsettings.json   # Configuration
├── Docker/                    # Docker Configuration
├── Kubernetes/                # K8s Manifests
├── Test/                      # HTTP Test Files
└── Resources/                 # Static Resources
```

---

## Giai đoạn 3: Xây dựng tầng Domain

### 3.1 Cài đặt NuGet packages cho Domain

```bash
cd Domain
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
```

### 3.2 Tạo Base Entity

```csharp
// Domain/Entities/BaseEntity.cs
namespace Domain.Entities;

public abstract class BaseEntity
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}
```

### 3.3 Tạo các Entity chính

**Student Entity:**

```csharp
// Domain/Entities/Student.cs
using System.ComponentModel.DataAnnotations;

namespace Domain.Entities;

public class Student : BaseEntity
{
    [Required]
    [StringLength(100)]
    public string? StudentName { get; set; }

    [Phone]
    public string? Phone { get; set; }

    [EmailAddress]
    public string? Email { get; set; }

    public DateTime? DateOfBirth { get; set; }

    [StringLength(200)]
    public string? Address { get; set; }

    // Navigation properties
    public virtual ICollection<ClassStudent>? ClassStudents { get; set; }
    public virtual ICollection<Attendance>? Attendances { get; set; }
}
```

**Teacher Entity:**

```csharp
// Domain/Entities/Teacher.cs
using System.ComponentModel.DataAnnotations;

namespace Domain.Entities;

public class Teacher : BaseEntity
{
    [Required]
    [StringLength(100)]
    public string? TeacherName { get; set; }

    [Phone]
    public string? Phone { get; set; }

    [EmailAddress]
    public string? Email { get; set; }

    [StringLength(200)]
    public string? Address { get; set; }

    public string? Degree { get; set; }

    // Navigation properties
    public virtual ICollection<Class>? Classes { get; set; }
}
```

**Class Entity:**

```csharp
// Domain/Entities/Class.cs
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Domain.Entities;

public class Class : BaseEntity
{
    [Required]
    [StringLength(100)]
    public string? ClassName { get; set; }

    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }

    [ForeignKey("Teacher")]
    public Guid? TeacherId { get; set; }
    public virtual Teacher? Teacher { get; set; }

    [ForeignKey("Branch")]
    public Guid? BranchId { get; set; }
    public virtual Branch? Branch { get; set; }

    [ForeignKey("Course")]
    public Guid? CourseId { get; set; }
    public virtual Course? Course { get; set; }

    // Navigation properties
    public virtual ICollection<ClassStudent>? ClassStudents { get; set; }
    public virtual ICollection<Lesson>? Lessons { get; set; }
}
```

### 3.4 Tạo các Interface Repository

**Generic Repository Interface:**

```csharp
// Domain/Interfaces/IGenericRepository.cs
using System.Linq.Expressions;

namespace Domain.Interfaces;

public interface IGenericRepository<T> where T : class
{
    Task<IEnumerable<T>> GetAllAsync();
    Task<T?> GetByIdAsync(Guid id);
    Task<IEnumerable<T>> FindAsync(Expression<Func<T, bool>> predicate);
    Task<T> AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(Guid id);
    Task<bool> ExistsAsync(Guid id);
}
```

**Specific Repository Interface (ví dụ Student):**

```csharp
// Domain/Interfaces/IStudentRepository.cs
using Domain.Entities;

namespace Domain.Interfaces;

public interface IStudentRepository : IGenericRepository<Student>
{
    Task<IEnumerable<Student>> GetStudentsByClassIdAsync(Guid classId);
    Task<Student?> GetStudentByEmailAsync(string email);
}
```

---

## Giai đoạn 4: Xây dựng tầng Infrastructure

### 4.1 Cài đặt NuGet packages

```bash
cd Infrastructure
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
```

### 4.2 Tạo DbContext

```csharp
// Infrastructure/ApplicationDbContext.cs
using Domain.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Student> Students => Set<Student>();
    public DbSet<Teacher> Teachers => Set<Teacher>();
    public DbSet<Class> Classes => Set<Class>();
    public DbSet<Course> Courses => Set<Course>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Branch> Branches => Set<Branch>();
    public DbSet<Lesson> Lessons => Set<Lesson>();
    public DbSet<Attendance> Attendances => Set<Attendance>();
    public DbSet<ClassStudent> ClassStudents => Set<ClassStudent>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        // Configure many-to-many relationship
        builder.Entity<ClassStudent>()
            .HasKey(cs => new { cs.ClassId, cs.StudentId });

        builder.Entity<ClassStudent>()
            .HasOne(cs => cs.Class)
            .WithMany(c => c.ClassStudents)
            .HasForeignKey(cs => cs.ClassId);

        builder.Entity<ClassStudent>()
            .HasOne(cs => cs.Student)
            .WithMany(s => s.ClassStudents)
            .HasForeignKey(cs => cs.StudentId);

        // Seed data (optional)
        SeedData(builder);
    }

    private void SeedData(ModelBuilder builder)
    {
        // Add seed data here if needed
    }
}
```

### 4.3 Triển khai Generic Repository

```csharp
// Infrastructure/Repositories/GenericRepository.cs
using System.Linq.Expressions;
using Domain.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repositories;

public class GenericRepository<T> : IGenericRepository<T> where T : class
{
    protected readonly ApplicationDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public GenericRepository(ApplicationDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public async Task<IEnumerable<T>> GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    public async Task<T?> GetByIdAsync(Guid id)
    {
        return await _dbSet.FindAsync(id);
    }

    public async Task<IEnumerable<T>> FindAsync(Expression<Func<T, bool>> predicate)
    {
        return await _dbSet.Where(predicate).ToListAsync();
    }

    public async Task<T> AddAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task UpdateAsync(T entity)
    {
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Guid id)
    {
        var entity = await GetByIdAsync(id);
        if (entity != null)
        {
            _dbSet.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<bool> ExistsAsync(Guid id)
    {
        return await GetByIdAsync(id) != null;
    }
}
```

### 4.4 Tạo Migration và cập nhật Database

```bash
# Từ thư mục gốc của solution
dotnet ef migrations add InitialCreate --project Infrastructure --startup-project WebAPI/WebAPI

dotnet ef database update --project Infrastructure --startup-project WebAPI/WebAPI
```

---

## Giai đoạn 5: Xây dựng tầng Application

### 5.1 Cài đặt NuGet packages

```bash
cd Application
dotnet add package AutoMapper
dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection
dotnet add package Microsoft.Extensions.Caching.StackExchangeRedis
dotnet add package StackExchange.Redis
```

### 5.2 Tạo DTOs (Data Transfer Objects)

```csharp
// Application/DTOs/StudentDto.cs
namespace Application.DTOs;

public record StudentDto
{
    public Guid Id { get; init; }
    public string? StudentName { get; init; }
    public string? Phone { get; init; }
    public string? Email { get; init; }
    public DateTime? DateOfBirth { get; init; }
    public string? Address { get; init; }
}

public record CreateStudentDto
{
    public string? StudentName { get; init; }
    public string? Phone { get; init; }
    public string? Email { get; init; }
    public DateTime? DateOfBirth { get; init; }
    public string? Address { get; init; }
}

public record UpdateStudentDto
{
    public string? StudentName { get; init; }
    public string? Phone { get; init; }
    public string? Email { get; init; }
    public DateTime? DateOfBirth { get; init; }
    public string? Address { get; init; }
}
```

### 5.3 Cấu hình AutoMapper

```csharp
// Application/Mappings/MappingProfile.cs
using AutoMapper;
using Application.DTOs;
using Domain.Entities;

namespace Application.Mappings;

public class MappingProfile : Profile
{
    public MappingProfile()
    {
        // Student mappings
        CreateMap<Student, StudentDto>().ReverseMap();
        CreateMap<CreateStudentDto, Student>();
        CreateMap<UpdateStudentDto, Student>();

        // Teacher mappings
        CreateMap<Teacher, TeacherDto>().ReverseMap();
        CreateMap<CreateTeacherDto, Teacher>();

        // Add more mappings as needed
    }
}
```

### 5.4 Tạo Business Services

```csharp
// Application/Services/StudentService.cs
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using Infrastructure;
using Microsoft.Extensions.Logging;

namespace Application.Services;

public class StudentService
{
    private readonly ApplicationDbContext _context;
    private readonly IMapper _mapper;
    private readonly ICache _cache;
    private readonly ILogger<StudentService> _logger;

    public StudentService(
        ApplicationDbContext context,
        IMapper mapper,
        ICache cache,
        ILogger<StudentService> logger)
    {
        _context = context;
        _mapper = mapper;
        _cache = cache;
        _logger = logger;
    }

    public async Task<IEnumerable<Student>> GetAllStudentsAsync()
    {
        var cacheKey = "students_all";
        var cachedStudents = await _cache.GetAsync<IEnumerable<Student>>(cacheKey);

        if (cachedStudents != null)
        {
            _logger.LogInformation("Returning students from cache");
            return cachedStudents;
        }

        var students = _context.Students.ToList();
        await _cache.SetAsync(cacheKey, students, TimeSpan.FromMinutes(5));

        return students;
    }

    public async Task<Student?> GetStudentByIdAsync(Guid id)
    {
        return await _context.Students.FindAsync(id);
    }

    public async Task<Student> CreateStudentAsync(Student student)
    {
        _context.Students.Add(student);
        await _context.SaveChangesAsync();
        await _cache.RemoveAsync("students_all");
        return student;
    }

    public async Task<Student?> UpdateStudentAsync(Guid id, Student student)
    {
        var existingStudent = await _context.Students.FindAsync(id);
        if (existingStudent == null) return null;

        existingStudent.StudentName = student.StudentName;
        existingStudent.Phone = student.Phone;
        existingStudent.Email = student.Email;
        existingStudent.Address = student.Address;
        existingStudent.DateOfBirth = student.DateOfBirth;

        await _context.SaveChangesAsync();
        await _cache.RemoveAsync("students_all");

        return existingStudent;
    }

    public async Task<bool> DeleteStudentAsync(Guid id)
    {
        var student = await _context.Students.FindAsync(id);
        if (student == null) return false;

        _context.Students.Remove(student);
        await _context.SaveChangesAsync();
        await _cache.RemoveAsync("students_all");

        return true;
    }
}
```

### 5.5 Tạo Custom Middleware

**Rate Limiting Middleware:**

```csharp
// Application/Middleware/RateLimitingMiddleware.cs
using Microsoft.AspNetCore.Http;
using System.Collections.Concurrent;

namespace Application.Middleware;

public class RateLimitingMiddleware
{
    private readonly RequestDelegate _next;
    private static readonly ConcurrentDictionary<string, TokenBucket> _buckets = new();
    private const int TokensPerMinute = 60;
    private const int BucketCapacity = 60;

    public RateLimitingMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var ipAddress = context.Connection.RemoteIpAddress?.ToString() ?? "unknown";
        var bucket = _buckets.GetOrAdd(ipAddress, _ => new TokenBucket(BucketCapacity, TokensPerMinute));

        if (!bucket.TryTake())
        {
            context.Response.StatusCode = StatusCodes.Status429TooManyRequests;
            await context.Response.WriteAsync("Rate limit exceeded. Please try again later.");
            return;
        }

        await _next(context);
    }
}

public class TokenBucket
{
    private readonly int _capacity;
    private readonly int _tokensPerMinute;
    private double _tokens;
    private DateTime _lastRefill;
    private readonly object _lock = new();

    public TokenBucket(int capacity, int tokensPerMinute)
    {
        _capacity = capacity;
        _tokensPerMinute = tokensPerMinute;
        _tokens = capacity;
        _lastRefill = DateTime.UtcNow;
    }

    public bool TryTake()
    {
        lock (_lock)
        {
            Refill();
            if (_tokens < 1) return false;
            _tokens--;
            return true;
        }
    }

    private void Refill()
    {
        var now = DateTime.UtcNow;
        var elapsed = (now - _lastRefill).TotalMinutes;
        var tokensToAdd = elapsed * _tokensPerMinute;
        _tokens = Math.Min(_capacity, _tokens + tokensToAdd);
        _lastRefill = now;
    }
}
```

**Security Headers Middleware:**

```csharp
// Application/Middleware/SecurityHeadersMiddleware.cs
using Microsoft.AspNetCore.Http;

namespace Application.Middleware;

public class SecurityHeadersMiddleware
{
    private readonly RequestDelegate _next;

    public SecurityHeadersMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        context.Response.Headers.Append("X-Content-Type-Options", "nosniff");
        context.Response.Headers.Append("X-Frame-Options", "DENY");
        context.Response.Headers.Append("X-XSS-Protection", "1; mode=block");
        context.Response.Headers.Append("Referrer-Policy", "strict-origin-when-cross-origin");
        context.Response.Headers.Append("Content-Security-Policy", "default-src 'self'");

        await _next(context);
    }
}
```

---

## Giai đoạn 6: Xây dựng tầng WebAPI

### 6.1 Cài đặt NuGet packages

```bash
cd WebAPI/WebAPI
dotnet add package Swashbuckle.AspNetCore
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
dotnet add package Serilog.AspNetCore
dotnet add package Serilog.Sinks.Elasticsearch
dotnet add package prometheus-net.AspNetCore
dotnet add package AspNetCore.HealthChecks.UI
dotnet add package AspNetCore.HealthChecks.UI.Client
```

### 6.2 Cấu hình appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=localhost;Initial Catalog=SaoVietDB;User ID=sa;Password=YourStrong@Password;TrustServerCertificate=True",
    "RedisConnection": "localhost:6379"
  },
  "Jwt": {
    "Key": "YourSuperSecretKeyHere123456789!@#",
    "Issuer": "SaoVietAPI",
    "Audience": "SaoVietClient",
    "ExpiryInMinutes": 60
  },
  "ElasticConfiguration": {
    "Uri": "http://localhost:9200"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

> ⚠️ **Bảo mật quan trọng:**
> - **Không commit** file `appsettings.json` với thông tin nhạy cảm vào source control
> - Sử dụng **User Secrets** cho môi trường development: `dotnet user-secrets set "Jwt:Key" "your-secret-key"`
> - Sử dụng **Environment Variables** hoặc **Azure Key Vault** cho production
> - JWT Key nên có độ dài tối thiểu 256-bit (32 ký tự) và được tạo ngẫu nhiên
```

### 6.3 Cấu hình Program.cs

```csharp
// WebAPI/WebAPI/Program.cs
using Application.Services;
using Application.Cache;
using Application.Middleware;
using Infrastructure;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .CreateLogger();

builder.Host.UseSerilog();

// Add services
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// Configure Swagger
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Sao Việt API",
        Version = "v1",
        Description = "API cho trung tâm tin học Sao Việt"
    });

    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Nhập JWT token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "bearer"
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Configure Database
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Configure Authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!))
        };
    });

// Configure Authorization policies
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("Admin", policy => policy.RequireClaim("Admin"));
    options.AddPolicy("Teacher", policy => policy.RequireClaim("Teacher"));
    options.AddPolicy("Student", policy => policy.RequireClaim("Student"));
});

// Register Services
builder.Services.AddScoped<StudentService>();
builder.Services.AddScoped<TeacherService>();
builder.Services.AddScoped<ClassService>();
builder.Services.AddScoped<CourseService>();
builder.Services.AddScoped<AuthenticationService>();

// Configure AutoMapper
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", cors =>
    {
        cors.AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

var app = builder.Build();

// Configure middleware pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseMiddleware<SecurityHeadersMiddleware>();
app.UseMiddleware<RateLimitingMiddleware>();

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
```

### 6.4 Tạo Controllers

**Student Controller:**

```csharp
// WebAPI/WebAPI/Controllers/StudentController.cs
using Application.Services;
using Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class StudentController : ControllerBase
{
    private readonly StudentService _studentService;
    private readonly ILogger<StudentController> _logger;

    public StudentController(StudentService studentService, ILogger<StudentController> logger)
    {
        _studentService = studentService;
        _logger = logger;
    }

    /// <summary>
    /// Lấy danh sách tất cả học viên
    /// </summary>
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<Student>>> GetAllStudents()
    {
        _logger.LogInformation("Getting all students");
        var students = await _studentService.GetAllStudentsAsync();
        return Ok(students);
    }

    /// <summary>
    /// Lấy thông tin học viên theo ID
    /// </summary>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<Student>> GetStudentById(Guid id)
    {
        var student = await _studentService.GetStudentByIdAsync(id);
        if (student == null)
        {
            return NotFound(new { message = "Không tìm thấy học viên" });
        }
        return Ok(student);
    }

    /// <summary>
    /// Tạo mới học viên
    /// </summary>
    [HttpPost]
    [Authorize(Policy = "Admin")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<Student>> CreateStudent([FromBody] Student student)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var createdStudent = await _studentService.CreateStudentAsync(student);
        return CreatedAtAction(nameof(GetStudentById), new { id = createdStudent.Id }, createdStudent);
    }

    /// <summary>
    /// Cập nhật thông tin học viên
    /// </summary>
    [HttpPut("{id:guid}")]
    [Authorize(Policy = "Admin")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<Student>> UpdateStudent(Guid id, [FromBody] Student student)
    {
        var updatedStudent = await _studentService.UpdateStudentAsync(id, student);
        if (updatedStudent == null)
        {
            return NotFound(new { message = "Không tìm thấy học viên" });
        }
        return Ok(updatedStudent);
    }

    /// <summary>
    /// Xóa học viên
    /// </summary>
    [HttpDelete("{id:guid}")]
    [Authorize(Policy = "Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteStudent(Guid id)
    {
        var deleted = await _studentService.DeleteStudentAsync(id);
        if (!deleted)
        {
            return NotFound(new { message = "Không tìm thấy học viên" });
        }
        return NoContent();
    }
}
```

---

## Giai đoạn 7: Xác thực và phân quyền

### 7.1 Tạo Authentication Service

```csharp
// Application/Services/AuthenticationService.cs
using Domain.Entities;
using Infrastructure;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Application.Services;

public class AuthenticationService
{
    private readonly ApplicationDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthenticationService(ApplicationDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
        
        // Validate required configuration at startup
        ValidateConfiguration();
    }
    
    private void ValidateConfiguration()
    {
        var jwtKey = _configuration["Jwt:Key"];
        if (string.IsNullOrEmpty(jwtKey))
            throw new InvalidOperationException("JWT Key is not configured");
            
        if (jwtKey.Length < 32)
            throw new InvalidOperationException("JWT Key must be at least 32 characters");
    }

    public string GenerateJwtToken(ApplicationUser user, IList<string> roles)
    {
        var jwtKey = _configuration["Jwt:Key"] 
            ?? throw new InvalidOperationException("JWT Key is not configured");
            
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id),
            new(ClaimTypes.Name, user.UserName ?? string.Empty),
            new(ClaimTypes.Email, user.Email ?? string.Empty),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        // Add role claims
        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
            claims.Add(new Claim(role, "true")); // For policy-based authorization
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(
                Convert.ToDouble(_configuration["Jwt:ExpiryInMinutes"] ?? "60")),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public RefreshToken GenerateRefreshToken()
    {
        // Sử dụng cryptographically secure random number generator
        var randomBytes = new byte[64];
        using var rng = System.Security.Cryptography.RandomNumberGenerator.Create();
        rng.GetBytes(randomBytes);
        
        return new RefreshToken
        {
            Token = Convert.ToBase64String(randomBytes),
            ExpiryDate = DateTime.UtcNow.AddDays(7),
            Created = DateTime.UtcNow
        };
    }
}
```

> 💡 **Lưu ý bảo mật:** Sử dụng `RandomNumberGenerator` thay vì `Guid.NewGuid()` để tạo refresh token vì nó cung cấp entropy cao hơn và an toàn hơn về mặt mật mã học.

### 7.2 Tạo Authentication Controller

```csharp
// WebAPI/WebAPI/Controllers/AuthenticationController.cs
using Application.Services;
using Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using WebAPI.Models;

namespace WebAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthenticationController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly SignInManager<ApplicationUser> _signInManager;
    private readonly AuthenticationService _authService;
    private readonly ILogger<AuthenticationController> _logger;

    public AuthenticationController(
        UserManager<ApplicationUser> userManager,
        SignInManager<ApplicationUser> signInManager,
        AuthenticationService authService,
        ILogger<AuthenticationController> logger)
    {
        _userManager = userManager;
        _signInManager = signInManager;
        _authService = authService;
        _logger = logger;
    }

    /// <summary>
    /// Đăng ký tài khoản mới
    /// </summary>
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterModel model)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var user = new ApplicationUser
        {
            UserName = model.Username,
            Email = model.Email,
            FullName = model.FullName
        };

        var result = await _userManager.CreateAsync(user, model.Password);

        if (!result.Succeeded)
        {
            return BadRequest(result.Errors);
        }

        // Assign default role
        await _userManager.AddToRoleAsync(user, "Student");

        _logger.LogInformation("User {Username} registered successfully", model.Username);

        return Ok(new { message = "Đăng ký thành công" });
    }

    /// <summary>
    /// Đăng nhập
    /// </summary>
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginModel model)
    {
        var user = await _userManager.FindByNameAsync(model.Username);

        if (user == null || !await _userManager.CheckPasswordAsync(user, model.Password))
        {
            return Unauthorized(new { message = "Tên đăng nhập hoặc mật khẩu không đúng" });
        }

        var roles = await _userManager.GetRolesAsync(user);
        var token = _authService.GenerateJwtToken(user, roles);
        var refreshToken = _authService.GenerateRefreshToken();

        // Save refresh token to database
        user.RefreshToken = refreshToken.Token;
        user.RefreshTokenExpiryTime = refreshToken.ExpiryDate;
        await _userManager.UpdateAsync(user);

        _logger.LogInformation("User {Username} logged in successfully", model.Username);

        return Ok(new
        {
            token,
            refreshToken = refreshToken.Token,
            expiration = DateTime.UtcNow.AddMinutes(60)
        });
    }

    /// <summary>
    /// Làm mới token
    /// </summary>
    [HttpPost("refresh-token")]
    public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenModel model)
    {
        var user = _userManager.Users.FirstOrDefault(u => u.RefreshToken == model.RefreshToken);

        if (user == null || user.RefreshTokenExpiryTime <= DateTime.UtcNow)
        {
            return Unauthorized(new { message = "Refresh token không hợp lệ hoặc đã hết hạn" });
        }

        var roles = await _userManager.GetRolesAsync(user);
        var newToken = _authService.GenerateJwtToken(user, roles);
        var newRefreshToken = _authService.GenerateRefreshToken();

        user.RefreshToken = newRefreshToken.Token;
        user.RefreshTokenExpiryTime = newRefreshToken.ExpiryDate;
        await _userManager.UpdateAsync(user);

        return Ok(new
        {
            token = newToken,
            refreshToken = newRefreshToken.Token
        });
    }
}
```

---

## Giai đoạn 8: Logging và Monitoring

### 8.1 Cấu hình Serilog với Elasticsearch

```csharp
// Trong Program.cs
using Serilog;
using Serilog.Sinks.Elasticsearch;

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .Enrich.FromLogContext()
    .Enrich.WithEnvironmentName()
    .WriteTo.Console()
    .WriteTo.Elasticsearch(new ElasticsearchSinkOptions(
        new Uri(builder.Configuration["ElasticConfiguration:Uri"]!))
    {
        AutoRegisterTemplate = true,
        IndexFormat = $"saoviet-api-{DateTime.UtcNow:yyyy-MM}"
    })
    .CreateLogger();
```

### 8.2 Cấu hình Prometheus Metrics

```csharp
// Trong Program.cs
using Prometheus;

// Thêm middleware
app.UseHttpMetrics();

// Map metrics endpoint
app.MapMetrics();
```

### 8.3 Docker Compose cho ELK Stack

```yaml
# Docker/docker-compose.yml
version: '3.8'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.6.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:8.6.0
    container_name: kibana
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prom/prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    depends_on:
      - prometheus

volumes:
  elasticsearch-data:
  grafana-data:
```

### 8.4 Cấu hình Prometheus

```yaml
# Docker/prom/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'saoviet-api'
    static_configs:
      - targets: ['host.docker.internal:5000']
    metrics_path: '/metrics'
```

---

## Giai đoạn 9: Caching

### 9.1 Cài đặt Redis

```bash
# Sử dụng Docker
docker run -d --name redis -p 6379:6379 redis:latest
```

### 9.2 Tạo Cache Interface và Implementation

```csharp
// Domain/Interfaces/ICache.cs
namespace Domain.Interfaces;

public interface ICache
{
    Task<T?> GetAsync<T>(string key);
    Task SetAsync<T>(string key, T value, TimeSpan expiration);
    Task RemoveAsync(string key);
    Task<bool> ExistsAsync(string key);
}
```

```csharp
// Application/Cache/CacheService.cs
using Domain.Interfaces;
using Microsoft.Extensions.Caching.Distributed;
using System.Text.Json;

namespace Application.Cache;

public class CacheService : ICache
{
    private readonly IDistributedCache _cache;

    public CacheService(IDistributedCache cache)
    {
        _cache = cache;
    }

    public async Task<T?> GetAsync<T>(string key)
    {
        var data = await _cache.GetStringAsync(key);
        return data == null ? default : JsonSerializer.Deserialize<T>(data);
    }

    public async Task SetAsync<T>(string key, T value, TimeSpan expiration)
    {
        var options = new DistributedCacheEntryOptions
        {
            AbsoluteExpirationRelativeToNow = expiration
        };
        var data = JsonSerializer.Serialize(value);
        await _cache.SetStringAsync(key, data, options);
    }

    public async Task RemoveAsync(string key)
    {
        await _cache.RemoveAsync(key);
    }

    public async Task<bool> ExistsAsync(string key)
    {
        return await _cache.GetStringAsync(key) != null;
    }
}
```

---

## Giai đoạn 10: Testing

### 10.1 Tạo Unit Test Project

```bash
dotnet new xunit -n SaoVietAPI.Tests
dotnet sln add SaoVietAPI.Tests/SaoVietAPI.Tests.csproj
dotnet add SaoVietAPI.Tests reference Application/Application.csproj
dotnet add SaoVietAPI.Tests reference Infrastructure/Infrastructure.csproj

cd SaoVietAPI.Tests
dotnet add package Moq
dotnet add package FluentAssertions
dotnet add package Microsoft.EntityFrameworkCore.InMemory
```

### 10.2 Tạo Unit Tests

```csharp
// SaoVietAPI.Tests/Services/StudentServiceTests.cs
using Application.Services;
using Domain.Entities;
using FluentAssertions;
using Infrastructure;
using Microsoft.EntityFrameworkCore;
using Moq;
using Xunit;

namespace SaoVietAPI.Tests.Services;

public class StudentServiceTests
{
    private readonly ApplicationDbContext _context;
    private readonly StudentService _studentService;

    public StudentServiceTests()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new ApplicationDbContext(options);
        _studentService = new StudentService(_context, null!, null!, null!);
    }

    [Fact]
    public async Task GetAllStudents_ShouldReturnAllStudents()
    {
        // Arrange
        var students = new List<Student>
        {
            new() { StudentName = "Nguyễn Văn A", Email = "a@test.com" },
            new() { StudentName = "Nguyễn Văn B", Email = "b@test.com" }
        };
        _context.Students.AddRange(students);
        await _context.SaveChangesAsync();

        // Act
        var result = await _studentService.GetAllStudentsAsync();

        // Assert
        result.Should().HaveCount(2);
    }

    [Fact]
    public async Task GetStudentById_ShouldReturnStudent_WhenExists()
    {
        // Arrange
        var student = new Student { StudentName = "Test Student", Email = "test@test.com" };
        _context.Students.Add(student);
        await _context.SaveChangesAsync();

        // Act
        var result = await _studentService.GetStudentByIdAsync(student.Id);

        // Assert
        result.Should().NotBeNull();
        result!.StudentName.Should().Be("Test Student");
    }

    [Fact]
    public async Task CreateStudent_ShouldAddStudentToDatabase()
    {
        // Arrange
        var student = new Student { StudentName = "New Student", Email = "new@test.com" };

        // Act
        var result = await _studentService.CreateStudentAsync(student);

        // Assert
        result.Should().NotBeNull();
        _context.Students.Should().HaveCount(1);
    }
}
```

### 10.3 Tạo Integration Tests

```csharp
// SaoVietAPI.Tests/Integration/StudentControllerTests.cs
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using FluentAssertions;
using Xunit;

namespace SaoVietAPI.Tests.Integration;

public class StudentControllerTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public StudentControllerTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetAllStudents_ShouldReturnOk()
    {
        // Act
        var response = await _client.GetAsync("/api/Student");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }
}
```

### 10.4 HTTP Test Files

```http
### Test/Student.http

### Get all students
GET http://localhost:5000/api/Student
Accept: application/json

### Get student by ID
GET http://localhost:5000/api/Student/{{studentId}}
Accept: application/json

### Create new student
POST http://localhost:5000/api/Student
Content-Type: application/json
Authorization: Bearer {{token}}

{
    "studentName": "Nguyễn Văn Test",
    "email": "test@example.com",
    "phone": "0123456789",
    "address": "123 Test Street"
}

### Update student
PUT http://localhost:5000/api/Student/{{studentId}}
Content-Type: application/json
Authorization: Bearer {{token}}

{
    "studentName": "Updated Name",
    "email": "updated@example.com"
}

### Delete student
DELETE http://localhost:5000/api/Student/{{studentId}}
Authorization: Bearer {{token}}
```

---

## Giai đoạn 11: Docker và Container hóa

### 11.1 Tạo Dockerfile

```dockerfile
# WebAPI/WebAPI/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["WebAPI.sln", "."]
COPY ["Domain/Domain.csproj", "Domain/"]
COPY ["Application/Application.csproj", "Application/"]
COPY ["Infrastructure/Infrastructure.csproj", "Infrastructure/"]
COPY ["WebAPI/WebAPI/WebAPI.csproj", "WebAPI/WebAPI/"]

# Restore packages
RUN dotnet restore "WebAPI/WebAPI/WebAPI.csproj"

# Copy source code
COPY . .

# Build
WORKDIR "/src/WebAPI/WebAPI"
RUN dotnet build "WebAPI.csproj" -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish "WebAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebAPI.dll"]
```

### 11.2 Docker Compose cho toàn bộ hệ thống

```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: WebAPI/WebAPI/Dockerfile
    container_name: saoviet-api
    ports:
      - "5000:80"
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__DefaultConnection=Server=sql_server;Database=SaoVietDB;User Id=sa;Password=YourStrong@Password;TrustServerCertificate=True
      - ConnectionStrings__RedisConnection=redis:6379
    depends_on:
      - sql_server
      - redis

  sql_server:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: sql_server
    environment:
      - ACCEPT_EULA=Y
      - MSSQL_SA_PASSWORD=YourStrong@Password
    ports:
      - "1433:1433"
    volumes:
      - sqlserver-data:/var/opt/mssql

  redis:
    image: redis:alpine
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.6.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:8.6.0
    container_name: kibana
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./Docker/prom/prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana

volumes:
  sqlserver-data:
  redis-data:
  elasticsearch-data:
  grafana-data:
```

### 11.3 Chạy ứng dụng với Docker

```bash
# Build và chạy tất cả services
docker-compose up -d --build

# Xem logs
docker-compose logs -f api

# Dừng tất cả services
docker-compose down

# Dừng và xóa volumes
docker-compose down -v
```

---

## Giai đoạn 12: Triển khai và vận hành

### 12.1 Kubernetes Deployment

```yaml
# Kubernetes/api-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: saoviet-api
  labels:
    app: saoviet-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: saoviet-api
  template:
    metadata:
      labels:
        app: saoviet-api
    spec:
      containers:
      - name: saoviet-api
        image: saoviet-api:latest
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
          requests:
            memory: "256Mi"
            cpu: "250m"
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Production"
        - name: ConnectionStrings__DefaultConnection
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: connection-string
        livenessProbe:
          httpGet:
            path: /health/live
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: saoviet-api-service
spec:
  selector:
    app: saoviet-api
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

### 12.2 CI/CD với GitHub Actions

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '7.0.x'
        
    - name: Restore dependencies
      run: dotnet restore
      
    - name: Build
      run: dotnet build --configuration Release --no-restore
      
    - name: Test
      run: dotnet test --no-restore --verbosity normal
      
  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Build Docker image
      run: docker build -t saoviet-api:${{ github.sha }} .
      
    - name: Push to Container Registry
      run: |
        echo ${{ secrets.REGISTRY_PASSWORD }} | docker login -u ${{ secrets.REGISTRY_USERNAME }} --password-stdin
        docker push saoviet-api:${{ github.sha }}
```

### 12.3 Checklist triển khai Production

- [ ] Cấu hình HTTPS/SSL certificates
- [ ] Thiết lập Environment variables cho Production
- [ ] Cấu hình Connection strings bảo mật (sử dụng secrets)
- [ ] Thiết lập Database backup strategy
- [ ] Cấu hình Rate limiting phù hợp
- [ ] Enable CORS cho domains cần thiết
- [ ] Thiết lập Health checks
- [ ] Cấu hình Logging level cho Production
- [ ] Thiết lập Monitoring alerts
- [ ] Chuẩn bị rollback strategy
- [ ] Document API với Swagger
- [ ] Performance testing
- [ ] Security testing/audit

---

## 📊 Tổng kết Timeline dự kiến

| Giai đoạn | Thời gian ước tính | Độ ưu tiên |
|-----------|-------------------|------------|
| 1. Chuẩn bị môi trường | 1-2 ngày | Cao |
| 2. Khởi tạo dự án | 1 ngày | Cao |
| 3. Tầng Domain | 2-3 ngày | Cao |
| 4. Tầng Infrastructure | 3-4 ngày | Cao |
| 5. Tầng Application | 4-5 ngày | Cao |
| 6. Tầng WebAPI | 3-4 ngày | Cao |
| 7. Xác thực & Phân quyền | 2-3 ngày | Cao |
| 8. Logging & Monitoring | 2-3 ngày | Trung bình |
| 9. Caching | 1-2 ngày | Trung bình |
| 10. Testing | 3-4 ngày | Cao |
| 11. Docker | 2-3 ngày | Trung bình |
| 12. Triển khai | 2-3 ngày | Trung bình |

**Tổng thời gian dự kiến:** 26-37 ngày (5-7 tuần)

---

## 🔗 Tài liệu tham khảo

- [.NET Documentation](https://docs.microsoft.com/en-us/dotnet/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/)
- [ASP.NET Core Authentication](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Serilog](https://serilog.net/)
- [Swagger/OpenAPI](https://swagger.io/)

---

## 📝 Ghi chú

- Lộ trình này có thể được điều chỉnh tùy theo yêu cầu cụ thể của dự án
- Thời gian ước tính có thể thay đổi tùy thuộc vào kinh nghiệm và nguồn lực
- Nên áp dụng Agile/Scrum để quản lý tiến độ hiệu quả
- Đảm bảo code review và documentation trong suốt quá trình phát triển

---

*Cập nhật lần cuối: Tháng 12/2024*

*Tác giả: Team SaoViet*
