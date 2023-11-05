using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Device
{
    public string DeviceId { get; set; } = null!;

    public string DeviceName { get; set; } = null!;

    public string? DeviceDescription { get; set; }

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public virtual ICollection<Pin> Pins { get; set; } = new List<Pin>();

    public virtual InterpolUser User { get; set; } = null!;
}
