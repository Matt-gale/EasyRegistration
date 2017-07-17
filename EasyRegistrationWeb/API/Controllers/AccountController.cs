using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using EasyRegistration.DTO;

namespace EasyRegistrationWeb.Controllers
{
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class AccountController : BaseController
    {
        public AccountController(IConfigurationRoot config) : base(config)
        {

        }

        [HttpPost]
        [Route("Login")]
        public IActionResult Login([FromBody]LoginDTO dto)
        {
            //return new JsonResult();
            return new OkResult();
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
