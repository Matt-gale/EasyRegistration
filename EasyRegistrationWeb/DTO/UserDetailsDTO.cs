using System;

namespace EasyRegistration.DTO
{
    public class UserDetailsDTO
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string ReEnterPassword { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
