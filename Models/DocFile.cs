using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class DocFile
{
    public string DocFileId { get; set; } = null!;

    public string Title { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public virtual ICollection<Moveable> Moveables { get; set; } = new List<Moveable>();

    public virtual InterpolUser User { get; set; } = null!;
}
