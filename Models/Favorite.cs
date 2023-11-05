using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Favorite
{
    public string FavoriteId { get; set; } = null!;

    public string ContentType { get; set; } = null!;

    public string ContentId { get; set; } = null!;

    public DateTime DateCreated { get; set; }

    public string UserId { get; set; } = null!;

    public virtual InterpolUser User { get; set; } = null!;
}
