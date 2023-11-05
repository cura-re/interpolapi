using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Prompt
{
    public string PromptId { get; set; } = null!;

    public string Request { get; set; } = null!;

    public string UserId { get; set; } = null!;

    public string ChatId { get; set; } = null!;

    public virtual Chat Chat { get; set; } = null!;

    public virtual InterpolUser User { get; set; } = null!;
}
