-- Image Procedures

CREATE PROCEDURE interpol.getPhotos 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT photo_id, image_link, image_source, image_data
        FROM interpol.photo
    END 
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSinglePhoto
    @PhotoId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT photo_id, image_link, image_source, image_data
        FROM interpol.photo
        WHERE photo_id = @PhotoId
    END 
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteImage (
    @PhotoId NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        DELETE FROM interpol.photo
        WHERE photo_id = @PhotoId
    END 
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.importImage (
    @ImageLink NVARCHAR(100), 
    @ImageData NVARCHAR(1000),
    @ImageId NVARCHAR(50) OUTPUT
)
AS
BEGIN
    DECLARE @NewIdentifier NVARCHAR(50) = CONVERT(NVARCHAR(50), NEWID());
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @tsql NVARCHAR (2000);
    SET @Path2OutFile = CONCAT (
        '\', 
        @ImageLink
    );
    SET @tsql = 'insert into interpol.photo (photo_id, image_link, image_source, image_data) ' + 
    ' SELECT ' + '''' + @NewIdentifier + '''' + ',' + '''' + @ImageLink + '''' + ',' + '''' + @ImageData + '''' + ', * ' + 
    'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img' 
    EXEC (@tsql)
    SET @ImageId = @NewIdentifier
END
GO

-- Audio Procedures

CREATE PROCEDURE interpol.exportImage (
   @ImageLink NVARCHAR(100),
   @ImageData NVARCHAR (1000)
)
AS
BEGIN
    DECLARE @ImageInfo VARBINARY (max);
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @Obj INT
    
    SET NOCOUNT ON
 
    SELECT @ImageData = (
        SELECT convert (VARBINARY (max), image_data, 1)
        FROM interpol.photo
        WHERE image_link = @ImageLink
    );
 
   SET @Path2OutFile = CONCAT (
        '\',
        @ImageLink
    );
    BEGIN TRY
        EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
        EXEC sp_OASetProperty @Obj ,'Type',1;
        EXEC sp_OAMethod @Obj,'Open';
        EXEC sp_OAMethod @Obj,'Write', NULL, @ImageInfo;
        EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
        EXEC sp_OAMethod @Obj,'Close';
        EXEC sp_OADestroy @Obj;
    END TRY
    
    BEGIN CATCH
        EXEC sp_OADestroy @Obj;
    END CATCH
 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.importAudio (
    @FileName NVARCHAR(100), 
    @AudioData NVARCHAR(1000)
)
AS
BEGIN
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @tsql NVARCHAR (2000);
    SET NOCOUNT ON
    SET @Path2OutFile = CONCAT (
        @FileName,
        '\', 
        @AudioData
    );
    SET @tsql = 'insert into interpol.audio (file_name, audio_data) ' +
        ' SELECT ' + '''' + @FileName + '''' + ',' + '''' + @AudioData + '''' + ', * ' + 
        'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as FileData'
    EXEC (@tsql)
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.exportAudio (
   @FileName NVARCHAR(100),
   @AudioData VARBINARY(MAX)
)
AS
BEGIN
    DECLARE @ImageInfo VARBINARY (max);
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @Obj INT
    
    SET NOCOUNT ON
 
    SELECT @AudioData = (
        SELECT convert (VARBINARY (max), image_data, 1)
        FROM interpol.photo
        WHERE image_link = @FileName
    );
 
   SET @Path2OutFile = CONCAT (
        @FileName,
        '\', 
        @AudioData
    );
    BEGIN TRY
        EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
        EXEC sp_OASetProperty @Obj ,'Type',1;
        EXEC sp_OAMethod @Obj,'Open';
        EXEC sp_OAMethod @Obj,'Write', NULL, @ImageInfo;
        EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
        EXEC sp_OAMethod @Obj,'Close';
        EXEC sp_OADestroy @Obj;
    END TRY
    
    BEGIN CATCH
        EXEC sp_OADestroy @Obj;
    END CATCH
 
    SET NOCOUNT OFF
END
GO

-- Video Procedures

CREATE PROCEDURE interpol.importVideo (
    @FileName NVARCHAR (100), 
    @VideoData NVARCHAR(1000)
)
AS
BEGIN
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @tsql NVARCHAR (2000);
    SET NOCOUNT ON
    SET @Path2OutFile = CONCAT (
        @FileName,
        '\', 
        @VideoData
    );
    SET @tsql = 'insert into interpol.video (file_name, video_data) ' +
        ' SELECT ' + '''' + @FileName + '''' + ',' + '''' + @VideoData + '''' + ', * ' + 
        'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as FileData'
    EXEC (@tsql)
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.exportVideo (
   @FileName NVARCHAR(100),
   @VideoData VARBINARY(MAX)
)
AS
BEGIN
    DECLARE @ImageInfo VARBINARY (max);
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @Obj INT
    
    SET NOCOUNT ON
 
    SELECT @VideoData = (
        SELECT convert (VARBINARY (max), video_data, 1)
        FROM interpol.video
        WHERE file_name = @FileName
    );
 
   SET @Path2OutFile = CONCAT (
        @FileName,
        '\', 
        @VideoData
    );
    BEGIN TRY
        EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
        EXEC sp_OASetProperty @Obj ,'Type',1;
        EXEC sp_OAMethod @Obj,'Open';
        EXEC sp_OAMethod @Obj,'Write', NULL, @ImageInfo;
        EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
        EXEC sp_OAMethod @Obj,'Close';
        EXEC sp_OADestroy @Obj;
    END TRY
    
    BEGIN CATCH
        EXEC sp_OADestroy @Obj;
    END CATCH
    SET NOCOUNT OFF
END
GO

-- User Procedures

CREATE PROCEDURE interpol.getUsers
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT u.user_id, u.user_name, u.first_name, u.about, u.photo_id, p.image_link, p.image_data
        FROM interpol.interpol_user u 
        LEFT JOIN interpol.photo p ON u.photo_id = p.photo_id
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getSingleUserName
    @pUserName NVARCHAR(254)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT u.user_id, u.user_name, u.first_name, u.about, u.photo_id, p.image_link, p.image_data
        FROM interpol.interpol_user u 
        LEFT JOIN interpol.photo p ON u.photo_id = p.photo_id
        WHERE user_name LIKE  '%' + @pUserName + '%'
    END 
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleUser
    @pUserName NVARCHAR(254) = NULL,
    @pUserId NVARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        IF (@pUserName IS NOT NULL)
            SELECT u.user_id, u.user_name, u.first_name, u.about, u.photo_id, p.image_link, p.image_data
            FROM interpol.interpol_user u 
            LEFT JOIN interpol.photo p ON u.photo_id = p.photo_id
            WHERE user_name LIKE  '%' + @pUserName + '%'
        ELSE
            SELECT u.user_id, u.user_name, u.first_name, u.about, u.photo_id, p.image_link, p.image_data
            FROM interpol.interpol_user u 
            LEFT JOIN interpol.photo p ON u.photo_id = p.photo_id
            WHERE user_id = @pUserId 
    END 
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addUser
    @pUserName NVARCHAR(50), 
    @pFirstName NVARCHAR(40) = NULL, 
    @pLastName NVARCHAR(40) = NULL,
    @pDateOfBirth DATE,
    @pEmailAddress NVARCHAR(100),
    @pPassword NVARCHAR(50), 
    @pAbout NVARCHAR(MAX),
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @ResponseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    DECLARE @dateCreated DATETIME=GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN 
            INSERT INTO interpol.interpol_user (user_name, first_name, last_name, date_of_birth, date_created, email_address, user_password, salt, about)
            VALUES(@pUserName, @pFirstName, @pLastName, @pDateOfBirth, @dateCreated, @pEmailAddress, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pAbout)
            SET @ResponseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            INSERT INTO interpol.interpol_user (user_name, first_name, last_name, date_of_birth, date_created, email_address, user_password, salt, about, photo_id)
            VALUES(@pUserName, @pFirstName, @pLastName, @pDateOfBirth, @dateCreated, @pEmailAddress, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pAbout, @ReturnValue)
            SET @ResponseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @ResponseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.login
    @pUserName NVARCHAR(254),
    @pPassword NVARCHAR(50),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @user_Id UNIQUEIDENTIFIER
    IF EXISTS (SELECT TOP 1 user_id FROM interpol.interpol_user WHERE user_name=@pUserName)
    BEGIN
        SET @user_id=(SELECT user_id FROM interpol.interpol_user WHERE user_name=@pUserName AND user_password=HASHBYTES('SHA2_512', @pPassword+CAST(salt AS NVARCHAR(36))))

       IF(@user_id IS NULL)
           SET @responseMessage='Incorrect password'
       ELSE 
           SET @responseMessage='User successfully logged in'
    END
    ELSE
       SET @responseMessage='Invalid login'
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.updateUser
    @pUserId UNIQUEIDENTIFIER,
    @pUserName NVARCHAR(50), 
    @pFirstName NVARCHAR(40) = NULL, 
    @pLastName NVARCHAR(40) = NULL,
    @pDateOfBirth DATE,
    @pEmailAddress NVARCHAR(100),
    @pPassword NVARCHAR(50), 
    @pAbout NVARCHAR(MAX),
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN
            UPDATE interpol.interpol_user 
            SET user_name = @pUserName, first_name = @pFirstName, last_name = @pLastName, date_of_birth = @pDateOfBirth, email_address = @pEmailAddress, user_password = HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), about = @pAbout, salt = @salt
            WHERE user_id = @pUserId
            SET @responseMessage='Success'
        END
    ELSE 
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            UPDATE interpol.interpol_user 
            SET user_name = @pUserName, first_name = @pFirstName, last_name = @pLastName, date_of_birth = @pDateOfBirth, email_address = @pEmailAddress, user_password = HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), about = @pAbout, photo_id = @ReturnValue, salt = @salt
            WHERE user_id = @pUserId
            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.deleteUser
    @pUserId UNIQUEIDENTIFIER,
    @pPassword NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
    DELETE FROM interpol.interpol_user WHERE user_id = @pUserId AND user_password=HASHBYTES('SHA2_512', @pPassword+CAST(salt AS NVARCHAR(36)))
    END
    SET NOCOUNT OFF
END
GO

-- Post Procedures

CREATE PROCEDURE interpol.getPosts
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT post_id, post_content, date_created, user_id, photo_id
        FROM interpol.post
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getSinglePost
    @pPostId NVARCHAR(254) NULL,
    @pPostContent NVARCHAR(MAX) NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT post_id, post_content, date_created, user_id, photo_id
        FROM interpol.post
        WHERE post_id = @pPostId OR post_content LIKE '%' + @pPostContent + '%'
    END
    SET NOCOUNT OFF 
END
GO

-- 

CREATE PROCEDURE interpol.addPost 
    @pPostContent NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN 
            INSERT INTO interpol.post (post_content, date_created, user_id)
            VALUES(@pPostContent, @pDateCreated, @pUserId)
            SET @responseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            INSERT INTO interpol.post (post_content, date_created, user_id, photo_id)
            VALUES(@pPostContent, @pDateCreated, @pUserId, @ReturnValue)
            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- 

CREATE PROCEDURE interpol.updatePost
    @pPostId UNIQUEIDENTIFIER,
    @pPostContent NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN 
            UPDATE interpol.post 
            SET post_content = @pPostContent, date_created = @pDateCreated, user_id = @pUserId
            WHERE post_id = @pPostId
            SET @responseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            UPDATE interpol.post 
            SET post_content = @pPostContent, date_created = @pDateCreated, user_id = @pUserId, photo_id = @ReturnValue
            WHERE post_id = @pPostId
            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deletePost
    @pPostId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DELETE FROM interpol.post 
        WHERE post_id = @pPostId AND user_id = @pUserId
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- Community Post Procedures

CREATE PROCEDURE interpol.getCommunityPosts
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT post_id, post_content, date_created, community_id, photo_id
        FROM interpol.community_post
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getCommunitySinglePost
    @pPostId NVARCHAR(254) NULL,
    @pPostContent NVARCHAR(MAX) NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT post_id, post_content, date_created, community_id, photo_id
        FROM interpol.community_post
        WHERE post_id = @pPostId OR post_content LIKE '%' + @pPostContent + '%'
    END
    SET NOCOUNT OFF 
END
GO

-- 

CREATE PROCEDURE interpol.addCommunityPost 
    @pPostContent NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN 
            INSERT INTO interpol.community_post (post_content, date_created, community_id)
            VALUES(@pPostContent, @pDateCreated, @pUserId)
            SET @responseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            INSERT INTO interpol.community_post (post_content, date_created, community_id, photo_id)
            VALUES(@pPostContent, @pDateCreated, @pUserId, @ReturnValue)
            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- 

CREATE PROCEDURE interpol.updateCommunityPost
    @pPostId UNIQUEIDENTIFIER,
    @pPostContent NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN 
            UPDATE interpol.community_post 
            SET post_content = @pPostContent, date_created = @pDateCreated, community_id = @pUserId
            WHERE post_id = @pPostId
            SET @responseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            UPDATE interpol.community_post 
            SET post_content = @pPostContent, date_created = @pDateCreated, community_id = @pUserId, photo_id = @ReturnValue
            WHERE post_id = @pPostId
            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteCommunityPost
    @pPostId UNIQUEIDENTIFIER,
    @pCommunityID UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DELETE FROM interpol.community_post 
        WHERE post_id = @pPostId AND community_id = @pCommunityID
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- Artificial Intelligence Procedures

CREATE PROCEDURE interpol.getArtificialIntelligence
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT ai_id, ai_name, ai_role, ai_description, photo_id
        FROM interpol.artificial_intelligence
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getSingleArtificialIntelligence
    @pAiName NVARCHAR(254) NULL,
    @pAiId NVARCHAR(250) NULL,
    @pUserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT ai_id, ai_name, ai_role, ai_description, photo_id
        FROM interpol.artificial_intelligence
        WHERE (ai_name LIKE  '%' + @pAiName + '%' OR ai_id = @pAiId ) AND user_id = @pUserId
    END 
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addArtificialIntelligence
    @pAiName NVARCHAR(50), 
    @pAiRole NVARCHAR(40) = NULL, 
    @pAiDescription NVARCHAR(40) = NULL,
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @DateCreated DATETIME=GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN
            INSERT INTO interpol.artificial_intelligence (ai_name, ai_role, ai_description, date_created, user_id)
            VALUES(@pAiName, @pAiRole, @pAiDescription, @DateCreated, @pUserId)
            SET @responseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            INSERT INTO interpol.artificial_intelligence (ai_name, ai_role, ai_description, date_created, user_id, photo_id)
            VALUES(@pAiName, @pAiRole, @pAiDescription, @DateCreated, @pUserId, @ReturnValue)

            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.updateArtificialIntelligence
    @pAiId UNIQUEIDENTIFIER,
    @pAiName NVARCHAR(50), 
    @pAiRole NVARCHAR(40) = NULL, 
    @pAiDescription NVARCHAR(40) = NULL,
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    DECLARE @DateCreated DATETIME=GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    IF (@ImageLink IS NULL)
        BEGIN
            UPDATE interpol.artificial_intelligence 
            SET ai_name = @pAiName, ai_role = @pAiRole, ai_description = @pAiDescription, date_created = @DateCreated, user_id = @pUserId
            WHERE ai_id = @pAiId
            SET @responseMessage='Success'
        END
    ELSE
        BEGIN TRY
            EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
            UPDATE interpol.artificial_intelligence 
            SET ai_name = @pAiName, ai_role = @pAiRole, ai_description = @pAiDescription, date_created = @DateCreated, user_id = @pUserId, photo_id = @ReturnValue
            WHERE ai_id = @pAiId
            SET @responseMessage='Success'
        END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.deleteArtificialIntelligence
    @pAiId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
    DELETE FROM interpol.artificial_intelligence WHERE ai_id = @pAiId
    END
    SET NOCOUNT OFF
END
GO

-- Channel Procedures

CREATE PROCEDURE interpol.getChannels
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT channel_id, channel_name, date_created, channel_description, community_id
        FROM interpol.channel
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getSingleChannel
    @pChannelId NVARCHAR(254) NULL,
    @pChannelName NVARCHAR(100) NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT channel_id, channel_name, date_created, channel_description, community_id 
        FROM interpol.channel
        WHERE channel_id = @pChannelId OR channel_name LIKE '%' + @pChannelName + '%'
    END
    SET NOCOUNT OFF 
END
GO

-- 

CREATE PROCEDURE interpol.addChannel 
    @pChannelName NVARCHAR(100),
    @pChannelDescription NVARCHAR(MAX) NULL,
    @pCommunityId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    BEGIN TRY
        INSERT INTO interpol.channel (channel_name, date_created, channel_description, community_id)
        VALUES(@pChannelName, @pDateCreated, @pChannelDescription, @pCommunityId)
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- 

CREATE PROCEDURE interpol.updateChannel
    @pChannelId UNIQUEIDENTIFIER,
    @pChannelDescription NVARCHAR(MAX),
    @pChannelName NVARCHAR(100),
    @pCommunityId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    BEGIN TRY
        UPDATE interpol.channel 
        SET channel_name = @pChannelName, channel_description = @pChannelDescription, date_created = @pDateCreated, community_id = @pCommunityId
        WHERE channel_id = @pChannelId
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteChannel
    @pChannelId UNIQUEIDENTIFIER,
    @pCommunityId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DELETE FROM interpol.channel 
        WHERE channel_id = @pChannelId AND community_id = @pCommunityId
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- Action Procedures

CREATE PROCEDURE interpol.getActions
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT action_id, action_name, action_description, date_created, pin_id
        FROM interpol.action_table
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getSingleAction
    @pActionId NVARCHAR(254) NULL,
    @pActionName NVARCHAR(100) NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT action_id, action_name, action_description, date_created, pin_id 
        FROM interpol.action_table
        WHERE action_id = @pActionId OR action_name LIKE '%' + @pActionName + '%'
    END
    SET NOCOUNT OFF 
END
GO

-- 

CREATE PROCEDURE interpol.addAction
    @pActionName NVARCHAR(100),
    @pActionDescription NVARCHAR(MAX) NULL,
    @pPinId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    BEGIN TRY
        INSERT INTO interpol.action_table (action_name, action_description, date_created, pin_id)
        VALUES(@pActionName, @pActionDescription, @pDateCreated, @pPinId)
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- 

CREATE PROCEDURE interpol.updateAction
    @pActionId UNIQUEIDENTIFIER,
    @pActionName NVARCHAR(100),
    @pActionDescription NVARCHAR(MAX),
    @pPinId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    BEGIN TRY
        UPDATE interpol.action_table 
        SET action_name = @pActionName, action_description = @pActionDescription, date_created = @pDateCreated, pin_id = @pPinId
        WHERE action_id = @pActionId
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteAction
    @pActionId UNIQUEIDENTIFIER,
    @pPinId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DELETE FROM interpol.action_table 
        WHERE action_id = @pActionId AND pin_id = @pPinId
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

-- Chat Procedures

CREATE PROCEDURE interpol.getChats
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
    SELECT chat_id, chat_title, date_created, ai_id
    FROM interpol.chat
    END
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getUserChats
    @pUserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
    SELECT chat_id, chat_title, date_created, ai_id
    FROM interpol.chat
    WHERE user_id = @pUserId
    END
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addChat
    @pChatTitle NVARCHAR(100),
    @pAiId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @DateCreated DATETIME = GETDATE()
    BEGIN TRY
        INSERT INTO interpol.chat (chat_title, date_created, ai_id, user_id)
        VALUES (@pChatTitle, @DateCreated, @pAiId, @pUserId)
        SET @responseMessage = 'Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateChat
    @pChatId UNIQUEIDENTIFIER,
    @pChatTitle NVARCHAR(100),
    @pAiId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @DateCreated DATETIME = GETDATE()
    BEGIN TRY
        UPDATE interpol.chat 
        SET chat_title = @pChatTitle, date_created = @DateCreated, ai_id = @pAiId, user_id = @pUserId
        WHERE chat_id = @pChatId
        SET @responseMessage = 'Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteChat
    @pChatId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DELETE FROM interpol.chat
        WHERE chat_id = @pChatId AND user_id = @pUserId
    END TRY
    BEGIN CATCH
        SET @responseMessage = ERROR_MESSAGE()
    END CATCH
    SET NOCOUNT OFF
END
GO

-- Community Procedures

CREATE PROCEDURE interpol.getCommunities
    @pResponseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SELECT community_id, community_name, community_description, date_created, user_id
        FROM interpol.community
        SET @pResponseMessage = 'Success'
    END TRY
    BEGIN CATCH
        SET @pResponseMessage = ERROR_MESSAGE()
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleCommunity
    @pCommunityId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SELECT community_id, community_name, community_description, date_created, user_id
        FROM interpol.community
        WHERE community_id = @pCommunityId
        SET @pResponseMessage = 'Success'
    END TRY
    BEGIN CATCH
        SET @pResponseMessage = ERROR_MESSAGE()
    END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addCommunity
    @pCommunityName NVARCHAR(100),
    @pCommunityDescription NVARCHAR(MAX) = NULL,
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @DateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId UNIQUEIDENTIFIER 
        DECLARE @ReturnValue NVARCHAR(50)
        IF (@ImageLink IS NULL)
            BEGIN
                INSERT INTO interpol.community (community_name, community_description, date_created, user_id)
                VALUES (@pCommunityName, @pCommunityDescription, @DateCreated, @pUserId)
                SET @pResponseMessage = 'Success'
            END
        ELSE
            BEGIN TRY
                EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
                INSERT INTO interpol.community (community_name, community_description, date_created, user_id, photo_id)
                VALUES (@pCommunityName, @pCommunityDescription, @DateCreated, @pUserId, @pPhotoId)
                SET @pResponseMessage = 'Success'
            END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateCommunity
    @pCommunityId UNIQUEIDENTIFIER,
    @pCommunityName NVARCHAR(100),
    @pCommunityDescription NVARCHAR(MAX) = NULL,
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @DateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId UNIQUEIDENTIFIER 
        DECLARE @ReturnValue NVARCHAR(50)
        BEGIN TRY
            IF @ImageLink IS NULL OR @ImageLink = ''
                BEGIN
                    UPDATE interpol.community 
                    SET community_name = @pCommunityName, community_description = @pCommunityDescription, date_created = @DateCreated, user_id = @pUserId
                    WHERE community_id = @pCommunityId
                    SET @pResponseMessage = 'Success'
                END
            ELSE
                BEGIN
                    EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
                    UPDATE interpol.community
                    SET community_name = @pCommunityName, community_description = @pCommunityDescription, date_created = @DateCreated, user_id = @pUserId, photo_id = @pPhotoId
                    WHERE community_id = @pCommunityId
                    SET @pResponseMessage = 'Success'
                END
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteCommunity
    @pCommunityId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.community 
            WHERE community_id = @pCommunityId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Device Procedure

CREATE PROCEDURE interpol.getDevices
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT device_id, device_name, device_description, date_created
            FROM interpol.device
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleDevice
    @pUserId UNIQUEIDENTIFIER,
    @pDeviceId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT device_id, device_name, device_description, date_created
            FROM interpol.device
            WHERE user_id = @pUserId AND device_id = @pDeviceId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addDevice
    @pDeviceName NVARCHAR(100),
    @pDeviceDescription NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            INSERT INTO interpol.device (device_name, device_description, date_created, user_id)
            VALUES (@pDeviceName, @pDeviceDescription, @pDateCreated, @pUserId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateDevice
    @pDeviceId UNIQUEIDENTIFIER,
    @pDeviceName NVARCHAR(100),
    @pDeviceDescription NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            UPDATE interpol.device 
            SET device_name = @pDeviceName, device_description = @pDeviceDescription, date_created = @pDateCreated, user_id = @pUserId
            WHERE device_id = @pDeviceId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteDevice
    @pDeviceId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.device
            WHERE device_id = @pDeviceId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- DocFile Procedure

CREATE PROCEDURE interpol.getDocfiles
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT doc_file_id, title, date_created, user_id
            FROM interpol.doc_file
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getUserDocfiles
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT doc_file_id, title, date_created, user_id
            FROM interpol.doc_file
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleDocfile
    @pDocFileId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT doc_file_id, title, date_created, user_id
            FROM interpol.doc_file
            WHERE doc_file_id = @pDocFileId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addDocfile
    @pTitle NVARCHAR(100),
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            INSERT INTO interpol.doc_file (title, date_created, user_id)
            VALUES (@pTitle, @pDateCreated, @pUserId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateDocfile
    @pDocFileId UNIQUEIDENTIFIER,
    @pTitle NVARCHAR(100),
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            UPDATE interpol.doc_file 
            SET title = @pTitle, date_created = @pDateCreated, user_id = @pUserId
            WHERE doc_file_id = @pDocFileId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteDocfile
    @pDocFileId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.doc_file
            WHERE doc_file_id = @pDocFileId AND user_id = @pUserId 
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Favorite Procedure

CREATE PROCEDURE interpol.getFavorites
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT favorite_id, content_type, content_id, date_created, user_id
            FROM interpol.favorite
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getUserFavorites
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT favorite_id, content_type, content_id, date_created, user_id
            FROM interpol.favorite
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleFavorite
    @pFavoriteId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT favorite_id, content_type, content_id, date_created, user_id
            FROM interpol.favorite
            WHERE favorite_id = @pFavoriteId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addFavorite
    @pContentType NCHAR(10),
    @pContentId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            INSERT INTO interpol.favorite (content_type, content_id, date_created, user_id)
            VALUES (@pContentType, @pContentId, @pDateCreated, @pUserId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteFavorite
    @pFavoriteId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.favorite
            WHERE favorite_id = @pFavoriteId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Follower Procedure

CREATE PROCEDURE interpol.getFollowers
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY   
            SELECT follower_id
            FROM interpol.follower
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleFollower
    @pFollowerId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT follower_id
            FROM interpol.follower
            WHERE follower_id = @pFollowerId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addFollower
    @pUserId UNIQUEIDENTIFIER,
    @pFollowerId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.follower (user_id, follower_id)
            VALUES (@pUserId, @pFollowerId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteFollower
    @pUserId UNIQUEIDENTIFIER,
    @pFollowerId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.follower
            WHERE user_id = @pUserId AND follower_id = @pFollowerId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Gltf Procedure

CREATE PROCEDURE interpol.getGltfs
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        SELECT gltf_id, file_name, file_type, user_id, date_created
        FROM interpol.gltf
        BEGIN TRY
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getUserGltfs
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT gltf_id, file_name, file_type, user_id, date_created
            FROM interpol.gltf
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleGltf
    @pGltfId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT gltf_id, file_name, file_type, user_id, date_created
            FROM interpol.gltf
            WHERE gltf_id = @pGltfId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addGltf
    @pFileName NVARCHAR(50),
    @pFileType CHAR(10),
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            INSERT INTO interpol.gltf (file_name, file_type, user_id, date_created)
            VALUES (@pFileName, @pFileType, @pUserId, @pDateCreated)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateGltf
    @pGltfId UNIQUEIDENTIFIER,
    @pFileName NVARCHAR(50),
    @pFileType CHAR(10),
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            UPDATE interpol.gltf
            SET file_name = @pFileName, file_type = @pFileType, user_id = @pUserId, date_created = @pDateCreated
            WHERE gltf_id = @pGltfId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteGltf
    @pGltfId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.gltf
            WHERE gltf_id = @pGltfId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Member Procedure

CREATE PROCEDURE interpol.getMembers
    @pCommunityId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT member_id, user_id, community_id
            FROM interpol.member
            WHERE community_id = @pCommunityId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleMember
    @pMemberId UNIQUEIDENTIFIER,
    @pCommunityId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT member_id, user_id, community_id
            FROM interpol.member
            WHERE member_id = @pMemberId AND community_id = @pCommunityId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addMember
    @pUserId UNIQUEIDENTIFIER,
    @pCommunityId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.member (user_id, community_id)
            VALUES (@pUserId, @pCommunityId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteMember
    @pMemberId UNIQUEIDENTIFIER,
    @pCommunityId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.member
            WHERE member_id = @pMemberId AND community_id = @pCommunityId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Message Procedure

CREATE PROCEDURE interpol.getMessages
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT message_id, message_title, user_id, follower_id
            FROM interpol.message_table
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleMessage
    @pUserId UNIQUEIDENTIFIER,
    @pMessageId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT message_id, message_title, user_id, follower_id
            FROM interpol.message_table
            WHERE user_id = @pUserId AND message_id = @pMessageId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addMessage
    @pMessageTitle NVARCHAR(50),
    @pUserId UNIQUEIDENTIFIER,
    @pFollowerId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.message_table (message_title, user_id, follower_id)
            VALUES (@pMessageTitle, @pUserId, @pFollowerId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteMessage
    @pMessageId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pFollowerId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.message_table
            WHERE message_id = @pMessageId AND user_id = @pUserId AND follower_id = @pFollowerId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Moveable Procedure

CREATE PROCEDURE interpol.getMoveables
    @pDocFileId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT moveable_id, position_x, position_y, position_z, doc_file_id
            FROM interpol.moveable
            WHERE doc_file_id = @pDocFileId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleMoveable
    @pMoveableId UNIQUEIDENTIFIER,
    @pDocFileId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT moveable_id, position_x, position_y, position_z, doc_file_id
            FROM interpol.moveable
            WHERE moveable_id = @pMoveableId AND doc_file_id = @pDocFileId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addMoveable
    @pPositionX TINYINT,
    @pPositionY TINYINT,
    @pPositionZ TINYINT,
    @pDocFileId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.moveable (position_x, position_y, position_z, doc_file_id)
            VALUES (@pPositionX, @pPositionY, @pPositionZ, @pDocFileId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateMoveable
    @pMoveableId UNIQUEIDENTIFIER,
    @pPositionX TINYINT,
    @pPositionY TINYINT,
    @pPositionZ TINYINT,
    @pDocFileId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            UPDATE interpol.moveable
            SET moveable_id = @pMoveableId, position_x = @pPositionX, position_y = @pPositionY, position_z = @pPositionZ, doc_file_id = @pDocFileId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteMoveable
    @pMoveableId UNIQUEIDENTIFIER,
    @pDocFileId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.moveable
            WHERE moveable_id = @pMoveableId AND doc_file_id = @pDocFileId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Panel Procedure

CREATE PROCEDURE interpol.getUserPanels
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT panel_id, panel_title, date_created, user_id, photo_id
            FROM interpol.panel
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSinglePanel
    @pPanelId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT panel_id, panel_title, date_created, user_id, photo_id
            FROM interpol.panel
            WHERE panel_id = @pPanelId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addPanel
    @pPanelTitle NVARCHAR(50),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId UNIQUEIDENTIFIER
        DECLARE @ReturnValue NVARCHAR(50)
        BEGIN TRY
            IF @ImageLink IS NULL OR @ImageLink = ''
                BEGIN
                    INSERT INTO interpol.panel (panel_title, date_created, user_id)
                    VALUES (@pPanelTitle, @pDateCreated, @pUserId)
                    SET @pResponseMessage = 'Success'
                END
            ELSE 
                BEGIN
                    EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
                    INSERT INTO interpol.panel (panel_title, date_created, user_id, photo_id)
                    VALUES (@pPanelTitle, @pDateCreated, @pUserId, @pPhotoId)
                    SET @pResponseMessage = 'Success'
                END
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updatePanel
    @pPanelId UNIQUEIDENTIFIER,
    @pPanelTitle NVARCHAR(50),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId UNIQUEIDENTIFIER 
        DECLARE @ReturnValue NVARCHAR(50)
        IF (@ImageLink IS NULL)
            BEGIN
                UPDATE interpol.panel
                SET panel_title = @pPanelTitle, date_created = @pDateCreated, user_id = @pUserId
                WHERE panel_id = @pPanelId
                SET @pResponseMessage = 'Success'
            END 
        ELSE
            BEGIN TRY
                EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
                UPDATE interpol.panel
                SET panel_title = @pPanelTitle, date_created = @pDateCreated, user_id = @pUserId, photo_id = @pPhotoId
                SET @pResponseMessage = 'Success'
            END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deletePanel
    @pPanelId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.panel
            WHERE panel_id = @pPanelId AND user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Note Procedure

CREATE PROCEDURE interpol.getNotes
    @pPanelId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT note_id, note_title, panel_id, photo_id
            FROM interpol.note
            WHERE panel_id = @pPanelId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleNote
    @pPanelId UNIQUEIDENTIFIER,
    @pNoteId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT note_id, note_title, panel_id, photo_id
            FROM interpol.note
            WHERE panel_id = @pPanelId AND note_id = @pNoteId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addNote
    @pNoteTitle NVARCHAR(50),
    @pPanelId NVARCHAR(50),
    @pUserId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pPhotoId UNIQUEIDENTIFIER
        DECLARE @ReturnValue NVARCHAR(50)
        IF (@ImageLink IS NULL)
            BEGIN
                INSERT INTO interpol.note (note_title, panel_id)
                VALUES (@pNoteTitle, @pPanelId)
                SET @pResponseMessage = 'Success'
            END
        ELSE
            BEGIN TRY
                EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
                INSERT INTO interpol.note (note_title, panel_id, photo_id)
                VALUES (@pNoteTitle, @pPanelId, @ReturnValue)
                SET @pResponseMessage = 'Success'
            END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateNote
    @pNoteId UNIQUEIDENTIFIER,
    @pNoteTitle NVARCHAR(50),   
    @pPanelId UNIQUEIDENTIFIER,
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pPhotoId UNIQUEIDENTIFIER
        DECLARE @ReturnValue NVARCHAR(50)
        BEGIN TRY
            IF @ImageLink IS NULL OR @ImageLink = ''
                BEGIN
                    UPDATE interpol.note 
                    SET note_title = @pNoteTitle, panel_id = @pPanelId
                    WHERE note_id = @pNoteId
                    SET @pResponseMessage = 'Success'
                END
            ELSE
                BEGIN
                    EXEC interpol.importImage @ImageLink, @ImageData, @ImageId = @ReturnValue OUTPUT
                    UPDATE interpol.note 
                    SET note_title = @pNoteTitle, panel_id = @pPanelId
                    WHERE note_id = @pNoteId
                    SET @pResponseMessage = 'Success'
                END
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteNote
    @pNoteId UNIQUEIDENTIFIER,
    @pPanelId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.note
            WHERE note_id = @pNoteId AND panel_id = @pPanelId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Pin Procedure

CREATE PROCEDURE interpol.getPins
    @pDeviceId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT pin_id, pin_location, is_analog, device_id
            FROM interpol.pin
            WHERE device_id = @pDeviceId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSinglePin
    @pPinId UNIQUEIDENTIFIER,
    @pDeviceId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT pin_id, pin_location, is_analog, device_id
            FROM interpol.pin
            WHERE device_id = @pDeviceId AND pin_id = @pPinId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addPin
    @pPinLocation NVARCHAR(50),
    @pIsAnalog BIT,
    @pDeviceId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.pin (pin_location, is_analog, device_id)
            VALUES (@pPinLocation, @pIsAnalog, @pDeviceId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updatePin
    @pPinId UNIQUEIDENTIFIER,
    @pPinLocation NVARCHAR(50),
    @pIsAnalog BIT,
    @pDeviceId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            UPDATE interpol.pin 
            SET pin_location = @pPinLocation, is_analog = @pIsAnalog, device_id = @pDeviceId
            WHERE pin_id = @pPinId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deletePin
    @pPinId UNIQUEIDENTIFIER,
    @pDeviceId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.pin
            WHERE pin_id = @pPinId AND device_id = @pDeviceId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Prompt Procedure 

CREATE PROCEDURE interpol.getPrompts
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        SELECT prompt_id, request, user_id, chat_id
        FROM interpol.prompt
        BEGIN TRY
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getUserPrompts
    @pUserId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT prompt_id, request, user_id, chat_id
            FROM interpol.prompt
            WHERE user_id = @pUserId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getChatPrompts
    @pChatId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT prompt_id, request, user_id, chat_id
            FROM interpol.prompt
            WHERE chat_id = @pChatId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addPrompt
    @pRequest NVARCHAR(MAX),
    @pUserId UNIQUEIDENTIFIER,
    @pChatId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.prompt (request, user_id, chat_id)
            VALUES (@pRequest, @pUserId, @pChatId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deletePrompt
    @pPromptId UNIQUEIDENTIFIER,
    @pUserId UNIQUEIDENTIFIER,
    @pChatId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.prompt
            WHERE prompt_id = @pPromptId AND user_id = @pUserId AND chat_id = @pChatId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Shape Procedure

CREATE PROCEDURE interpol.getShapes
    @pGltfId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT shape_id, shape_name, position_x, position_y, position_z, height, width, depth, radius, shape_length, color, color_value, gltf_id
            FROM interpol.shape
            WHERE gltf_id = @pGltfId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.getSingleShape
    @pShapeId UNIQUEIDENTIFIER,
    @pGltfId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            SELECT shape_id, shape_name, position_x, position_y, position_z, height, width, depth, radius, shape_length, color, color_value, gltf_id
            FROM interpol.shape
            WHERE gltf_id = @pGltfId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.addShape
    @pShapeName NVARCHAR(50),
    @pPositionX TINYINT,
    @pPositionY TINYINT,
    @pPositionZ TINYINT,
    @pHeight TINYINT,
    @pWidth TINYINT,
    @pDepth TINYINT,
    @pRadius TINYINT,
    @pShapeLength TINYINT,
    @pColor NVARCHAR(50),
    @pColorValue TINYINT,
    @pGltfId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            INSERT INTO interpol.shape (shape_name, position_x, position_y, position_z, height, width, depth, radius, shape_length, color, color_value, gltf_id)
            VALUES (@pShapeName, @pPositionX, @pPositionY, @pPositionZ, @pHeight, @pWidth, @pDepth, @pRadius, @pShapeLength, @pColor, @pColorValue, @pGltfId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateShape
    @pShapeId UNIQUEIDENTIFIER,
    @pShapeName NVARCHAR(50),
    @pPositionX TINYINT,
    @pPositionY TINYINT,
    @pPositionZ TINYINT,
    @pHeight TINYINT,
    @pWidth TINYINT,
    @pDepth TINYINT,
    @pRadius TINYINT,
    @pShapeLength TINYINT,
    @pColor NVARCHAR(50),
    @pColorValue TINYINT,
    @pGltfId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            UPDATE interpol.shape 
            SET shape_name = @pShapeName, position_x = @pPositionX, position_y = @pPositionY, position_z = @pPositionZ, height = @pHeight, width = @pWidth, depth = @pDepth, radius = @pRadius, shape_length = @pShapeLength, color = @pColor, color_value = @pColorValue, gltf_id = @pGltfId
            WHERE shape_id = @pShapeId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.deleteShape
    @pShapeId UNIQUEIDENTIFIER,
    @pGltfId UNIQUEIDENTIFIER,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            DELETE FROM interpol.shape
            WHERE shape_id = @pShapeId AND gltf_id = @pGltfId
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

-- Gather all procedures to be deleted

-- SELECT 'DROP PROCEDURE [' + SCHEMA_NAME(p.schema_id) + '].[' + p.NAME + '];'
-- FROM sys.procedures p 