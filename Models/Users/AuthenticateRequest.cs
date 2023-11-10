using System.ComponentModel.DataAnnotations;

namespace interpolapi.Models.Users
{
	public class AuthenticateRequest
	{
        [Required]
        public string Username { get; set; } = null!;

        [Required]
        public string Password { get; set; } = null!;
    }
}

