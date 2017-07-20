using EasyRegistration.DataAccessLayer.Entities;
using EasyRegistration.DataAccessLayer.Interfaces;
using EasyRegistration.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EasyRegistration.DataAccessLayer.Concretes
{
    public class AccountRepository: BaseRepository, IAccountRepository
    {
        public AccountRepository(EasyRegistrationDBContext dbContext) : base(dbContext)
        {
        }


        public bool Login(LoginDTO dto)
        {
            var account = dbContext.Accounts.FirstOrDefault(a => a.Username == dto.Username && a.Password == dto.Password);
            return account != null;
        }
    }
}
