﻿using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using EasyRegistration.BusinessLogic;
using EasyRegistration.DataAccessLayer;
using EasyRegistration.BusinessLogic.Interfaces;
using EasyRegistration.BusinessLogic.Concretes;
using EasyRegistration.DataAccessLayer.Interfaces;
using EasyRegistration.DataAccessLayer.Concretes;
using EasyRegistration.DataAccessLayer.Entities;

namespace EasyRegistrationWeb
{
    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            Configuration = builder.Build();
        }

        public IConfigurationRoot Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            // Add framework services.
            services.AddMvc();

            //DI - Logic layer
            services.AddScoped<IAccountLogic, AccountLogic>();

            //DI - Repository layer
            services.AddScoped<IAccountRepository, AccountRepository>();

            //get connection string from configuration files
            var connString = Configuration["Database:ConnectionString"];
            var isSqliteDatabase = Configuration["Database:IsSqliteDatabase"] == System.Boolean.TrueString.ToLower();

            //set up sqlite or sqlserver database
            services = EasyRegistrationDBContext.DIRegistration(services, connString, isSqliteDatabase);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();


            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
            }


            app.Use(async (context, next) =>
            {
                await next();
                // If there’s no available file and the request doesn’t contain an extension, we’re probably trying to access a page.
                // Rewrite request to use app root
                if (context.Response.StatusCode == 404 && !Path.HasExtension(context.Request.Path.Value) && !context.Request.Path.Value.StartsWith("/api"))
                {
                    context.Request.Path = "/index.html";
                    context.Response.StatusCode = 200; // Make sure we update the status code, otherwise it returns 404
                    await next();
                }
            });

            app.UseDefaultFiles();
            app.UseStaticFiles();

            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");
            });
        }
    }
}
