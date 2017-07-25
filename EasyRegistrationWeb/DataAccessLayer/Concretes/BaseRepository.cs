using EasyRegistration.DataAccessLayer.Entities;
using EasyRegistration.DataAccessLayer.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.DataAccessLayer.Concretes
{
    public class BaseRepository: IDisposable
    {
        protected EasyRegistrationDBContext dbContext;

        public BaseRepository(EasyRegistrationDBContext DB)
        {
            dbContext = DB;
        }
        
        public void Dispose()
        {
            dbContext.Dispose();
        }
    }
}
