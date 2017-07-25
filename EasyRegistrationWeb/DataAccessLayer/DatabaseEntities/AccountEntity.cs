using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.DataAccessLayer.Entities
{
    public class AccountEntity : BaseEntity
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
