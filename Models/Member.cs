using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Member
{
    public string MemberId { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public string CommunityId { get; set; } = null!;

    public virtual Community Community { get; set; } = null!;

    public virtual InterpolUser User { get; set; } = null!;
}
