-- USE interpol
-- Go
-- EXEC sp_configure 'show advanced options', 1; 
-- GO 
-- RECONFIGURE; 
-- GO 
-- EXEC sp_configure 'Ole Automation Procedures', 1; 
-- GO 
-- RECONFIGURE; 
-- GO
-- ALTER SERVER ROLE [bulkadmin] ADD MEMBER [sa] 
-- GO  

-- Image Procedures

CREATE PROCEDURE interpol.usp_ImportImage (
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000)
)
AS
BEGIN
    DECLARE @Path2OutFile NVARCHAR (2000);
    DECLARE @tsql NVARCHAR (2000);
    SET NOCOUNT ON
    SET @Path2OutFile = CONCAT (
        @ImageLink,
        '\', 
        @ImageSource
    );
    SET @tsql = 'insert into interpol.photo (image_link, image_source, image_data) ' +
        ' SELECT ' + '''' + @ImageLink + '''' + ',' + '''' + @ImageSource + '''' + ', * ' + 
        'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img' +
        'OUTPUT Inserted.ID'
    EXEC (@tsql)
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.usp_ExportImage (
   @ImageLink NVARCHAR(100),
   @ImageSource NVARCHAR(1000),
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
        @ImageLink,
        '\', 
        @ImageSource
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

-- Audio Procedures

CREATE PROCEDURE interpol.usp_ImportAudio (
    @FileName NVARCHAR(100), 
    @AudioData VARBINARY(MAX)
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

CREATE PROCEDURE interpol.usp_ExportAudio (
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

CREATE PROCEDURE interpol.usp_ImportVideo (
    @FileName NVARCHAR (100), 
    @VideoData VARBINARY(MAX)
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

CREATE PROCEDURE interpol.usp_ExportVideo (
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
        SELECT user_id, user_name, first_name, about, photo_id
        FROM interpol.interpol_user
    END 
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.getSingleUser
    @pUserName NVARCHAR(254) NULL,
    @pUserId NVARCHAR(250) NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN
        SELECT user_id, user_name, first_name, about, photo_id
        FROM interpol.interpol_user
        WHERE user_name LIKE  '%' + @pUserName + '%' OR user_id = @pUserId 
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
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    DECLARE @dateCreated DATETIME=GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
        INSERT INTO interpol.interpol_user (user_name, first_name, last_name, date_of_birth, date_created, email_address, user_password, about, photo_id, salt)
        VALUES(@pUserName, @pFirstName, @pLastName, @pDateOfBirth, @pEmailAddress, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @pAbout, @ReturnValue, @salt)

        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
    SET NOCOUNT OFF
END
GO

--

CREATE PROCEDURE interpol.login
    @pUserName NVARCHAR(254),
    @pPassword NVARCHAR(50),
    @responseMessage NVARCHAR(250)='' OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @user_id NVARCHAR(50)
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
    @pUserId NVARCHAR(50) NOT NULL,
    @pUserName NVARCHAR(50), 
    @pFirstName NVARCHAR(40) = NULL, 
    @pLastName NVARCHAR(40) = NULL,
    @pDateOfBirth DATE,
    @pEmailAddress NVARCHAR(100),
    @pPassword NVARCHAR(50), 
    @pAbout NVARCHAR(MAX),
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pUserId NVARCHAR(50),
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
    @pPostContent NVARCHAR(MAX) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pPostId NVARCHAR(50) NOT NULL,
    @pPostContent NVARCHAR(MAX) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pPostId NVARCHAR(50) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
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
    @pPostContent NVARCHAR(MAX) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pPostId NVARCHAR(50) NOT NULL,
    @pPostContent NVARCHAR(MAX) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @pDateCreated DATETIME = GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pPostId NVARCHAR(50) NOT NULL,
    @pCommunityID NVARCHAR(50) NOT NULL,
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
    @pUserId NVARCHAR(50) NOT NULL
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
    @pUserId NVARCHAR(50) NOT NULL,
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @DateCreated DATETIME=GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pAiId NVARCHAR(50) NOT NULL,
    @pAiName NVARCHAR(50), 
    @pAiRole NVARCHAR(40) = NULL, 
    @pAiDescription NVARCHAR(40) = NULL,
    @pUserId NVARCHAR(50) NOT NULL,
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    DECLARE @DateCreated DATETIME=GETDATE()
    DECLARE @ReturnValue NVARCHAR(50)
    BEGIN TRY
        EXEC @ReturnValue = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pAiId NVARCHAR(50)
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
    @pChannelName NVARCHAR(100) NOT NULL,
    @pChannelDescription NVARCHAR(MAX) NULL,
    @pCommunityId NVARCHAR(50) NOT NULL,
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
    @pChannelId NVARCHAR(50) NOT NULL,
    @pChannelDescription NVARCHAR(MAX),
    @pChannelName NVARCHAR(100) NOT NULL,
    @pCommunityId NVARCHAR(50) NOT NULL,
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
    @pChannelId NVARCHAR(50) NOT NULL,
    @pCommunityId NVARCHAR(50) NOT NULL,
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
    @pActionName NVARCHAR(100) NOT NULL,
    @pActionDescription NVARCHAR(MAX) NULL,
    @pPinId NVARCHAR(50) NOT NULL,
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
    @pActionId NVARCHAR(50) NOT NULL,
    @pActionName NVARCHAR(100) NOT NULL,
    @pActionDescription NVARCHAR(MAX),
    @pPinId NVARCHAR(50) NOT NULL,
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
    @pActionId NVARCHAR(50) NOT NULL,
    @pPinId NVARCHAR(50) NOT NULL,
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
    @pUserId NVARCHAR(50) NOT NULL
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
    @pAiId NVARCHAR(50) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
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
    @pChatId NVARCHAR(50) NOT NULL,
    @pChatTitle NVARCHAR(100),
    @pAiId NVARCHAR(50) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @DateCreated DATETIME = GETDATE()
    BEGIN TRY
        UPDATE interpol.chat (chat_title, date_created, ai_id, user_id)
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
    @pChatId NVARCHAR(50) NOT NULL,
    @pUserId NVARCHAR(50) NOT NULL,
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
    SET NOTCOUNT OFF
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
    @pCommunityId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @DateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId NVARCHAR(50) 
        BEGIN TRY
            EXEC @pPhotoId = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
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
    @pCommunityId NVARCHAR(50),
    @pCommunityName NVARCHAR(100),
    @pCommunityDescription NVARCHAR(MAX) = NULL,
    @pUserId NVARCHAR(50),
    @ImageLink NVARCHAR (100) = NULL, 
    @ImageSource NVARCHAR (1000) = NULL,
    @ImageData NVARCHAR (1000) = NULL,
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @DateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId NVARCHAR(50) 
        BEGIN TRY
            IF @ImageLink IS NULL OR @ImageLink = ''
                BEGIN
                    UPDATE interpol.community (community_name, community_description, date_created, user_id)
                    SET community_name = @pCommunityName, community_description = @pCommunityDescription, date_created = @DateCreated, user_id = @pUserId
                    WHERE community_id = @pCommunityId
                    SET @pResponseMessage = 'Success'
                END
            ELSE
                BEGIN
                    EXEC @pPhotoId = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
                    UPDATE interpol.community (community_name, community_description, date_created, user_id)
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
    @pCommunityId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pDeviceId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pDeviceId NVARCHAR(50),
    @pDeviceName NVARCHAR(100),
    @pDeviceDescription NVARCHAR(MAX),
    @pUserId NVARCHAR(50),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            UPDATE interpol.device (device_name, device_description, date_created, user_id)
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
    @pDeviceId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pDocFileId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pDocFileId NVARCHAR(50),
    @pTitle NVARCHAR(100),
    @pUserId NVARCHAR(50),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            UPDATE interpol.doc_file (title, date_created, user_id)
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
    @pDocFileId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pFavoriteId NVARCHAR(50),
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
    @pContentId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pFavoriteId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pFollowerId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pFollowerId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pFollowerId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pGltfId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pGltfId NVARCHAR(50),
    @pFileName NVARCHAR(50),
    @pFileType CHAR(10),
    @pUserId NVARCHAR(50),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        BEGIN TRY
            UPDATE interpol.gltf (file_name, file_type, user_id, date_created)
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
    @pGltfId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pCommunityId NVARCHAR(50),
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
    @pMemberId NVARCHAR(50),
    @pCommunityId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pCommunityId NVARCHAR(50),
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
    @pMemberId NVARCHAR(50),
    @pCommunityId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pMessageId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pFollowerId NVARCHAR(50),
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
    @pMessageId NVARCHAR(50),
    @pUserId NVARCHAR(50),
    @pFollowerId NVARCHAR(50),
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
    @pDocFileId NVARCHAR(50),
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
    @pMoveableId NVARCHAR(50),
    @pDocFileId NVARCHAR(50),
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
    @pDocFileId NVARCHAR(50),
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
    @pMoveableId NVARCHAR(50),
    @pPositionX TINYINT,
    @pPositionY TINYINT,
    @pPositionZ TINYINT,
    @pDocFileId NVARCHAR(50),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            UPDATE interpol.moveable (moveable_id, position_x, position_y, position_z, doc_file_id)
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
    @pMoveableId NVARCHAR(50),
    @pDocFileId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pPanelId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId NVARCHAR(50)
        BEGIN TRY
            EXEC @pPhotoId = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
            INSERT INTO interpol.panel (panel_title, date_created, user_id, photo_id)
            VALUES (@pPanelTitle, @pDateCreated, @pUserId)
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updatePanel
    @pPanelId NVARCHAR(50),
    @pPanelTitle NVARCHAR(50),
    @pUserId NVARCHAR(50),
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pDateCreated DATETIME = GETDATE()
        DECLARE @pPhotoId NVARCHAR(50) 
        BEGIN TRY
            EXEC @pPhotoId = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
            UPDATE interpol.panel (panel_title, date_created, user_id, photo_id)
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
    @pPanelId NVARCHAR(50),
    @pUserId NVARCHAR(50),
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
    @pPanelId NVARCHAR(50),
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
    @pPanelId NVARCHAR(50),
    @pNoteId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pPhotoId NVARCHAR(50)
        BEGIN TRY
            EXEC @pPhotoId = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
            SET @pResponseMessage = 'Success'
        END TRY
        BEGIN CATCH
            SET @pResponseMessage = ERROR_MESSAGE()
        END CATCH
    SET NOCOUNT OFF
END
GO

CREATE PROCEDURE interpol.updateNote
    @pNoteId NVARCHAR(50),
    @pNoteTitle NVARCHAR(50),   
    @pPanelId NVARCHAR(50),
    @ImageLink NVARCHAR (100), 
    @ImageSource NVARCHAR (1000),
    @ImageData NVARCHAR (1000),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        DECLARE @pPhotoId NVARCHAR(50)
        BEGIN TRY
            IF @ImageLink IS NULL OR @ImageLink = ''
                BEGIN
                    UPDATE interpol.note (note_title, panel_id)
                    SET note_title = @pNoteTitle, panel_id = @pPanelId
                    WHERE note_id = @pNoteId
                    SET @pResponseMessage = 'Success'
                END
            ELSE
                BEGIN
                    EXEC @pPhotoId = interpol.usp_ImportImage @ImageLink, @ImageSource, @ImageData
                    UPDATE interpol.note (note_title, panel_id)
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
    @pNoteId NVARCHAR(50),
    @pPanelId NVARCHAR(50),
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
    @pDeviceId NVARCHAR(50),
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
    @pPinId NVARCHAR(50),
    @pDeviceId NVARCHAR(50),
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
    @pDeviceId NVARCHAR(50),
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
    @pPinId NVARCHAR(50),
    @pPinLocation NVARCHAR(50),
    @pIsAnalog BIT,
    @pDeviceId NVARCHAR(50),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            UPDATE interpol.pin (pin_location, is_analog, device_id)
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
    @pPinId NVARCHAR(50),
    @pDeviceId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
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
    @pChatId NVARCHAR(50),
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
    @pUserId NVARCHAR(50),
    @pChatId NVARCHAR(50),
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
    @pPromptId NVARCHAR(50),
    @pUserId NVARCHAR(50),
    @pChatId NVARCHAR(50),
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
    @pGltfId NVARCHAR(50),
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
    @pShapeId NVARCHAR(50),
    @pGltfId NVARCHAR(50),
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
    @pGltfId NVARCHAR(50),
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
    @pShapeId NVARCHAR(50),
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
    @pGltfId NVARCHAR(50),
    @pResponseMessage NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        BEGIN TRY
            UPDATE interpol.shape (shape_name, position_x, position_y, position_z, height, width, depth, radius, shape_length, color, color_value, gltf_id)
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
    @pShapeId NVARCHAR(50),
    @pGltfId NVARCHAR(50),
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
