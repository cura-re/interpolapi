using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Comment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string PostId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual Photo? Photo { get; set; }

    public virtual Post Post { get; set; } = null!;
}
