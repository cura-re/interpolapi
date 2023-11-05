using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class ChannelComment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string ChannelId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual Channel Channel { get; set; } = null!;

    public virtual Photo? Photo { get; set; }
}
