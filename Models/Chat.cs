using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Chat
{
    public string ChatId { get; set; } = null!;

    public string ChatTitle { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string AiId { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public virtual ArtificialIntelligence Ai { get; set; } = null!;

    public virtual ICollection<ChatComment> ChatComments { get; set; } = new List<ChatComment>();

    public virtual ICollection<Prompt> Prompts { get; set; } = new List<Prompt>();

    public virtual InterpolUser User { get; set; } = null!;

    public virtual ICollection<UserChatComment> UserChatComments { get; set; } = new List<UserChatComment>();
}
