using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Gltf
{
    public string GltfId { get; set; } = null!;

    public string FileName { get; set; } = null!;

    public string FileType { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public virtual ICollection<GltfComment> GltfComments { get; set; } = new List<GltfComment>();

    public virtual ICollection<Shape> Shapes { get; set; } = new List<Shape>();

    public virtual InterpolUser User { get; set; } = null!;
}
