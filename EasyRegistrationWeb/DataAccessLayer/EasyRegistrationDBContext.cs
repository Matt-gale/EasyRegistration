using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.DataAccessLayer.Entities
{
    public class EasyRegistrationDBContext : DbContext
    {
        public EasyRegistrationDBContext(DbContextOptions<EasyRegistrationDBContext> options)
            : base(options)
        { }

        //tables/entities
        public DbSet<AccountEntity> Accounts { get; set; }



        public static IServiceCollection DIRegistration(IServiceCollection services, string connectionString, bool useSQLite = false)
        {
            if(useSQLite)
            {
                //https://docs.microsoft.com/en-us/ef/core/get-started/netcore/new-db-sqlite
                services.AddDbContext<EasyRegistrationDBContext>(options => options.UseSqlite(connectionString));
            }
            else
            {
                //https://docs.microsoft.com/en-us/ef/core/get-started/aspnetcore/new-db
                services.AddDbContext<EasyRegistrationDBContext>(options => options.UseSqlServer(connectionString));
            }
            return services;
        }
    }
}