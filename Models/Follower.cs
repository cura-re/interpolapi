using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Follower
{
    public string UserId { get; set; } = null!;

    public string FollowerId { get; set; } = null!;

    public virtual InterpolUser FollowerNavigation { get; set; } = null!;

    public virtual InterpolUser User { get; set; } = null!;
}
