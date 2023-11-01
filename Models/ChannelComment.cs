﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace interpolapi.Models
{
	public class ChannelComment
	{
        public int ChannelCommentId { get; set; }

        public string CommentValue { get; set; }

        public string? MediaLink { get; set; }

        public string Type { get; set; } = "channelcomment";

        [NotMapped]
        public IFormFile? ImageFile { get; set; }

        [NotMapped]
        public string? ImageSource { get; set; }

        [DataType(DataType.Date)]
        public DateTime DateCreated { get; set; } = DateTime.UtcNow;

        public int? ChannelId { get; set; }
        public Channel? Channels { get; set; }

        public string? UserId { get; set; }
        public User? User { get; set; }
    }
}

