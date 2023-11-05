using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Panel
{
    public string PanelId { get; set; } = null!;

    public string PanelTitle { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual ICollection<Note> Notes { get; set; } = new List<Note>();

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
