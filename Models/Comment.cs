using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Comment
{
    public string UserId { get; set; } = null!;
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string PostId { get; set; } = null!;

    public string? PhotoId { get; set; }
    public byte[]? ImageData { get; set; }

    public virtual Photo? Photo { get; set; }

    public virtual Post Post { get; set; } = null!;
    public virtual InterpolUser User { get; set; } = null!;
}
