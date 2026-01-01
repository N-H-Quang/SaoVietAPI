using Domain.Interfaces;
using Microsoft.EntityFrameworkCore.Storage;

namespace Infrastructure.Repositories
{
    /**
    * @Project ASP.NET Core 7.0
    * @Author: Nguyen Xuan Nhan
    * @Team: 4FT
    * @Copyright (C) 2023 4FT. All rights reserved
    * @License MIT
    * @Create date Mon 23 Jan 2023 00:00:00 AM +07
    */

    public class UnitOfWork : IUnitOfWork
    {
        private readonly ApplicationDbContext _context;
        private readonly ICache _cache;
        private IDbContextTransaction? _transaction;
        private bool _disposed;

        private ITeacherRepository? _teachers;
        private IStudentRepository? _students;
        private IClassRepository? _classes;
        private ICourseRepository? _courses;
        private IBranchRepository? _branches;
        private ICategoryRepository? _categories;
        private ILessonRepository? _lessons;
        private IAttendanceRepository? _attendances;
        private IApplicationUserRepository? _applicationUsers;
        private IRefreshTokenRepository? _refreshTokens;
        private IIdentityClaimRepository? _identityClaims;
        private IClassStudentRepository? _classStudents;

        public UnitOfWork(ApplicationDbContext context, ICache cache)
        {
            _context = context;
            _cache = cache;
        }

        public ITeacherRepository Teachers => _teachers ??= new TeacherRepository(_context, _cache);
        public IStudentRepository Students => _students ??= new StudentRepository(_context, _cache);
        public IClassRepository Classes => _classes ??= new ClassRepository(_context, _cache);
        public ICourseRepository Courses => _courses ??= new CourseRepository(_context, _cache);
        public IBranchRepository Branches => _branches ??= new BranchRepository(_context, _cache);
        public ICategoryRepository Categories => _categories ??= new CategoryRepository(_context, _cache);
        public ILessonRepository Lessons => _lessons ??= new LessonRepository(_context, _cache);
        public IAttendanceRepository Attendances => _attendances ??= new AttendanceRepository(_context, _cache);
        public IApplicationUserRepository ApplicationUsers => _applicationUsers ??= new ApplicationUserRepository(_context, _cache);
        public IRefreshTokenRepository RefreshTokens => _refreshTokens ??= new RefreshTokenRepository(_context, _cache);
        public IIdentityClaimRepository IdentityClaims => _identityClaims ??= new IdentityClaimRepository(_context, _cache);
        public IClassStudentRepository ClassStudents => _classStudents ??= new ClassStudentRepository(_context, _cache);

        public int SaveChanges() => _context.SaveChanges();

        public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default) 
            => await _context.SaveChangesAsync(cancellationToken);

        public void BeginTransaction()
        {
            _transaction = _context.Database.BeginTransaction();
        }

        public async Task BeginTransactionAsync(CancellationToken cancellationToken = default)
        {
            _transaction = await _context.Database.BeginTransactionAsync(cancellationToken);
        }

        public void Commit()
        {
            try
            {
                _context.SaveChanges();
                _transaction?.Commit();
            }
            catch
            {
                Rollback();
                throw;
            }
            finally
            {
                _transaction?.Dispose();
                _transaction = null;
            }
        }

        public async Task CommitAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                await _context.SaveChangesAsync(cancellationToken);
                if (_transaction != null)
                    await _transaction.CommitAsync(cancellationToken);
            }
            catch
            {
                await RollbackAsync(cancellationToken);
                throw;
            }
            finally
            {
                if (_transaction != null)
                    await _transaction.DisposeAsync();
                _transaction = null;
            }
        }

        public void Rollback()
        {
            _transaction?.Rollback();
            _transaction?.Dispose();
            _transaction = null;
        }

        public async Task RollbackAsync(CancellationToken cancellationToken = default)
        {
            if (_transaction != null)
            {
                await _transaction.RollbackAsync(cancellationToken);
                await _transaction.DisposeAsync();
            }
            _transaction = null;
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed && disposing)
            {
                _transaction?.Dispose();
                _context.Dispose();
            }
            _disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
