create schema interpol;
go

create table interpol.photo (
    photo_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    image_link NVARCHAR(100) NOT NULL,
    image_source NVARCHAR(200) NOT NULL,
    image_data VARBINARY(MAX) NOT NULL
);

create table interpol.audio (
    audio_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    file_name NVARCHAR(100) NULL,
    audio_data VARBINARY(MAX) NULL
);

create table interpol.video (
    video_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    file_name NVARCHAR(100) NULL,
    video_data VARBINARY(MAX) NULL
);

create table interpol.interpol_user (
    user_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    user_name NVARCHAR(50) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    date_created DATETIME NOT NULL,
    email_address NVARCHAR(320) NOT NULL,
    user_password BINARY(64) NOT NULL,
    salt UNIQUEIDENTIFIER,
    about NVARCHAR(320) NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.post (
    post_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    post_content NVARCHAR(MAX),
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.community (
    community_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    community_name NVARCHAR(50) NOT NULL,
    community_description NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.member (
    member_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    user_id uniqueidentifier NOT NULL,
    community_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (community_id) REFERENCES interpol.community (community_id)
);

create table interpol.community_post (
    post_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    post_content NVARCHAR(MAX),
    date_created DATETIME NOT NULL,
    community_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (community_id) REFERENCES interpol.community (community_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.community_comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    post_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    date_created DATETIME NOT NULL,
    FOREIGN KEY (post_id) REFERENCES interpol.community_post (post_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);
create table interpol.artificial_intelligence (
    ai_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    ai_name NVARCHAR(50) NOT NULL,
    ai_role NVARCHAR(50),
    ai_description NVARCHAR(MAX),
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.chat (
    chat_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    chat_title NVARCHAR(50) NOT NULL,
    date_created DATETIME NOT NULL,
    ai_id uniqueidentifier NOT NULL,
    user_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (ai_id) REFERENCES interpol.artificial_intelligence (ai_id)
);

create table interpol.prompt (
    prompt_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    request NVARCHAR(MAX) NOT NULL,
    user_id uniqueidentifier NOT NULL,
    chat_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (chat_id) REFERENCES interpol.chat (chat_id)
);

create table interpol.chat_comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    chat_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (chat_Id) REFERENCES interpol.chat (chat_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.user_chat_comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    chat_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    user_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (chat_Id) REFERENCES interpol.chat (chat_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    post_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (post_Id) REFERENCES interpol.post (post_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.channel (
    channel_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    channel_name NVARCHAR(50) NOT NULL,
    date_created DATETIME NOT NULL,
    channel_description NVARCHAR(MAX),
    community_id uniqueidentifier NOT NULL,
    FOREIGN KEY (community_id) REFERENCES interpol.community (community_id)
);

create table interpol.channel_comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    channel_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (channel_id) REFERENCES interpol.channel (channel_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.device (
    device_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    device_name NVARCHAR(50) NOT NULL,
    device_description NVARCHAR(MAX),
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id)
);


create table interpol.pin (
    pin_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    pin_location NVARCHAR(50) NOT NULL,
    is_analog BIT,
    device_id uniqueidentifier NOT NULL,
    FOREIGN KEY (device_id) REFERENCES interpol.device (device_id)
);

create table interpol.action_table (
    action_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    action_name NVARCHAR(50) NOT NULL,
    action_description NVARCHAR(MAX),
    date_created DATETIME NOT NULL,
    pin_id uniqueidentifier NOT NULL,
    FOREIGN KEY (pin_id) REFERENCES interpol.pin (pin_id)
);

create table interpol.doc_file (
    doc_file_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    title NVARCHAR(50) NOT NULL,
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id)
);

create table interpol.moveable (
    moveable_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    position_x TINYINT NOT NULL,
    position_y TINYINT NOT NULL,
    position_z TINYINT NOT NULL,
    doc_file_id uniqueidentifier NOT NULL,
    FOREIGN KEY (doc_file_id) REFERENCES interpol.doc_file (doc_file_id) 
);

create table interpol.favorite (
    favorite_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content_type NCHAR(10) NOT NULL,
    content_id uniqueidentifier NOT NULL,
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id)
);

create table interpol.follower (
    user_id uniqueidentifier NOT NULL,
    follower_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (follower_id) REFERENCES interpol.interpol_user (user_id)
);

create table interpol.message_table (
    message_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    message_title NVARCHAR(50) NOT NULL,
    user_id uniqueidentifier NOT NULL,
    follower_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (follower_id) REFERENCES interpol.interpol_user (user_id)
);

create table interpol.message_comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    message_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (message_id) REFERENCES interpol.message_table (message_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.panel (
    panel_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    panel_title NVARCHAR(50) NOT NULL,
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.note (
    note_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    note_title NVARCHAR(50) NOT NULL,
    panel_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (panel_id) REFERENCES interpol.panel (panel_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.gltf (
    gltf_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    file_name NVARCHAR(50) NOT NULL,
    file_type CHAR(10) NOT NULL,
    date_created DATETIME,
    user_id uniqueidentifier NOT NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id)
);

create table interpol.gltf_comment (
    comment_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    content NVARCHAR(MAX) NOT NULL,
    date_created DATETIME NOT NULL,
    user_id uniqueidentifier NOT NULL,
    gltf_id uniqueidentifier NOT NULL,
    photo_id uniqueidentifier NULL,
    FOREIGN KEY (user_id) REFERENCES interpol.interpol_user (user_id),
    FOREIGN KEY (gltf_id) REFERENCES interpol.gltf (gltf_id),
    FOREIGN KEY (photo_id) REFERENCES interpol.photo (photo_id)
);

create table interpol.shape (
    shape_id uniqueidentifier PRIMARY KEY NOT NULL DEFAULT newid(),
    shape_name NVARCHAR(50) NOT NULL,
    position_x TINYINT NOT NULL,
    position_y TINYINT NOT NULL,
    position_z TINYINT NOT NULL,
    height TINYINT NOT NULL,
    width TINYINT NOT NULL,
    depth TINYINT NOT NULL,
    radius TINYINT NOT NULL,
    shape_length TINYINT NOT NULL,
    color NVARCHAR(50) NOT NULL,
    color_value TINYINT NOT NULL,
    gltf_id uniqueidentifier NOT NULL,
    FOREIGN KEY (gltf_id) REFERENCES interpol.gltf (gltf_id)
);

-- Remove all tables
-- DECLARE @Sql NVARCHAR(500) DECLARE @Cursor CURSOR

-- SET @Cursor = CURSOR FAST_FORWARD FOR
-- SELECT DISTINCT sql = 'ALTER TABLE [' + tc2.TABLE_SCHEMA + '].[' +  tc2.TABLE_NAME + '] DROP [' + rc1.CONSTRAINT_NAME + '];'
-- FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc1
-- LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc2 ON tc2.CONSTRAINT_NAME =rc1.CONSTRAINT_NAME

-- OPEN @Cursor FETCH NEXT FROM @Cursor INTO @Sql

-- WHILE (@@FETCH_STATUS = 0)
-- BEGIN
-- Exec sp_executesql @Sql
-- FETCH NEXT FROM @Cursor INTO @Sql
-- END

-- CLOSE @Cursor DEALLOCATE @Cursor
-- GO

-- EXEC sp_MSforeachtable 'DROP TABLE ?'
-- GO

-- ALTER TABLE table_name
-- ALTER COLUMN column_name datatype;