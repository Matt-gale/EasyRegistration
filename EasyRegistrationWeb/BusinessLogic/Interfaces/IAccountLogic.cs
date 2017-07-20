using EasyRegistration.DTO;
using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.BusinessLogic.Interfaces
{
    public interface IAccountLogic
    {
        Response<bool> Login(LoginDTO dto);
    }
}
