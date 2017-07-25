using System;
using System.Globalization;

namespace EasyRegistration.Library
{
    public static class HelperExtensions
    {
        public static bool IsEmpty(this string input)
        {
            return string.IsNullOrEmpty(input);
        }

        public static bool IsWhiteSpace(this string input)
        {
            return string.IsNullOrWhiteSpace(input);
        }

        public static Guid? ToGuid(this string input)
        {
            try
            {
                var output = Guid.Empty;
                if (Guid.TryParse(input, out output))
                {
                    return output;
                }
                else
                {
                    return null;
                }
            }
            catch
            {
                return null;
            }
        }
        
        private static decimal? ToDecimal(this string input)
        {
            try
            {
                var output = decimal.MinValue;
                if (decimal.TryParse(input, out output))
                {
                    return output;
                }
                else
                {
                    return null;
                }
            }
            catch
            {
                return null;
            }
        }

        public static int? ToInt(this string input)
        {
            try
            {
                var output = int.MinValue;
                if (int.TryParse(input, out output))
                {
                    return output;
                }
                else
                {
                    return null;
                }
            }
            catch
            {
                return null;
            }
        }

        public static string ToBase64String(this byte[] input)
        {
            try
            {
                return Convert.ToBase64String(input);
                
            }
            catch
            {
                return null;
            }
        }

        public static byte[] FromBase64String(this string input)
        {
            try
            {
                return Convert.FromBase64String(input);

            }
            catch
            {
                return null;
            }
        }

        /// <summary>
        /// convert 636281106949894330_testing.com.au#EXT#@tacsopadcanary.onmicrosoft.com to 636281106949894330@testing.com.au
        /// </summary>
        /// <param name="userPrincipal"></param>
        /// <returns>username</returns>
        public static string FromUserPrincipalToUserName(this string userPrincipal)
        {
            string end = "#EXT#";
            string at = "_";

            if (!userPrincipal.Contains(end) && !userPrincipal.Contains(at))
            {
                return null;
            }
            
            var index = userPrincipal.IndexOf(end);
            var username = userPrincipal.Substring(0, index);

            username = username.Replace(at, "@");
            return username;
        }

        public static string ToAustralianDateFormat(this DateTime input)
        {
            try
            {
                return input.ToString("dd/MM/yyyy");
            }
            catch
            {
                return string.Empty;
            }
        }

        public static DateTime? FromAustralianDateFormat(this string fromString)
        {
            try
            {
                return DateTime.ParseExact(fromString, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            }
            catch
            {
                return null;
            }
        }

        public static string ToSQLDateFormat(this DateTime input)
        {
            try
            {
                return input.ToString("yyyy-MM-dd");
            }
            catch
            {
                return null;
            }
        }

        public static DateTime? FromSQLDateFormat(this string input)
        {
            try
            {
                return DateTime.ParseExact(input, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            }
            catch
            {
                return null;
            }

        }
        
        public static string ToISO8601DateTimeFormatWithoutTimeZone(this DateTime input)
        {
            try
            {
                return input.ToString("yyyy-MM-ddThh:mm:ss");
            }
            catch
            {
                return null;
            }

        }

        public static DateTime? ToAESTTimeZone(this DateTime input)
        {
            try
            {
                var utc = TimeZoneInfo.FindSystemTimeZoneById("UTC");
                var aest = TimeZoneInfo.FindSystemTimeZoneById("AUS Eastern Standard Time");
                var output = TimeZoneInfo.ConvertTime(input, utc, aest);
                return output;
            }
            catch
            {
                return null;
            }
        }

        public static DateTime? ToUTCTimeZone(this DateTime input)
        {
            try
            {
                var utc = TimeZoneInfo.FindSystemTimeZoneById("UTC");
                var aest = TimeZoneInfo.FindSystemTimeZoneById("AUS Eastern Standard Time");
                var output = TimeZoneInfo.ConvertTime(input, aest, utc);
                return output;
            }
            catch
            {
                return null;
            }
        }
    }
}
