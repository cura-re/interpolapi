﻿using System.ComponentModel.DataAnnotations;

namespace interpolapi.Models
{
    public class Favorite
    {
        public int FavoriteId { get; set; }

        public int ContentId { get; set; }

        public string? UserId { get; set; }

        public User? User { get; set; }

        public string ContentType { get; set; }

        [DataType(DataType.Date)]
        public DateTime DateCreated { get; set; } = DateTime.UtcNow;
    }
}