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

-- I want to take imageLink, imageSource, and ImageData parameters and run them through interpol.usp_ImportImage and then take the photo id that's left from there and plug it into the next function


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
        WHERE user_name = @pUserName OR user_id LIKE '%' + @pUserId + '%'
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