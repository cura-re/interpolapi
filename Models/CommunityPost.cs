using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class CommunityPost
{
    public string PostId { get; set; } = null!;

    public string? PostContent { get; set; }

    public DateTime DateCreated { get; set; }

    public string CommunityId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual Community Community { get; set; } = null!;

    public virtual ICollection<CommunityComment> CommunityComments { get; set; } = new List<CommunityComment>();

    public virtual Photo? Photo { get; set; }
}
