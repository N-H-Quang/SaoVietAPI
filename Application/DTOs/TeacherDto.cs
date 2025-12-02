namespace Application.DTOs
{
    /**
    * @Project ASP.NET Core 7.0
    * @Author: Nguyen Xuan Nhan
    * @Team: 4FT
    * @Copyright (C) 2023 4FT. All rights reserved
    * @License MIT
    * @Create date Mon 23 Jan 2023 00:00:00 AM +07
    */

    /// <summary>
    /// Data Transfer Object for Teacher
    /// </summary>
    public class TeacherDto
    {
        public Guid? Id { get; set; }
        public string? FullName { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string? CustomerId { get; set; }
    }

    /// <summary>
    /// DTO for creating a new teacher
    /// </summary>
    public class CreateTeacherDto
    {
        public string? FullName { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string? CustomerId { get; set; }
    }

    /// <summary>
    /// DTO for updating an existing teacher
    /// </summary>
    public class UpdateTeacherDto
    {
        public string? FullName { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string? CustomerId { get; set; }
    }
}
