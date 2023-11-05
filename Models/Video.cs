using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Video
{
    public string VideoId { get; set; } = null!;

    public string? FileName { get; set; }

    public byte[]? VideoData { get; set; }
}
