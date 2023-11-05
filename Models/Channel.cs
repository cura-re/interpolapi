using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Channel
{
    public string ChannelId { get; set; } = null!;

    public string ChannelName { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string? ChannelDescription { get; set; }

    public string CommunityId { get; set; } = null!;

    public virtual ICollection<ChannelComment> ChannelComments { get; set; } = new List<ChannelComment>();

    public virtual Community Community { get; set; } = null!;
}
