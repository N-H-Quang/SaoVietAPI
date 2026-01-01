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
    /// Data Transfer Object for Student
    /// </summary>
    public class StudentDto
    {
        public Guid? Id { get; set; }
        public string? FullName { get; set; }
        public string? Dob { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
    }

    /// <summary>
    /// DTO for creating a new student
    /// </summary>
    public class CreateStudentDto
    {
        public string? FullName { get; set; }
        public string? Dob { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
    }

    /// <summary>
    /// DTO for updating an existing student
    /// </summary>
    public class UpdateStudentDto
    {
        public string? FullName { get; set; }
        public string? Dob { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }
    }
}
