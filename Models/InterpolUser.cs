using System;
using System.Collections.Generic;

namespace interpolapi.Models;

public partial class InterpolUser
{
    public string UserId { get; set; } = null!;

    public string UserName { get; set; } = null!;

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public DateTime DateOfBirth { get; set; }

    public DateTime DateCreated { get; set; }

    public string EmailAddress { get; set; } = null!;

    public byte[] UserPassword { get; set; } = null!;

    public Guid? Salt { get; set; }

    public string About { get; set; } = null!;

    public string PhotoId { get; set; } = null!;

    public string ImageLink { get; set; } = null!;

    public byte[] ImageData { get; set; } = null!;

    public virtual ICollection<ArtificialIntelligence> ArtificialIntelligences { get; set; } = new List<ArtificialIntelligence>();

    public virtual ICollection<Chat> Chats { get; set; } = new List<Chat>();

    public virtual ICollection<Community> Communities { get; set; } = new List<Community>();

    public virtual ICollection<Device> Devices { get; set; } = new List<Device>();

    public virtual ICollection<DocFile> DocFiles { get; set; } = new List<DocFile>();

    public virtual ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();

    public virtual ICollection<GltfComment> GltfComments { get; set; } = new List<GltfComment>();

    public virtual ICollection<Gltf> Gltfs { get; set; } = new List<Gltf>();

    public virtual ICollection<Member> Members { get; set; } = new List<Member>();

    public virtual ICollection<MessageComment> MessageComments { get; set; } = new List<MessageComment>();

    public virtual ICollection<MessageTable> MessageTableFollowers { get; set; } = new List<MessageTable>();

    public virtual ICollection<MessageTable> MessageTableUsers { get; set; } = new List<MessageTable>();

    public virtual ICollection<Panel> Panels { get; set; } = new List<Panel>();

    public virtual Photo? Photo { get; set; }

    public virtual ICollection<Post> Posts { get; set; } = new List<Post>();

    public virtual ICollection<Prompt> Prompts { get; set; } = new List<Prompt>();

    public virtual ICollection<UserChatComment> UserChatComments { get; set; } = new List<UserChatComment>();
}
