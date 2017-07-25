using System;
using System.ComponentModel.DataAnnotations;

namespace EasyRegistration.DataAccessLayer.Entities
{
    public class BaseEntity
    {
        public int? Id { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public int UpdateCount { get; set; }

        [Timestamp]
        public byte[] TimeStamp { get; set; }
    }
}