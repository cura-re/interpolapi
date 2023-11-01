CREATE TRIGGER interpol.trg_user_delete
   ON interpol.interpol_user
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.photo WHERE photo_id IN (SELECT photo_id FROM DELETED)
 DELETE FROM interpol.post WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.community WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.member WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.artificial_intelligence WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.chat WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.prompt WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.user_chat_comment WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.device WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.doc_file WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.favorite WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.follower WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.message_table WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.message_comment WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.panel WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.gltf WHERE user_id IN (SELECT user_id FROM DELETED)
 DELETE FROM interpol.gltf_comment WHERE user_id IN (SELECT user_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_post_delete
   ON interpol.post
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.comment WHERE post_id IN (SELECT post_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_community_post_delete
   ON interpol.community_post
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.community_comment WHERE post_id IN (SELECT post_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_community_delete
   ON interpol.community
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.member WHERE community_id IN (SELECT community_id FROM DELETED)
 DELETE FROM interpol.community_post WHERE community_id IN (SELECT community_id FROM DELETED)
 DELETE FROM interpol.channel WHERE community_id IN (SELECT community_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_artificial_intelligence_delete
   ON interpol.artificial_intelligence
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.chat WHERE ai_id IN (SELECT ai_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_chat_delete
   ON interpol.chat
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.user_chat_comment WHERE chat_id IN (SELECT chat_id FROM DELETED)
 DELETE FROM interpol.chat_comment WHERE chat_id IN (SELECT chat_id FROM DELETED)
 DELETE FROM interpol.prompt WHERE chat_id IN (SELECT chat_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_device_delete
   ON interpol.device
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.pin WHERE device_id IN (SELECT device_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_pin_delete
   ON interpol.pin
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.action_table WHERE pin_id IN (SELECT pin_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_channel_delete
   ON interpol.channel
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.channel_comment WHERE channel_id IN (SELECT channel_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_doc_file_delete
   ON interpol.doc_file
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.moveable WHERE doc_file_id IN (SELECT doc_file_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_panel_delete
   ON interpol.panel
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.note WHERE panel_id IN (SELECT panel_id FROM DELETED)
END
GO

CREATE TRIGGER interpol.trg_gltf_delete
   ON interpol.gltf
   INSTEAD OF DELETE
AS 
BEGIN
 SET NOCOUNT ON;
 DELETE FROM interpol.shape WHERE gltf_id IN (SELECT gltf_id FROM DELETED)
 DELETE FROM interpol.gltf_comment WHERE gltf_id IN (SELECT gltf_id FROM DELETED)
END
GO