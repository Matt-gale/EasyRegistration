using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;



namespace EasyRegistrationWeb.Filters
{
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        public override void OnException(ExceptionContext context)
        {
            // If we have any kind of exception at all then just output a generic message. Please note that for 
            // consistency error messages are always sent out within a list
            context.Result = new JsonResult("");
            context.HttpContext.Response.StatusCode = 501;

            var message = context.Exception?.Message?.ToString() ?? "";
            var str = new string(message.Where(c => char.IsLetterOrDigit(c) || char.IsSeparator(c)).ToArray());
            context.HttpContext.Response.Headers.Add("exception", str);

            var scktrc = context.Exception?.StackTrace ?? "";
            str = new string(scktrc.Where(c => char.IsLetterOrDigit(c) || char.IsSeparator(c)).ToArray());
            context.HttpContext.Response.Headers.Add("stacktrace", str ?? "");
        }
    }
}
