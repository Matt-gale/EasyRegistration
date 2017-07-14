using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.Extensions.Configuration;

namespace EasyRegistrationWeb.Controllers
{
    [Filters.ExceptionFilter]
    public abstract class BaseController : Controller
    {
        protected IConfigurationRoot _config;

        public BaseController(IConfigurationRoot config)
        {
            _config = config;
        }


        [HttpGet]
        [Route("ping")]
        public virtual IActionResult Ping()
        {
            return Ok();
        }

        protected string GetClientIPAddress()
        {
            var remoteIpAddress2 = HttpContext.Features.Get<IHttpConnectionFeature>()?.RemoteIpAddress;

            return remoteIpAddress2.ToString();
        }
    }
}
