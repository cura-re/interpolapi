using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Moveable
{
    public string MoveableId { get; set; } = null!;

    public byte PositionX { get; set; }

    public byte PositionY { get; set; }

    public byte PositionZ { get; set; }

    public string DocFileId { get; set; } = null!;

    public virtual DocFile DocFile { get; set; } = null!;
}
