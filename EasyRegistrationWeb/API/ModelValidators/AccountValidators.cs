using EasyRegistration.DTO;
using EasyRegistration.Library;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EasyRegistration.API.ModelValidators
{
    public static class AccountValidators
    {
        public static List<CustomException> Validate(this LoginDTO dto)
        {
            var validationErrors = new List<CustomException>();
            if(dto.Username.IsEmpty() || dto.Password.IsEmpty())
            {
                validationErrors.Add(ERErrorMessages.UsernameOrPasswordIsIncorrect_2);
            }
            return validationErrors;
        }
    }
}
