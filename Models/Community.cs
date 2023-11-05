using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Community
{
    public string CommunityId { get; set; } = null!;

    public string CommunityName { get; set; } = null!;

    public string CommunityDescription { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual ICollection<Channel> Channels { get; set; } = new List<Channel>();

    public virtual ICollection<CommunityPost> CommunityPosts { get; set; } = new List<CommunityPost>();

    public virtual ICollection<Member> Members { get; set; } = new List<Member>();

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
