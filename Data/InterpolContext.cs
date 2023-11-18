using System;
using System.Collections.Generic;
using interpolapi.Models;
using Microsoft.EntityFrameworkCore;

namespace interpolapi.Data;

public partial class InterpolContext : DbContext
{
    private readonly IConfiguration _configuration;
    private string? databaseConnection;

    public InterpolContext(DbContextOptions<InterpolContext> options, IConfiguration configuration)
        : base(options)
    {
        _configuration = configuration;
        databaseConnection = _configuration.GetConnectionString("InterpolDb");
    }

    public virtual DbSet<ActionTable> ActionTables { get; set; }

    public virtual DbSet<ArtificialIntelligence> ArtificialIntelligences { get; set; }

    public virtual DbSet<Audio> Audios { get; set; }

    public virtual DbSet<Channel> Channels { get; set; }

    public virtual DbSet<ChannelComment> ChannelComments { get; set; }

    public virtual DbSet<Chat> Chats { get; set; }

    public virtual DbSet<ChatComment> ChatComments { get; set; }

    public virtual DbSet<Comment> Comments { get; set; }

    public virtual DbSet<Community> Communities { get; set; }

    public virtual DbSet<CommunityComment> CommunityComments { get; set; }

    public virtual DbSet<CommunityPost> CommunityPosts { get; set; }

    public virtual DbSet<Device> Devices { get; set; }

    public virtual DbSet<DocFile> DocFiles { get; set; }

    public virtual DbSet<Favorite> Favorites { get; set; }

    public virtual DbSet<Follower> Followers { get; set; }

    public virtual DbSet<Gltf> Gltfs { get; set; }

    public virtual DbSet<GltfComment> GltfComments { get; set; }

    public virtual DbSet<InterpolUser> InterpolUsers { get; set; }

    public virtual DbSet<Member> Members { get; set; }

    public virtual DbSet<MessageComment> MessageComments { get; set; }

    public virtual DbSet<MessageTable> MessageTables { get; set; }

    public virtual DbSet<Moveable> Moveables { get; set; }

    public virtual DbSet<Note> Notes { get; set; }

    public virtual DbSet<Panel> Panels { get; set; }

    public virtual DbSet<Photo> Photos { get; set; }

    public virtual DbSet<Pin> Pins { get; set; }

    public virtual DbSet<Post> Posts { get; set; }

    public virtual DbSet<Prompt> Prompts { get; set; }

    public virtual DbSet<Shape> Shapes { get; set; }

    public virtual DbSet<UserChatComment> UserChatComments { get; set; }

    public virtual DbSet<Video> Videos { get; set; }


    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(databaseConnection);
    }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ActionTable>(entity =>
        {
            entity.HasKey(e => e.ActionId).HasName("PK__action_t__74EFC2172615259A");

            entity.ToTable("action_table", "interpol");

            entity.Property(e => e.ActionId)
                .HasMaxLength(50)
                .HasColumnName("action_id");
            entity.Property(e => e.ActionDescription).HasColumnName("action_description");
            entity.Property(e => e.ActionName)
                .HasMaxLength(50)
                .HasColumnName("action_name");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PinId)
                .HasMaxLength(50)
                .HasColumnName("pin_id");

            entity.HasOne(d => d.Pin).WithMany(p => p.ActionTables)
                .HasForeignKey(d => d.PinId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__action_ta__pin_i__778AC167");
        });

        modelBuilder.Entity<ArtificialIntelligence>(entity =>
        {
            entity.HasKey(e => e.AiId).HasName("PK__artifici__0372DAEEB9E44B8A");

            entity.ToTable("artificial_intelligence", "interpol", tb => tb.HasTrigger("trg_artificial_intelligence_delete"));

            entity.Property(e => e.AiId)
                .HasMaxLength(50)
                .HasColumnName("ai_id");
            entity.Property(e => e.AiDescription).HasColumnName("ai_description");
            entity.Property(e => e.AiName)
                .HasMaxLength(50)
                .HasColumnName("ai_name");
            entity.Property(e => e.AiRole)
                .HasMaxLength(50)
                .HasColumnName("ai_role");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.ArtificialIntelligences)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__artificia__photo__5441852A");

            entity.HasOne(d => d.User).WithMany(p => p.ArtificialIntelligences)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__artificia__user___534D60F1");
        });

        modelBuilder.Entity<Audio>(entity =>
        {
            entity.HasKey(e => e.AudioId).HasName("PK__audio__D71A93E7EBD2ABB2");

            entity.ToTable("audio", "interpol");

            entity.Property(e => e.AudioId)
                .HasMaxLength(50)
                .HasColumnName("audio_id");
            entity.Property(e => e.AudioData).HasColumnName("audio_data");
            entity.Property(e => e.FileName)
                .HasMaxLength(100)
                .HasColumnName("file_name");
        });

        modelBuilder.Entity<Channel>(entity =>
        {
            entity.HasKey(e => e.ChannelId).HasName("PK__channel__2D0861ABD2D6B592");

            entity.ToTable("channel", "interpol", tb => tb.HasTrigger("trg_channel_delete"));

            entity.Property(e => e.ChannelId)
                .HasMaxLength(50)
                .HasColumnName("channel_id");
            entity.Property(e => e.ChannelDescription).HasColumnName("channel_description");
            entity.Property(e => e.ChannelName)
                .HasMaxLength(50)
                .HasColumnName("channel_name");
            entity.Property(e => e.CommunityId)
                .HasMaxLength(50)
                .HasColumnName("community_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");

            entity.HasOne(d => d.Community).WithMany(p => p.Channels)
                .HasForeignKey(d => d.CommunityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__channel__communi__6B24EA82");
        });

        modelBuilder.Entity<ChannelComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__channel___E795768743879410");

            entity.ToTable("channel_comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.ChannelId)
                .HasMaxLength(50)
                .HasColumnName("channel_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");

            entity.HasOne(d => d.Channel).WithMany(p => p.ChannelComments)
                .HasForeignKey(d => d.ChannelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__channel_c__chann__6E01572D");

            entity.HasOne(d => d.Photo).WithMany(p => p.ChannelComments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__channel_c__photo__6EF57B66");
        });

        modelBuilder.Entity<Chat>(entity =>
        {
            entity.HasKey(e => e.ChatId).HasName("PK__chat__FD040B17BE665709");

            entity.ToTable("chat", "interpol", tb => tb.HasTrigger("trg_chat_delete"));

            entity.Property(e => e.ChatId)
                .HasMaxLength(50)
                .HasColumnName("chat_id");
            entity.Property(e => e.AiId)
                .HasMaxLength(50)
                .HasColumnName("ai_id");
            entity.Property(e => e.ChatTitle)
                .HasMaxLength(50)
                .HasColumnName("chat_title");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Ai).WithMany(p => p.Chats)
                .HasForeignKey(d => d.AiId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__chat__ai_id__5812160E");

            entity.HasOne(d => d.User).WithMany(p => p.Chats)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__chat__user_id__571DF1D5");
        });

        modelBuilder.Entity<ChatComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__chat_com__E7957687BECDB204");

            entity.ToTable("chat_comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.ChatId)
                .HasMaxLength(50)
                .HasColumnName("chat_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");

            entity.HasOne(d => d.Chat).WithMany(p => p.ChatComments)
                .HasForeignKey(d => d.ChatId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__chat_comm__chat___5EBF139D");

            entity.HasOne(d => d.Photo).WithMany(p => p.ChatComments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__chat_comm__photo__5FB337D6");
        });

        modelBuilder.Entity<Comment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__comment__E79576875108B243");

            entity.ToTable("comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.PostId)
                .HasMaxLength(50)
                .HasColumnName("post_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.Comments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__comment__photo_i__68487DD7");

            entity.HasOne(d => d.Post).WithMany(p => p.Comments)
                .HasForeignKey(d => d.PostId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__comment__post_id__6754599E");
        });

        modelBuilder.Entity<Community>(entity =>
        {
            entity.HasKey(e => e.CommunityId).HasName("PK__communit__3A18739FFD1E7CD7");

            entity.ToTable("community", "interpol", tb => tb.HasTrigger("trg_community_delete"));

            entity.Property(e => e.CommunityId)
                .HasMaxLength(50)
                .HasColumnName("community_id");
            entity.Property(e => e.CommunityDescription).HasColumnName("community_description");
            entity.Property(e => e.CommunityName)
                .HasMaxLength(50)
                .HasColumnName("community_name");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.Communities)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__community__photo__44FF419A");

            entity.HasOne(d => d.User).WithMany(p => p.Communities)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__community__user___440B1D61");
        });

        modelBuilder.Entity<CommunityComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__communit__E7957687AC56C783");

            entity.ToTable("community_comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.PostId)
                .HasMaxLength(50)
                .HasColumnName("post_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.CommunityComments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__community__photo__5070F446");

            entity.HasOne(d => d.Post).WithMany(p => p.CommunityComments)
                .HasForeignKey(d => d.PostId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__community__post___4F7CD00D");
        });

        modelBuilder.Entity<CommunityPost>(entity =>
        {
            entity.HasKey(e => e.PostId).HasName("PK__communit__3ED7876634D0FC57");

            entity.ToTable("community_post", "interpol", tb => tb.HasTrigger("trg_community_post_delete"));

            entity.Property(e => e.PostId)
                .HasMaxLength(50)
                .HasColumnName("post_id");
            entity.Property(e => e.CommunityId)
                .HasMaxLength(50)
                .HasColumnName("community_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.PostContent).HasColumnName("post_content");

            entity.HasOne(d => d.Community).WithMany(p => p.CommunityPosts)
                .HasForeignKey(d => d.CommunityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__community__commu__4BAC3F29");

            entity.HasOne(d => d.Photo).WithMany(p => p.CommunityPosts)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__community__photo__4CA06362");
        });

        modelBuilder.Entity<Device>(entity =>
        {
            entity.HasKey(e => e.DeviceId).HasName("PK__device__3B085D8BD5EB22EB");

            entity.ToTable("device", "interpol", tb => tb.HasTrigger("trg_device_delete"));

            entity.Property(e => e.DeviceId)
                .HasMaxLength(50)
                .HasColumnName("device_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.DeviceDescription).HasColumnName("device_description");
            entity.Property(e => e.DeviceName)
                .HasMaxLength(50)
                .HasColumnName("device_name");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Devices)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__device__user_id__71D1E811");
        });

        modelBuilder.Entity<DocFile>(entity =>
        {
            entity.HasKey(e => e.DocFileId).HasName("PK__doc_file__739BA559CD38A3FE");

            entity.ToTable("doc_file", "interpol", tb => tb.HasTrigger("trg_doc_file_delete"));

            entity.Property(e => e.DocFileId)
                .HasMaxLength(50)
                .HasColumnName("doc_file_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.Title)
                .HasMaxLength(50)
                .HasColumnName("title");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.DocFiles)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__doc_file__user_i__7A672E12");
        });

        modelBuilder.Entity<Favorite>(entity =>
        {
            entity.HasKey(e => e.FavoriteId).HasName("PK__favorite__46ACF4CB04CBB22E");

            entity.ToTable("favorite", "interpol");

            entity.Property(e => e.FavoriteId)
                .HasMaxLength(50)
                .HasColumnName("favorite_id");
            entity.Property(e => e.ContentId)
                .HasMaxLength(50)
                .HasColumnName("content_id");
            entity.Property(e => e.ContentType)
                .HasMaxLength(10)
                .IsFixedLength()
                .HasColumnName("content_type");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Favorites)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__favorite__user_i__00200768");
        });

        modelBuilder.Entity<Follower>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("follower", "interpol");

            entity.Property(e => e.FollowerId)
                .HasMaxLength(50)
                .HasColumnName("follower_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.FollowerNavigation).WithMany()
                .HasForeignKey(d => d.FollowerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__follower__follow__02FC7413");

            entity.HasOne(d => d.User).WithMany()
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__follower__user_i__02084FDA");
        });

        modelBuilder.Entity<Gltf>(entity =>
        {
            entity.HasKey(e => e.GltfId).HasName("PK__gltf__D179AC692CD071BE");

            entity.ToTable("gltf", "interpol", tb => tb.HasTrigger("trg_gltf_delete"));

            entity.Property(e => e.GltfId)
                .HasMaxLength(50)
                .HasColumnName("gltf_id");
            entity.Property(e => e.FileName)
                .HasMaxLength(50)
                .HasColumnName("file_name");
            entity.Property(e => e.FileType)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("file_type");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.Gltfs)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__gltf__user_id__160F4887");
        });

        modelBuilder.Entity<GltfComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__gltf_com__E7957687C3748225");

            entity.ToTable("gltf_comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.GltfId)
                .HasMaxLength(50)
                .HasColumnName("gltf_id");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Gltf).WithMany(p => p.GltfComments)
                .HasForeignKey(d => d.GltfId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__gltf_comm__gltf___19DFD96B");

            entity.HasOne(d => d.Photo).WithMany(p => p.GltfComments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__gltf_comm__photo__1AD3FDA4");

            entity.HasOne(d => d.User).WithMany(p => p.GltfComments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__gltf_comm__user___18EBB532");
        });

        modelBuilder.Entity<InterpolUser>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK__interpol__B9BE370FA3AC6A30");

            entity.ToTable("interpol_user", "interpol", tb => tb.HasTrigger("trg_user_delete"));

            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");
            entity.Property(e => e.About)
                .HasMaxLength(320)
                .HasColumnName("about");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.DateOfBirth)
                .HasColumnType("date")
                .HasColumnName("date_of_birth");
            entity.Property(e => e.EmailAddress)
                .HasMaxLength(320)
                .HasColumnName("email_address");
            entity.Property(e => e.FirstName)
                .HasMaxLength(50)
                .HasColumnName("first_name");
            entity.Property(e => e.LastName)
                .HasMaxLength(100)
                .HasColumnName("last_name");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.Salt).HasColumnName("salt");
            entity.Property(e => e.UserName)
                .HasMaxLength(50)
                .HasColumnName("user_name");
            entity.Property(e => e.UserPassword)
                .HasMaxLength(64)
                .IsFixedLength()
                .HasColumnName("user_password");

            entity.HasOne(d => d.Photo).WithMany(p => p.InterpolUsers)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__interpol___photo__3D5E1FD2");
        });

        modelBuilder.Entity<Member>(entity =>
        {
            entity.HasKey(e => e.MemberId).HasName("PK__member__B29B8534C914E6A2");

            entity.ToTable("member", "interpol");

            entity.Property(e => e.MemberId)
                .HasMaxLength(50)
                .HasColumnName("member_id");
            entity.Property(e => e.CommunityId)
                .HasMaxLength(50)
                .HasColumnName("community_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Community).WithMany(p => p.Members)
                .HasForeignKey(d => d.CommunityId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__member__communit__48CFD27E");

            entity.HasOne(d => d.User).WithMany(p => p.Members)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__member__user_id__47DBAE45");
        });

        modelBuilder.Entity<MessageComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__message___E7957687BFAA068B");

            entity.ToTable("message_comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.MessageId)
                .HasMaxLength(50)
                .HasColumnName("message_id");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Message).WithMany(p => p.MessageComments)
                .HasForeignKey(d => d.MessageId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__message_c__messa__0A9D95DB");

            entity.HasOne(d => d.Photo).WithMany(p => p.MessageComments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__message_c__photo__0B91BA14");

            entity.HasOne(d => d.User).WithMany(p => p.MessageComments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__message_c__user___09A971A2");
        });

        modelBuilder.Entity<MessageTable>(entity =>
        {
            entity.HasKey(e => e.MessageId).HasName("PK__message___0BBF6EE67C16FC8A");

            entity.ToTable("message_table", "interpol");

            entity.Property(e => e.MessageId)
                .HasMaxLength(50)
                .HasColumnName("message_id");
            entity.Property(e => e.FollowerId)
                .HasMaxLength(50)
                .HasColumnName("follower_id");
            entity.Property(e => e.MessageTitle)
                .HasMaxLength(50)
                .HasColumnName("message_title");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Follower).WithMany(p => p.MessageTableFollowers)
                .HasForeignKey(d => d.FollowerId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__message_t__follo__06CD04F7");

            entity.HasOne(d => d.User).WithMany(p => p.MessageTableUsers)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__message_t__user___05D8E0BE");
        });

        modelBuilder.Entity<Moveable>(entity =>
        {
            entity.HasKey(e => e.MoveableId).HasName("PK__moveable__02C549CCD629CC81");

            entity.ToTable("moveable", "interpol");

            entity.Property(e => e.MoveableId)
                .HasMaxLength(50)
                .HasColumnName("moveable_id");
            entity.Property(e => e.DocFileId)
                .HasMaxLength(50)
                .HasColumnName("doc_file_id");
            entity.Property(e => e.PositionX).HasColumnName("position_x");
            entity.Property(e => e.PositionY).HasColumnName("position_y");
            entity.Property(e => e.PositionZ).HasColumnName("position_z");

            entity.HasOne(d => d.DocFile).WithMany(p => p.Moveables)
                .HasForeignKey(d => d.DocFileId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__moveable__doc_fi__7D439ABD");
        });

        modelBuilder.Entity<Note>(entity =>
        {
            entity.HasKey(e => e.NoteId).HasName("PK__note__CEDD0FA4737D816C");

            entity.ToTable("note", "interpol");

            entity.Property(e => e.NoteId)
                .HasMaxLength(50)
                .HasColumnName("note_id");
            entity.Property(e => e.NoteTitle)
                .HasMaxLength(50)
                .HasColumnName("note_title");
            entity.Property(e => e.PanelId)
                .HasMaxLength(50)
                .HasColumnName("panel_id");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");

            entity.HasOne(d => d.Panel).WithMany(p => p.Notes)
                .HasForeignKey(d => d.PanelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__note__panel_id__123EB7A3");

            entity.HasOne(d => d.Photo).WithMany(p => p.Notes)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__note__photo_id__1332DBDC");
        });

        modelBuilder.Entity<Panel>(entity =>
        {
            entity.HasKey(e => e.PanelId).HasName("PK__panel__E48CAC61A033802F");

            entity.ToTable("panel", "interpol", tb => tb.HasTrigger("trg_panel_delete"));

            entity.Property(e => e.PanelId)
                .HasMaxLength(50)
                .HasColumnName("panel_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PanelTitle)
                .HasMaxLength(50)
                .HasColumnName("panel_title");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.Panels)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__panel__photo_id__0F624AF8");

            entity.HasOne(d => d.User).WithMany(p => p.Panels)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__panel__user_id__0E6E26BF");
        });

        modelBuilder.Entity<Photo>(entity =>
        {
            entity.HasKey(e => e.PhotoId).HasName("PK__photo__CB48C83D400C00E4");

            entity.ToTable("photo", "interpol");

            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.ImageData).HasColumnName("image_data");
            entity.Property(e => e.ImageLink)
                .HasMaxLength(100)
                .HasColumnName("image_link");
            entity.Property(e => e.ImageSource)
                .HasMaxLength(200)
                .HasColumnName("image_source");
        });

        modelBuilder.Entity<Pin>(entity =>
        {
            entity.HasKey(e => e.PinId).HasName("PK__pin__441ED8B1792C6492");

            entity.ToTable("pin", "interpol", tb => tb.HasTrigger("trg_pin_delete"));

            entity.Property(e => e.PinId)
                .HasMaxLength(50)
                .HasColumnName("pin_id");
            entity.Property(e => e.DeviceId)
                .HasMaxLength(50)
                .HasColumnName("device_id");
            entity.Property(e => e.IsAnalog).HasColumnName("is_analog");
            entity.Property(e => e.PinLocation)
                .HasMaxLength(50)
                .HasColumnName("pin_location");

            entity.HasOne(d => d.Device).WithMany(p => p.Pins)
                .HasForeignKey(d => d.DeviceId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__pin__device_id__74AE54BC");
        });

        modelBuilder.Entity<Post>(entity =>
        {
            entity.HasKey(e => e.PostId).HasName("PK__post__3ED78766D613ADAE");

            entity.ToTable("post", "interpol", tb => tb.HasTrigger("trg_post_delete"));

            entity.Property(e => e.PostId)
                .HasMaxLength(50)
                .HasColumnName("post_id");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.PostContent).HasColumnName("post_content");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Photo).WithMany(p => p.Posts)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__post__photo_id__412EB0B6");

            entity.HasOne(d => d.User).WithMany(p => p.Posts)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__post__user_id__403A8C7D");
        });

        modelBuilder.Entity<Prompt>(entity =>
        {
            entity.HasKey(e => e.PromptId).HasName("PK__prompt__511F64D78DBC2870");

            entity.ToTable("prompt", "interpol");

            entity.Property(e => e.PromptId)
                .HasMaxLength(50)
                .HasColumnName("prompt_id");
            entity.Property(e => e.ChatId)
                .HasMaxLength(50)
                .HasColumnName("chat_id");
            entity.Property(e => e.Request).HasColumnName("request");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Chat).WithMany(p => p.Prompts)
                .HasForeignKey(d => d.ChatId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__prompt__chat_id__5BE2A6F2");

            entity.HasOne(d => d.User).WithMany(p => p.Prompts)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__prompt__user_id__5AEE82B9");
        });

        modelBuilder.Entity<Shape>(entity =>
        {
            entity.HasKey(e => e.ShapeId).HasName("PK__shape__B2E98952DB89F89A");

            entity.ToTable("shape", "interpol");

            entity.Property(e => e.ShapeId)
                .HasMaxLength(50)
                .HasColumnName("shape_id");
            entity.Property(e => e.Color)
                .HasMaxLength(50)
                .HasColumnName("color");
            entity.Property(e => e.ColorValue).HasColumnName("color_value");
            entity.Property(e => e.Depth).HasColumnName("depth");
            entity.Property(e => e.GltfId)
                .HasMaxLength(50)
                .HasColumnName("gltf_id");
            entity.Property(e => e.Height).HasColumnName("height");
            entity.Property(e => e.PositionX).HasColumnName("position_x");
            entity.Property(e => e.PositionY).HasColumnName("position_y");
            entity.Property(e => e.PositionZ).HasColumnName("position_z");
            entity.Property(e => e.Radius).HasColumnName("radius");
            entity.Property(e => e.ShapeLength).HasColumnName("shape_length");
            entity.Property(e => e.ShapeName)
                .HasMaxLength(50)
                .HasColumnName("shape_name");
            entity.Property(e => e.Width).HasColumnName("width");

            entity.HasOne(d => d.Gltf).WithMany(p => p.Shapes)
                .HasForeignKey(d => d.GltfId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__shape__gltf_id__1DB06A4F");
        });

        modelBuilder.Entity<UserChatComment>(entity =>
        {
            entity.HasKey(e => e.CommentId).HasName("PK__user_cha__E7957687F2A85A89");

            entity.ToTable("user_chat_comment", "interpol");

            entity.Property(e => e.CommentId)
                .HasMaxLength(50)
                .HasColumnName("comment_id");
            entity.Property(e => e.ChatId)
                .HasMaxLength(50)
                .HasColumnName("chat_id");
            entity.Property(e => e.Content).HasColumnName("content");
            entity.Property(e => e.DateCreated)
                .HasColumnType("datetime")
                .HasColumnName("date_created");
            entity.Property(e => e.PhotoId)
                .HasMaxLength(50)
                .HasColumnName("photo_id");
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .HasColumnName("user_id");

            entity.HasOne(d => d.Chat).WithMany(p => p.UserChatComments)
                .HasForeignKey(d => d.ChatId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__user_chat__chat___6383C8BA");

            entity.HasOne(d => d.Photo).WithMany(p => p.UserChatComments)
                .HasForeignKey(d => d.PhotoId)
                .HasConstraintName("FK__user_chat__photo__6477ECF3");

            entity.HasOne(d => d.User).WithMany(p => p.UserChatComments)
                .HasForeignKey(d => d.UserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__user_chat__user___628FA481");
        });

        modelBuilder.Entity<Video>(entity =>
        {
            entity.HasKey(e => e.VideoId).HasName("PK__video__E8F11E102396A9A3");

            entity.ToTable("video", "interpol");

            entity.Property(e => e.VideoId)
                .HasMaxLength(50)
                .HasColumnName("video_id");
            entity.Property(e => e.FileName)
                .HasMaxLength(100)
                .HasColumnName("file_name");
            entity.Property(e => e.VideoData).HasColumnName("video_data");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
