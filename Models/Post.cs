using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Post
{
    public string PostId { get; set; } = null!;

    public string? PostContent { get; set; }

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
