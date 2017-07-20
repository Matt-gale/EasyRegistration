using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EasyRegistration.DTO
{
    public class Response<T>
    {
        public List<CustomException> Errors { get; set; } = new List<CustomException>();
        public T Data { get; set; }

        public ResponseStatus Status => Errors.Any(e => e.Type == ExceptionType.Error || e.Type == ExceptionType.Warning) ? ResponseStatus.Failure : ResponseStatus.Success;
    }

    public enum ResponseStatus
    {
        Success,
        Failure
    }
}
