using System.ComponentModel.DataAnnotations;

namespace interpolapi.Models
{
    public class Follower
    {
        public int FollowerId { get; set; }

        public int FollowerUser { get; set; }

        public string? UserId { get; set; }
        public User? User { get; set; }

        [DataType(DataType.Date)]
        public DateTime DateCreated { get; set; } = DateTime.UtcNow;
    }
}