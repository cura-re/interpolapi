using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Audio
{
    public string AudioId { get; set; } = null!;

    public string? FileName { get; set; }
    public DateTime DateCreated { get; set; }

    public byte[]? AudioData { get; set; }
}
