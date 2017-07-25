using EasyRegistration.BusinessLogic.Interfaces;
using EasyRegistration.DataAccessLayer.Interfaces;
using EasyRegistration.DTO;
using EasyRegistration.Library;
using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.BusinessLogic.Concretes
{
    public class AccountLogic: IAccountLogic
    {
        private IAccountRepository _accountRepo { get; set; }

        public AccountLogic(IAccountRepository accountRepo)
        {
            _accountRepo = accountRepo;
        }

        public Response<bool> Login(LoginDTO dto)
        {
            var response = new Response<bool>();

            var canLogin = _accountRepo.Login(dto);

            if(canLogin)
            {
                response.Data = true;
            }
            else
            {
                response.Errors.Add(ERErrorMessages.UsernameOrPasswordIsIncorrect_2);
            }

            return response;
        }
    }
}
