using Domain.Entities;

namespace Application.Interfaces
{
    /**
    * @Project ASP.NET Core 7.0
    * @Author: Nguyen Xuan Nhan
    * @Team: 4FT
    * @Copyright (C) 2023 4FT. All rights reserved
    * @License MIT
    * @Create date Mon 23 Jan 2023 00:00:00 AM +07
    */

    public interface ITeacherService
    {
        IEnumerable<string> GetAllId();
        IEnumerable<Teacher> GetTeachers();
        IEnumerable<Teacher> FindTeacherByName(string name);
        Teacher? GetTeacherById(Guid? id);
        void AddTeacher(Teacher newTeacher);
        void UpdateTeacher(Teacher newTeacher);
        void DeleteTeacher(Guid id);
    }
}
