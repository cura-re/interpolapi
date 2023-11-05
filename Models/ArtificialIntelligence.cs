using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class ArtificialIntelligence
{
    public string AiId { get; set; } = null!;

    public string AiName { get; set; } = null!;

    public string? AiRole { get; set; }

    public string? AiDescription { get; set; }

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual ICollection<Chat> Chats { get; set; } = new List<Chat>();

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
