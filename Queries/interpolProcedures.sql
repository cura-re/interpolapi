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