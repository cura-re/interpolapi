using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace interpolapi.Models.Users
{
    public class RegisterRequest
    {
        [Required]
        public string FirstName { get; set; } = null!;

        [Required]
        public string LastName { get; set; } = null!;

        [Required]
        public string Username { get; set; } = null!;

        [Required]
        public string Password { get; set; } = null!;

        [Required]
        [DataType(DataType.Date)]
        private DateTime DateOfBirth { get; set; }

        [Required]
        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; } = null!;

        [Required]
        public string About { get; set; } = null!;

        public string? ImageLink { get; set; } = null!;

        [NotMapped]
        public IFormFile? ImageFile { get; set; } = null!;

        [NotMapped]
        public string? ImageSource { get; set; } = null!;
    }
}