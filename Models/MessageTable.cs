using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class MessageTable
{
    public string MessageId { get; set; } = null!;

    public string MessageTitle { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public string FollowerId { get; set; } = null!;

    public virtual InterpolUser Follower { get; set; } = null!;

    public virtual ICollection<MessageComment> MessageComments { get; set; } = new List<MessageComment>();

    public virtual InterpolUser User { get; set; } = null!;
}
