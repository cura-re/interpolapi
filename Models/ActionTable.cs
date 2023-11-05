using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class ActionTable
{
    public string ActionId { get; set; } = null!;

    public string ActionName { get; set; } = null!;

    public string? ActionDescription { get; set; }

    public DateTime DateCreated { get; set; }

    public string PinId { get; set; } = null!;

    public virtual Pin Pin { get; set; } = null!;
}
