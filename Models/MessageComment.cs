using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class MessageComment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public string MessageId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual MessageTable Message { get; set; } = null!;

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
