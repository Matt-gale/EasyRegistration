using System;

namespace EasyRegistration.DTO
{
    public class DashBoardDTO: BaseDTO
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
