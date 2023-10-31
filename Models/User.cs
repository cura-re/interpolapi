using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace interpol.Models;

public class User {
    public string Id { get; set; } = Guid.NewGuid().ToString();
    [Required]
    public string UserName { get; set; }

    [Required]
    [DataType(DataType.EmailAddress)]
    public string EmailAddress { get; set; }
    public string Password { get; set; }
}