using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Shape
{
    public string ShapeId { get; set; } = null!;

    public string ShapeName { get; set; } = null!;

    public byte PositionX { get; set; }

    public byte PositionY { get; set; }

    public byte PositionZ { get; set; }

    public byte Height { get; set; }

    public byte Width { get; set; }

    public byte Depth { get; set; }

    public byte Radius { get; set; }

    public byte ShapeLength { get; set; }

    public string Color { get; set; } = null!;

    public byte ColorValue { get; set; }

    public string GltfId { get; set; } = null!;

    public virtual Gltf Gltf { get; set; } = null!;
}
