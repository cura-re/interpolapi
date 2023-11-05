using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class Photo
{
    public string PhotoId { get; set; } = null!;

    public string ImageLink { get; set; } = null!;

    public string ImageSource { get; set; } = null!;

    public byte[] ImageData { get; set; } = null!;

    public virtual ICollection<ArtificialIntelligence> ArtificialIntelligences { get; set; } = new List<ArtificialIntelligence>();

    public virtual ICollection<ChannelComment> ChannelComments { get; set; } = new List<ChannelComment>();

    public virtual ICollection<ChatComment> ChatComments { get; set; } = new List<ChatComment>();

    public virtual ICollection<Comment> Comments { get; set; } = new List<Comment>();

    public virtual ICollection<Community> Communities { get; set; } = new List<Community>();

    public virtual ICollection<CommunityComment> CommunityComments { get; set; } = new List<CommunityComment>();

    public virtual ICollection<CommunityPost> CommunityPosts { get; set; } = new List<CommunityPost>();

    public virtual ICollection<GltfComment> GltfComments { get; set; } = new List<GltfComment>();

    public virtual ICollection<InterpolUser> InterpolUsers { get; set; } = new List<InterpolUser>();

    public virtual ICollection<MessageComment> MessageComments { get; set; } = new List<MessageComment>();

    public virtual ICollection<Note> Notes { get; set; } = new List<Note>();

    public virtual ICollection<Panel> Panels { get; set; } = new List<Panel>();

    public virtual ICollection<Post> Posts { get; set; } = new List<Post>();

    public virtual ICollection<UserChatComment> UserChatComments { get; set; } = new List<UserChatComment>();
}
