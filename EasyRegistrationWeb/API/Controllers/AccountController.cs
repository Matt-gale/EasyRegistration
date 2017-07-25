using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using EasyRegistration.DTO;
using EasyRegistration.BusinessLogic.Interfaces;
using EasyRegistration.API.ModelValidators;
using EasyRegistration.Library;

namespace EasyRegistrationWeb.Controllers
{
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class AccountController : BaseController
    {
        private IAccountLogic _accountLogic { get; set; }

        public AccountController(IConfigurationRoot config, IAccountLogic accountLogic) : base(config)
        {
            _accountLogic = accountLogic;
        }

        [HttpPost]
        [Route("Login")]
        public IActionResult Login([FromBody]LoginDTO dto)
        {
            var validationErrors = dto.Validate();
            if (validationErrors.Any())
            {
                return ShowErrors(validationErrors, 401); //Unauthorised.
            }

            var result = _accountLogic.Login(dto);
            if(result.Status == ResponseStatus.Success)
            {
                return new OkResult();
            }
            else
            {
                return ShowErrors(result.Errors, 401); //Unauthorised.
            }
            
        }

        [HttpPost]
        [Route("Register")]
        public IActionResult Register([FromBody]RegisterDTO dto)
        {
            //return new JsonResult();
            return new OkResult();
        }

        [HttpPost]
        [Route("Logout")]
        public IActionResult Logout([FromBody]int userId)
        {
            //return new JsonResult();
            return new OkResult();
        }

        [HttpPost]
        [Route("GetUser")]
        public IActionResult GetUser([FromBody]LoginDTO dto)
        {
            //return new JsonResult();
            return new OkResult();
        }
    }
}
