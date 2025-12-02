namespace Shared.Constants
{
    /**
    * @Project ASP.NET Core 7.0
    * @Author: Nguyen Xuan Nhan
    * @Team: 4FT
    * @Copyright (C) 2023 4FT. All rights reserved
    * @License MIT
    * @Create date Mon 23 Jan 2023 00:00:00 AM +07
    */

    public static class AppConstants
    {
        public const string ApplicationName = "SaoVietAPI";
        public const string Version = "1.0.0";
        
        public static class Policies
        {
            public const string Admin = "Admin";
            public const string Teacher = "Teacher";
            public const string Student = "Student";
            public const string President = "President";
        }

        public static class CacheKeys
        {
            public const string Teachers = "Teachers";
            public const string Students = "Students";
            public const string Classes = "Classes";
            public const string Courses = "Courses";
            public const string Branches = "Branches";
            public const string Categories = "Categories";
            public const string Lessons = "Lessons";
            public const string Attendances = "Attendances";
        }
    }
}
