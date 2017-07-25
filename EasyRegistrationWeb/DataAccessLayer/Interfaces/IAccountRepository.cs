using EasyRegistration.DTO;
using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.DataAccessLayer.Interfaces
{
    public interface IAccountRepository
    {
        bool Login(LoginDTO dto);
    }
}
