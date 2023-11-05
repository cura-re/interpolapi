using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class UserChatComment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string ChatId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public string UserId { get; set; } = null!;

    public virtual Chat Chat { get; set; } = null!;

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
