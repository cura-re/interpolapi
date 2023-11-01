﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace interpolapi.Models
{
    public class Chat
    {
        public int ChatId { get; set; }

        public string Title { get; set; }

        public string Type { get; set; } = "chat";

        public bool? IsPrivate { get; set; }

        [DataType(DataType.Date)]
        public DateTime DateCreated { get; set; } = DateTime.UtcNow;

        public string? UserId { get; set; }
        public User? User { get; set; }

        public int? ArtificialIntelligenceId { get; set; }
        public ArtificialIntelligence? ArtificialIntelligences { get; set; }

		public ICollection<ChatComment>? ChatComments { get; set; }

        public ICollection<Comment>? Comments { get; set; }

        public ICollection<UserChatComment>? UserChatComments { get; set; }

        public ICollection<Favorite>? Favorites { get; set; }
    }
}
