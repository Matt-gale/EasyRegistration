using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.Extensions.Configuration;
using EasyRegistration.DTO;

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

        protected IActionResult ShowErrors(List<CustomException> Errors, int StatusCode = 422)
        {
            // if no errors have been added to the array then just show the
            // generic error. This should not happen in production but exists
            // as a catch all in case of programmer laziness
            if (!Errors.Any())
                Errors.Add(ERErrorMessages.EndpointNotAvailable_1);

            var result = new JsonResult(Errors);
            result.StatusCode = StatusCode;

            if (StatusCode != 225)
            {
                var logMessage = Errors.Select(e =>
                {
                    var output = "";
                    output += "Error Action: " + e.Action;
                    output += " ;Error Message: " + e.Message;
                    output += " ;Error Reason:" + e.Reason;
                    output += " ;Error Number: " + e.Number;
                    return output;
                })
                .Aggregate((f, s) => f + " " + s).ToString();

                //_logger.LogInformation("Returning Error: statusCode: {0}, Errors: {1}", StatusCode, logMessage);

            }
            return result;
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
