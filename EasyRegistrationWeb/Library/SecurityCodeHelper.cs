using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace EasyRegistration.Library
{
    public class SecurityCodeHelper
    {
        public static string Generate()
        {
            int randNumber = 0;
            int codeLength = 4;

            var rng = RandomNumberGenerator.Create();
            var bytes = new byte[4];
            rng.GetBytes(bytes);

            randNumber = BitConverter.ToInt32(bytes, 0);

            if (randNumber < 0) randNumber *= -1;

            var randString = randNumber.ToString();

            //pad with 0's
            if (randString.Length < codeLength)
            {
                var zeroes = "";
                for (int i = randString.Length; i <= codeLength; i++)
                {
                    zeroes += "0";
                }
                randString = zeroes + randString;
            }

            randString = randString.Substring(randString.Length - codeLength, codeLength);
            return randString;
        }
    }
}
