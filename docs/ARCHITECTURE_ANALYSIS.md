# Phân Tích Kiến Trúc SaoVietAPI

## Mục Lục
- [Phân Tích Kiến Trúc SaoVietAPI](#phân-tích-kiến-trúc-saovietapi)
  - [Mục Lục](#mục-lục)
  - [1. Tổng Quan Dự Án](#1-tổng-quan-dự-án)
  - [2. Các Nghiệp Vụ (Business Domains)](#2-các-nghiệp-vụ-business-domains)
    - [2.1. Quản Lý Người Dùng (User Management)](#21-quản-lý-người-dùng-user-management)
    - [2.2. Quản Lý Giáo Viên (Teacher Management)](#22-quản-lý-giáo-viên-teacher-management)
    - [2.3. Quản Lý Học Viên (Student Management)](#23-quản-lý-học-viên-student-management)
    - [2.4. Quản Lý Lớp Học (Class Management)](#24-quản-lý-lớp-học-class-management)
    - [2.5. Quản Lý Chi Nhánh (Branch Management)](#25-quản-lý-chi-nhánh-branch-management)
    - [2.6. Quản Lý Khóa Học (Course Management)](#26-quản-lý-khóa-học-course-management)
    - [2.7. Quản Lý Danh Mục (Category Management)](#27-quản-lý-danh-mục-category-management)
    - [2.8. Quản Lý Bài Học (Lesson Management)](#28-quản-lý-bài-học-lesson-management)
    - [2.9. Quản Lý Điểm Danh (Attendance Management)](#29-quản-lý-điểm-danh-attendance-management)
    - [2.10. Xác Thực \& Phân Quyền (Authentication \& Authorization)](#210-xác-thực--phân-quyền-authentication--authorization)
  - [3. Clean Architecture](#3-clean-architecture)
    - [3.1. Cấu Trúc Thư Mục](#31-cấu-trúc-thư-mục)
    - [3.2. Nguyên Tắc Dependency Rule](#32-nguyên-tắc-dependency-rule)
    - [3.3. Domain Layer (Lớp Miền)](#33-domain-layer-lớp-miền)
    - [3.4. Application Layer (Lớp Ứng Dụng)](#34-application-layer-lớp-ứng-dụng)
    - [3.5. Infrastructure Layer (Lớp Hạ Tầng)](#35-infrastructure-layer-lớp-hạ-tầng)
    - [3.6. WebAPI Layer (Lớp Presentation)](#36-webapi-layer-lớp-presentation)
  - [4. Repository Pattern](#4-repository-pattern)
    - [4.1. Generic Repository](#41-generic-repository)
    - [4.2. Specific Repository](#42-specific-repository)
    - [4.3. Ưu Điểm Repository Pattern](#43-ưu-điểm-repository-pattern)
  - [5. Các Kỹ Thuật Nâng Cao](#5-các-kỹ-thuật-nâng-cao)
    - [5.1. Caching với Redis](#51-caching-với-redis)
    - [5.2. Transaction Management](#52-transaction-management)
    - [5.3. Middleware Pattern](#53-middleware-pattern)
    - [5.4. JWT Authentication](#54-jwt-authentication)
  - [6. Mối Quan Hệ Giữa Các Entity](#6-mối-quan-hệ-giữa-các-entity)
  - [7. Luồng Xử Lý Request](#7-luồng-xử-lý-request)
  - [8. Bài Học Rút Ra](#8-bài-học-rút-ra)
    - [8.1. Về Clean Architecture](#81-về-clean-architecture)
    - [8.2. Về Repository Pattern](#82-về-repository-pattern)
    - [8.3. Về Best Practices](#83-về-best-practices)
  - [9. Kết Luận](#9-kết-luận)

---

## 1. Tổng Quan Dự Án

**SaoVietAPI** là một API quản lý trung tâm tin học Sao Việt, được xây dựng trên nền tảng:
- **Framework:** ASP.NET Core 7.0
- **Kiến trúc:** Clean Architecture
- **Pattern:** Repository Pattern
- **Database:** SQL Server với Entity Framework Core
- **Cache:** Redis
- **Logging:** ELK Stack (Elasticsearch, Logstash, Kibana)
- **Monitoring:** Prometheus + Grafana

---

## 2. Các Nghiệp Vụ (Business Domains)

### 2.1. Quản Lý Người Dùng (User Management)
**Entity:** `ApplicationUser`
- Kế thừa từ `IdentityUser` (ASP.NET Identity)
- Liên kết với `Teacher` (một user có thể là giáo viên)

**Chức năng:**
- Đăng ký tài khoản
- Đăng nhập
- Quản lý phiên đăng nhập

### 2.2. Quản Lý Giáo Viên (Teacher Management)
**Entity:** `Teacher`
```
- id: Guid (Primary Key)
- fullName: string
- email: string
- phone: string
- customerId: string (FK -> ApplicationUser)
```

**Chức năng:**
- CRUD giáo viên
- Tìm kiếm theo tên
- Liên kết với User Account

### 2.3. Quản Lý Học Viên (Student Management)
**Entity:** `Student`
```
- id: Guid (Primary Key)
- fullName: string
- dob: string (ngày sinh)
- email: string
- phone: string
```

**Chức năng:**
- CRUD học viên
- Tìm kiếm theo tên, số điện thoại
- Đăng ký vào lớp học
- Xem danh sách lớp đã đăng ký

### 2.4. Quản Lý Lớp Học (Class Management)
**Entity:** `Class`
```
- id: string (Primary Key)
- name: string
- startDate: string
- endDate: string
- teacherId: Guid (FK -> Teacher)
- branchId: string (FK -> Branch)
```

**Chức năng:**
- CRUD lớp học
- Tìm theo tên, trạng thái (Expired/Active/Upcoming)
- Tìm theo giáo viên
- Quản lý danh sách học viên trong lớp

### 2.5. Quản Lý Chi Nhánh (Branch Management)
**Entity:** `Branch`
```
- id: string (Primary Key)
- name: string
- address: string
```

**Chức năng:**
- CRUD chi nhánh
- Tìm theo tên, khu vực

### 2.6. Quản Lý Khóa Học (Course Management)
**Entity:** `Course`
```
- id: string (Primary Key)
- name: string
- description: string
- categoryId: string (FK -> Category)
```

**Chức năng:**
- CRUD khóa học
- Tìm theo tên
- Liên kết với danh mục

### 2.7. Quản Lý Danh Mục (Category Management)
**Entity:** `Category`
```
- id: string (Primary Key)
- name: string
```

**Chức năng:**
- CRUD danh mục khóa học

### 2.8. Quản Lý Bài Học (Lesson Management)
**Entity:** `Lesson`
```
- id: string (Primary Key)
- name: string
- description: string
- courseId: string (FK -> Course)
```

**Chức năng:**
- CRUD bài học
- Liên kết với khóa học

### 2.9. Quản Lý Điểm Danh (Attendance Management)
**Entity:** `Attendance`
```
- classId: string (Composite PK)
- lessonId: string (Composite PK)
- date: string
- comment: string
- evaluation: byte
- attendance: byte
```

**Chức năng:**
- CRUD điểm danh
- Sắp xếp theo điểm danh
- Tìm theo lớp học

### 2.10. Xác Thực & Phân Quyền (Authentication & Authorization)
**Entities:** `RefreshToken`, `IdentityClaim`

**Roles:**
- Admin
- Teacher
- Student
- President

**Chức năng:**
- Đăng ký/Đăng nhập với JWT
- Refresh Token
- Role-based Authorization
- Claim-based Authorization

---

## 3. Clean Architecture

### 3.1. Cấu Trúc Thư Mục
```
SaoVietAPI/
├── Domain/                 # Core business logic (innermost layer)
│   ├── Entities/           # Business entities
│   └── Interfaces/         # Repository interfaces
│
├── Application/            # Application business rules
│   ├── Services/           # Business services
│   ├── Cache/              # Cache service
│   ├── Middleware/         # Custom middlewares
│   └── Transaction/        # Transaction management
│
├── Infrastructure/         # External concerns
│   ├── Repositories/       # Repository implementations
│   ├── Converter/          # Data converters
│   ├── Migrations/         # EF migrations
│   └── ApplicationDbContext.cs
│
└── WebAPI/                 # Presentation layer
    └── WebAPI/
        ├── Controllers/    # API endpoints
        ├── Models/         # DTOs/ViewModels
        └── Program.cs      # Application configuration
```

### 3.2. Nguyên Tắc Dependency Rule
```
WebAPI → Application → Domain ← Infrastructure
```

**Quan trọng:**
- Domain layer **KHÔNG** phụ thuộc vào layer nào khác
- Các layer bên ngoài phụ thuộc vào layer bên trong
- Infrastructure implements các interface từ Domain

### 3.3. Domain Layer (Lớp Miền)

**Mục đích:** Chứa business logic cốt lõi, không phụ thuộc framework

**Entities (12 entity):**
```csharp
// Domain/Entities/
- ApplicationUser.cs    // User account
- Teacher.cs            // Giáo viên
- Student.cs            // Học viên
- Class.cs              // Lớp học
- ClassStudent.cs       // Bảng trung gian (many-to-many)
- Branch.cs             // Chi nhánh
- Category.cs           // Danh mục
- Course.cs             // Khóa học
- Lesson.cs             // Bài học
- Attendance.cs         // Điểm danh
- RefreshToken.cs       // Token làm mới
- IdentityClaim.cs      // Claims
```

**Interfaces (14 interface):**
```csharp
// Domain/Interfaces/
- IGenericRepository<T>         // Generic CRUD operations
- IStudentRepository
- ITeacherRepository
- IClassRepository
- IClassStudentRepository
- IBranchRepository
- ICategoryRepository
- ICourseRepository
- ILessonRepository
- IAttendanceRepository
- IApplicationUserRepository
- IRefreshTokenRepository
- IIdentityClaimRepository
- ICache                        // Cache abstraction
```

### 3.4. Application Layer (Lớp Ứng Dụng)

**Mục đích:** Chứa business rules, orchestration logic

**Services (10 service):**
```csharp
// Application/Services/
- StudentService        // Nghiệp vụ học viên
- TeacherService        // Nghiệp vụ giáo viên
- ClassService          // Nghiệp vụ lớp học
- BranchService         // Nghiệp vụ chi nhánh
- CategoryService       // Nghiệp vụ danh mục
- CourseService         // Nghiệp vụ khóa học
- LessonService         // Nghiệp vụ bài học
- AttendanceService     // Nghiệp vụ điểm danh
- AuthenticationService // Nghiệp vụ xác thực
- AuthorizationService  // Nghiệp vụ phân quyền
```

**Ví dụ Service:**
```csharp
public class StudentService
{
    private readonly IStudentRepository _studentRepository;
    private readonly IClassStudentRepository _classStudentRepository;
    private readonly IClassRepository _classRepository;

    public StudentService(ApplicationDbContext context, ICache cache)
    {
        _studentRepository = new StudentRepository(context, cache);
        _classRepository = new ClassRepository(context, cache);
        _classStudentRepository = new ClassStudentRepository(context, cache);
    }

    // Business logic methods
    public IEnumerable<Student> GetStudents() => _studentRepository.GetStudents();
    public int CountClassByStudent(Guid? studentId) => _classStudentRepository.CountClassByStudent(studentId);
    // ...
}
```

**Middleware (3 middleware):**
```csharp
// Application/Middleware/
- RateLimitingMiddleware      // Giới hạn request
- SecurityHeadersMiddleware   // Bảo mật HTTP headers
- TimeoutMiddleware           // Timeout request
```

### 3.5. Infrastructure Layer (Lớp Hạ Tầng)

**Mục đích:** Implement các interface từ Domain, xử lý database

**Repository Implementation (13 repository):**
```csharp
// Infrastructure/Repositories/
- GenericRepository<T>         // Base repository với caching
- StudentRepository
- TeacherRepository
- ClassRepository
- ClassStudentRepository
- BranchRepository
- CategoryRepository
- CourseRepository
- LessonRepository
- AttendanceRepository
- ApplicationUserRepository
- RefreshTokenRepository
- IdentityClaimRepository
```

**DbContext:**
```csharp
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public DbSet<Teacher>? Teachers { get; set; }
    public DbSet<Branch>? Branches { get; set; }
    public DbSet<Class>? Classes { get; set; }
    public DbSet<Student>? Students { get; set; }
    public DbSet<ClassStudent>? ClassStudents { get; set; }
    public DbSet<Category>? Categories { get; set; }
    public DbSet<Course>? Courses { get; set; }
    public DbSet<Lesson>? Lessons { get; set; }
    public DbSet<Attendance>? Attendances { get; set; }
    public DbSet<RefreshToken>? RefreshTokens { get; set; }
}
```

### 3.6. WebAPI Layer (Lớp Presentation)

**Mục đích:** Expose API endpoints, handle HTTP requests

**Controllers (10 controller):**
```csharp
// WebAPI/Controllers/
- StudentController         // /api/v1/Student
- TeacherController         // /api/v1/Teacher
- ClassController           // /api/v1/Class
- BranchController          // /api/v1/Branch
- CategoryController        // /api/v1/Category
- CourseController          // /api/v1/Course
- LessonController          // /api/v1/Lesson
- AttendanceController      // /api/v1/Attendance
- AuthenticationController  // /api/v1/Authentication
- AuthorizationController   // /api/v1/Authorization
```

**Models/DTOs:**
```csharp
// WebAPI/Models/
- Student.cs
- Teacher.cs
- Class.cs
- Branch.cs
- Category.cs
- Course.cs
- Lesson.cs
- Attendance.cs
- LoginUser.cs
- RegisterUser.cs
- Auth.cs
- TokenRefresh.cs
- UserClaim.cs
```

---

## 4. Repository Pattern

### 4.1. Generic Repository

**Interface:**
```csharp
public interface IGenericRepository<T> where T : class
{
    public void Insert(T entity);
    public void Update(T entity);
    public void Delete(T entity);
    public void Delete(Expression<Func<T, bool>> where);
    public int Count(Expression<Func<T, bool>> where);
    public T? GetById(object? id);
    public IEnumerable<T> GetList(
        Expression<Func<T, bool>>? filter = null,
        Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
        string includeProperties = "",
        int skip = 0,
        int take = 0);
    public IEnumerable<T> GetAll();
    public IEnumerable<T> GetMany(Expression<Func<T, bool>> where);
    public bool Any(Expression<Func<T, bool>> where);
}
```

**Implementation với Caching:**
```csharp
public abstract class GenericRepository<T> where T : class
{
    private readonly ApplicationDbContext _context;
    private readonly DbSet<T> _dbSet;
    private readonly string _cacheKey = $"{typeof(T)}";
    private readonly ICache _redisCache;
    private readonly SemaphoreSlim _lock = new(1, 1);

    protected GenericRepository(ApplicationDbContext context, ICache cache)
    {
        _context = context;
        _redisCache = cache;
        _dbSet = _context.Set<T>();
    }

    public virtual IEnumerable<T> GetAll()
    {
        // Cache-aside pattern
        if (_redisCache.TryGet(_cacheKey, out IEnumerable<T> entities))
            return entities;
        try
        {
            _lock.Wait();
            if (_redisCache.TryGet(_cacheKey, out entities))
                return entities;
            entities = _dbSet.AsNoTracking().ToList();
            _redisCache.Set(_cacheKey, entities);
            return entities;
        }
        finally
        {
            _lock.Release();
        }
    }

    public virtual void Insert(T entity)
    {
        _dbSet.Add(entity);
        _redisCache.Remove(_cacheKey);  // Invalidate cache
    }
    // ...
}
```

### 4.2. Specific Repository

**Interface mở rộng:**
```csharp
public interface IStudentRepository : IGenericRepository<Student>
{
    public IEnumerable<Student> GetStudents();
    public IEnumerable<Student> GetStudentsByNames(string? name);
    public IEnumerable<Student> GetStudentsByPhone(string? phone);
    public Student? GetStudentById(Guid? id);
    public void AddStudent(Student student);
    public void UpdateStudent(Student student);
    public void DeleteStudent(Guid id);
    public bool StudentExists(Guid? id);
}
```

**Implementation:**
```csharp
public class StudentRepository : GenericRepository<Student>, IStudentRepository
{
    public StudentRepository(ApplicationDbContext context, ICache cache) 
        : base(context, cache) { }

    public IEnumerable<Student> GetStudents() => GetAll();
    
    public IEnumerable<Student> GetStudentsByNames(string? name) => 
        GetMany(x => name != null && x.fullName != null && x.fullName.Contains(name));
    
    public Student? GetStudentById(Guid? id) => GetById(id);
    
    public void AddStudent(Student student) => Insert(student);
    
    public bool StudentExists(Guid? id) => Any(x => x.id == id);
}
```

### 4.3. Ưu Điểm Repository Pattern

1. **Separation of Concerns:** Business logic tách biệt với data access
2. **Testability:** Dễ mock repository cho unit test
3. **Flexibility:** Dễ thay đổi data source (SQL → NoSQL)
4. **Reusability:** Generic repository tái sử dụng cho nhiều entity
5. **Caching:** Tích hợp caching tập trung

---

## 5. Các Kỹ Thuật Nâng Cao

### 5.1. Caching với Redis

```csharp
public class CacheService : ICache
{
    private readonly IDistributedCache _distributedCache;
    private readonly ISubscriber _redisSubscriber;

    public void Remove(string cacheKey)
    {
        _distributedCache.Remove(cacheKey);
        _redisSubscriber.Publish("CacheUpdate", cacheKey);
    }

    public T Set<T>(string cacheKey, T value)
    {
        _distributedCache.Set(cacheKey, 
            Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(value)), 
            _cacheEntryOptions);
        return value;
    }

    public void Subscribe(Action<string> handler) => 
        _redisSubscriber.Subscribe("CacheUpdate", (_, cacheKey) => handler(cacheKey));
}
```

### 5.2. Transaction Management

```csharp
public class TransactionService
{
    private readonly ApplicationDbContext _context;

    public void ExecuteTransaction(Action action)
    {
        using var transaction = _context.Database.BeginTransaction();
        try
        {
            action();
            _context.SaveChanges();
            transaction.Commit();
        }
        catch (Exception)
        {
            transaction.Rollback();
            throw;
        }
    }
}
```

### 5.3. Middleware Pattern

**Rate Limiting:**
```csharp
public class RateLimitingMiddleware
{
    public async Task Invoke(HttpContext context)
    {
        var (cacheKey, limit, duration) = GetRateLimitingDetails(
            context.Request.Method, context.Request.Path);

        if (!_cache.TryGet<int>(cacheKey, out var requestCount))
            requestCount = 0;

        if (requestCount >= limit)
        {
            context.Response.StatusCode = 429;
            await context.Response.WriteAsync("Rate limit exceeded.");
            return;
        }

        _cache.Set(cacheKey, requestCount + 1);
        await _next(context);
    }
}
```

### 5.4. JWT Authentication

```csharp
// Token generation
var token = new JwtSecurityToken(
    issuer: _config["Jwt:Issuer"],
    audience: _config["Jwt:Audience"],
    claims: claims,
    expires: DateTime.UtcNow.Add(TimeSpan.Parse(_config["Jwt:ExpiryTimeFrame"])),
    signingCredentials: signIn
);

// Refresh token
var refreshToken = new RefreshToken
{
    jwtId = token.Id,
    token = RandomStringGeneration(64),
    addedDate = DateTime.UtcNow,
    expiryDate = DateTime.UtcNow.AddDays(10),
    isRevoked = false,
    isUsed = false,
    userId = userId
};
```

---

## 6. Mối Quan Hệ Giữa Các Entity

```
┌──────────────────────────────────────────────────────────────────┐
│                         DATABASE SCHEMA                          │
└──────────────────────────────────────────────────────────────────┘

ApplicationUser (1) ────────────── (n) Teacher
                                        │
                                        │ (1)
                                        ▼
                                      Class (n) ──── (1) Branch
                                        │
                                        │ (n)
                                        ▼
ClassStudent ◄──── (n) ────────── (1) Student
     │
     │ (n)
     ▼
Attendance ────────────────────── (1) Lesson
                                        │
                                        │ (n)
                                        ▼
                                      Course (n) ──── (1) Category

RefreshToken ─────────────────── ApplicationUser
IdentityClaim ────────────────── ApplicationUser
```

**Quan hệ chi tiết:**
- `ApplicationUser` → `Teacher`: 1-n (một user có thể là nhiều teacher profiles)
- `Teacher` → `Class`: 1-n (một giáo viên dạy nhiều lớp)
- `Branch` → `Class`: 1-n (một chi nhánh có nhiều lớp)
- `Class` ↔ `Student`: n-n (qua `ClassStudent`)
- `Class` → `Attendance`: 1-n (một lớp có nhiều điểm danh)
- `Lesson` → `Attendance`: 1-n (một bài học có nhiều điểm danh)
- `Course` → `Lesson`: 1-n (một khóa học có nhiều bài)
- `Category` → `Course`: 1-n (một danh mục có nhiều khóa học)

---

## 7. Luồng Xử Lý Request

```
HTTP Request
     │
     ▼
┌─────────────────────┐
│    Middleware       │  ← SecurityHeaders, Timeout, RateLimiting
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│  Authentication     │  ← JWT validation
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│   Authorization     │  ← Role/Policy check
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│    Controller       │  ← StudentController, ClassController...
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│     Service         │  ← StudentService, ClassService...
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│    Repository       │  ← StudentRepository, ClassRepository...
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│  Cache (Redis)      │  ← Try cache first
└─────────────────────┘
     │ (cache miss)
     ▼
┌─────────────────────┐
│  DbContext (EF)     │  ← Query database
└─────────────────────┘
     │
     ▼
┌─────────────────────┐
│   SQL Server        │  ← Actual data
└─────────────────────┘
```

---

## 8. Bài Học Rút Ra

### 8.1. Về Clean Architecture

✅ **Làm tốt:**
- Tách biệt rõ ràng các layer
- Domain layer độc lập, không phụ thuộc framework
- Sử dụng interface để đảo ngược dependency

⚠️ **Cần cải thiện:**
- Service trực tiếp tạo Repository (vi phạm DI)
- Nên inject IRepository thay vì tạo `new Repository()` trong Service

### 8.2. Về Repository Pattern

✅ **Làm tốt:**
- Generic Repository giảm code trùng lặp
- Tích hợp caching trong repository
- Interface rõ ràng, dễ test

⚠️ **Cần cải thiện:**
- Thiếu Unit of Work pattern
- Nên có Repository Factory

### 8.3. Về Best Practices

✅ **Đã áp dụng:**
- JWT Authentication với Refresh Token
- Rate Limiting
- Security Headers
- Health Checks
- Logging với ELK Stack
- Response Compression
- Swagger documentation

⚠️ **Có thể bổ sung:**
- Validation với FluentValidation
- CQRS pattern cho read/write separation
- MediatR cho loose coupling
- API versioning proper
- Exception handling middleware

---

## 9. Kết Luận

**SaoVietAPI** là một dự án tốt để học về:

1. **Clean Architecture:** Hiểu cách tổ chức code theo layers
2. **Repository Pattern:** Hiểu cách abstract data access
3. **Dependency Injection:** Hiểu cách loosely couple components
4. **Caching Strategy:** Hiểu Cache-Aside pattern với Redis
5. **Security:** Hiểu JWT authentication flow
6. **Middleware:** Hiểu pipeline processing

**Các bước tiếp theo để học sâu hơn:**
1. Refactor Service để inject IRepository qua constructor
2. Thêm Unit of Work pattern
3. Viết Unit Tests cho Repository và Service
4. Implement CQRS với MediatR
5. Thêm Integration Tests

---

*Tài liệu được tạo để hỗ trợ việc học tập Repository Pattern và Clean Architecture.*
