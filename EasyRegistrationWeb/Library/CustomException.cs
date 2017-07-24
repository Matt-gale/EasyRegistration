using System;
using System.Collections.Generic;
using System.Text;

namespace EasyRegistration.Library
{
    public class CustomException
    {

        /// <summary>
        /// Holds a unique error number
        /// </summary>
        public int Number { get; set; }

        /// <summary>
        /// Holds the error message
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Holds the reason that the error was raised
        /// </summary>
        public string Reason { get; set; }

        /// <summary>
        /// Holds any remedial action that the user can take to correct the error
        /// </summary>
        public string Action { get; set; }

        /// <summary>
        /// Type of exception, information, warning or error.
        /// </summary>
        public ExceptionType Type { get; set; }
    }

    public enum ExceptionType
    {
        Information,
        Warning,
        Error
    }

    public class ERErrorMessages
    {
        public static CustomException EndpointNotAvailable_1 =
            new CustomException
            {
                Number = 1,
                Reason = "The target end point could be offline or the request invalid.",
                Message = "Your request could not be completed.",
                Action = "Please contact support if the issue persists for a long period.",
                Type = ExceptionType.Error
            };

        public static CustomException UsernameOrPasswordIsIncorrect_2 =
            new CustomException
            {
                Number = 2,
                Reason = "Username or Password is incorrect.",
                Message = "Your request could not be completed. The Username or Password entered is incorrect.",
                Action = "Please re-enter your Username and Password.",
                Type = ExceptionType.Error
            };
    }
}
