using EasyRegistration.BusinessLogic.Concretes;
using EasyRegistration.BusinessLogic.Interfaces;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.BusinessLogic
{
    public static class BusinessLogicDI
    {
        public static IServiceCollection InjectBusinessLogic(this IServiceCollection services)
        {
            services = services.AddSingleton<IAccountLogic, AccountLogic>();

            return services;
        }
    }
}
