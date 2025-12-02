using Application.Interfaces;
using Application.Services;
using Application.Transaction;
using Microsoft.Extensions.DependencyInjection;

namespace Application.Extensions
{
    /**
    * @Project ASP.NET Core 7.0
    * @Author: Nguyen Xuan Nhan
    * @Team: 4FT
    * @Copyright (C) 2023 4FT. All rights reserved
    * @License MIT
    * @Create date Mon 23 Jan 2023 00:00:00 AM +07
    */

    public static class ApplicationServiceExtensions
    {
        public static IServiceCollection AddApplication(this IServiceCollection services)
        {
            // Add Services with interfaces
            services.AddTransient<ITeacherService, TeacherService>();
            services.AddTransient<ClassService>();
            services.AddTransient<BranchService>();
            services.AddTransient<StudentService>();
            services.AddTransient<CategoryService>();
            services.AddTransient<CourseService>();
            services.AddTransient<LessonService>();
            services.AddTransient<AttendanceService>();
            services.AddTransient<AuthenticationService>();
            services.AddTransient<AuthorizationService>();

            // Add Transaction Service
            services.AddTransient<TransactionService>();

            return services;
        }
    }
}
