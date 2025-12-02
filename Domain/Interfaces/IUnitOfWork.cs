namespace Domain.Interfaces
{
    /**
    * @Project ASP.NET Core 7.0
    * @Author: Nguyen Xuan Nhan
    * @Team: 4FT
    * @Copyright (C) 2023 4FT. All rights reserved
    * @License MIT
    * @Create date Mon 23 Jan 2023 00:00:00 AM +07
    */

    public interface IUnitOfWork : IDisposable
    {
        ITeacherRepository Teachers { get; }
        IStudentRepository Students { get; }
        IClassRepository Classes { get; }
        ICourseRepository Courses { get; }
        IBranchRepository Branches { get; }
        ICategoryRepository Categories { get; }
        ILessonRepository Lessons { get; }
        IAttendanceRepository Attendances { get; }
        IApplicationUserRepository ApplicationUsers { get; }
        IRefreshTokenRepository RefreshTokens { get; }
        IIdentityClaimRepository IdentityClaims { get; }
        IClassStudentRepository ClassStudents { get; }

        int SaveChanges();
        Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
        void BeginTransaction();
        void Commit();
        void Rollback();
    }
}
