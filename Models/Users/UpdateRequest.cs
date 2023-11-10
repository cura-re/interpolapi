using System.ComponentModel.DataAnnotations;

namespace interpolapi.Models.Users
{
    public class UpdateRequest
    {
        public string FirstName { get; set; } = null!;

        public string LastName { get; set; } = null!;

        public string Username { get; set; } = null!;

        public string Password { get; set; } = null!;

        [DataType(DataType.Date)]
        private DateTime DateOfBirth { get; set; } 

        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; } = null!;

        public string About { get; set; } = null!;

        public IFormFile? FormFile { get; set; } = null!;
    }
}

