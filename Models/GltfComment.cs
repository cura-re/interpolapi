using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class GltfComment
{
    public string CommentId { get; set; } = null!;

    public string Content { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public string GltfId { get; set; } = null!;

    public string? PhotoId { get; set; }

    public virtual Gltf Gltf { get; set; } = null!;

    public virtual Photo? Photo { get; set; }

    public virtual InterpolUser User { get; set; } = null!;
}
