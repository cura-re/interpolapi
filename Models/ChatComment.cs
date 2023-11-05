using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class ChatComment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string ChatId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual Chat Chat { get; set; } = null!;

    public virtual Photo? Photo { get; set; }
}
