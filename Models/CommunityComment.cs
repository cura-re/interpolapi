using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class CommunityComment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public string PostId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public DateTime DateCreated { get; set; }

    public virtual Photo? Photo { get; set; }

    public virtual CommunityPost Post { get; set; } = null!;
}
