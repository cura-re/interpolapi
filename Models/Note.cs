using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Note
{
    public string NoteId { get; set; } = null!;

    public string NoteTitle { get; set; } = null!;

    public string PanelId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual Panel Panel { get; set; } = null!;

    public virtual Photo? Photo { get; set; }
}
