using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Pin
{
    public string PinId { get; set; } = null!;

    public string PinLocation { get; set; } = null!;

    public bool? IsAnalog { get; set; }

    public string DeviceId { get; set; } = null!;

    public virtual ICollection<ActionTable> ActionTables { get; set; } = new List<ActionTable>();

    public virtual Device Device { get; set; } = null!;
}
