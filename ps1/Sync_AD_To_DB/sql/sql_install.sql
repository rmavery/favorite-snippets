SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_users]'
GO
CREATE TABLE [dbo].[ad_users]
(
[ObjectGUID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GivenName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Surname] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Department] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Manager] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Company] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Country] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DistinguishedName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Division] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmployeeID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmployeeNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_ad_users_Enabled] DEFAULT ((1)),
[HomeDirectory] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastLogonDate] [datetime] NOT NULL,
[MobilePhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectCategory] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectClass] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Office] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OfficePhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Organization] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OtherName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OU] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[POBox] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PostalCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SamAccountName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserPrincipalName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[createDate] [datetime] NOT NULL CONSTRAINT [DF_ad_users_createDate] DEFAULT (getdate()),
[lastModDate] [datetime] NOT NULL CONSTRAINT [DF_ad_users_lastModDate] DEFAULT (getdate()),
[deletedDate] [datetime] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ad_users] on [dbo].[ad_users]'
GO
ALTER TABLE [dbo].[ad_users] ADD CONSTRAINT [PK_ad_users] PRIMARY KEY CLUSTERED  ([ObjectGUID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_objects]'
GO
CREATE TABLE [dbo].[ad_objects]
(
[ObjectGuid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CanonicalName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DistinguishedName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OU] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NOT NULL,
[Modified] [datetime] NOT NULL,
[Deleted] [datetime] NULL,
[ObjectCategory] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectClass] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ad_objects] on [dbo].[ad_objects]'
GO
ALTER TABLE [dbo].[ad_objects] ADD CONSTRAINT [PK_ad_objects] PRIMARY KEY CLUSTERED  ([ObjectGuid])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_members]'
GO
CREATE TABLE [dbo].[ad_members]
(
[record_id] [int] NOT NULL IDENTITY(1, 1),
[objectGuid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[memberGuid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[addedDate] [datetime] NOT NULL CONSTRAINT [DF_ad_members_CreatedDate] DEFAULT (getdate()),
[lastModDate] [datetime] NOT NULL CONSTRAINT [DF_ad_members_lastModDate] DEFAULT (getdate()),
[removedDate] [datetime] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ad_members] on [dbo].[ad_members]'
GO
ALTER TABLE [dbo].[ad_members] ADD CONSTRAINT [PK_ad_members] PRIMARY KEY CLUSTERED  ([record_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_ad_object_member_unique] on [dbo].[ad_members]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ad_object_member_unique] ON [dbo].[ad_members] ([objectGuid], [memberGuid])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[_ad_users]'
GO
CREATE TABLE [dbo].[_ad_users]
(
[City] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CN] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistinguishedName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Division] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployeeID] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmployeeNumber] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GivenName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomeDirectory] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastLogonDate] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mail] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberOf] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectCategory] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectClass] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectGUID] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Office] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficePhone] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Organization] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OU] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[POBox] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SamAccountName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SID] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Surname] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserPrincipalName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[_ad_user_memberOf]'
GO
CREATE TABLE [dbo].[_ad_user_memberOf]
(
[user_objectGuid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[memberOf_DN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_insert_update_ad_users]'
GO
CREATE  PROCEDURE [dbo].[ad_insert_update_ad_users] 
as

 -- UNDELETE -- 
 UPDATE u2 set 
	deletedDate = NULL 
 FROM [dbo].[ad_users] u2 
 WHERE 1 = 1 
 AND u2.deletedDate is not null 
 and exists ( 
	select 1 from [dbo].[_ad_users] u1 
	where u1.objectGuid = u2.objectGuid 
 )
 
 -- INSERT -- 
INSERT INTO [dbo].[ad_users]
           ([ObjectGUID]
           ,[GivenName]
           ,[Surname]
           ,[Name]
           ,[Department]
           ,[Title]
           ,[Description]
           ,[Manager]
           ,[City]
           ,[CN]
           ,[Company]
           ,[Country]
           ,[DistinguishedName]
           ,[Division]
           ,[EmailAddress]
           ,[EmployeeID]
           ,[EmployeeNumber]
           ,[Enabled]
           ,[HomeDirectory]
           ,[LastLogonDate]
           ,[MobilePhone]
           ,[Mail]
           ,[ObjectCategory]
           ,[ObjectClass]
           ,[Office]
           ,[OfficePhone]
           ,[Organization]
           ,[OtherName]
           ,[OU]
           ,[POBox]
           ,[PostalCode]
           ,[SamAccountName]
           ,[SID]
           ,[State]
           ,[UserPrincipalName])
SELECT ObjectGUID
           ,GivenName
           ,Surname
           ,[Name]
           ,Department
           ,Title
           ,[Description]
           ,Manager
           ,City
           ,CN
           ,Company
           ,Country
           ,DistinguishedName
           ,Division
           ,EmailAddress
           ,EmployeeID
           ,EmployeeNumber
           ,[Enabled] = Case u1.[Enabled] when 'True' then 1 Else 0 End 
           ,HomeDirectory
           ,LastLogonDate
           ,MobilePhone
           ,Mail
           ,ObjectCategory
           ,ObjectClass
           ,Office
           ,OfficePhone
           ,Organization
           ,OtherName
           ,OU
           ,POBox
           ,PostalCode
           ,SamAccountName
           ,[SID]
           ,[State]
           ,UserPrincipalName
	FROM [dbo].[_ad_users] u1 
	where not exists( 
		select 1 from [dbo].[ad_users] u2
		where u1.objectGUID = u2.objectGuid 
)
 
 -- UPDATE -- 
update u2 set 
		GivenName = u1.GivenName
		,Surname = u1.Surname
		,[Name] = u1.[Name]
		,Department = u1.Department
		,Title = u1.Title
		,[Description] = u1.[Description]
		,Manager = u1.Manager
		,City = u1.City
		,CN = u1.CN
		,Company = u1.Company
		,Country = u1.Country
		,DistinguishedName = u1.DistinguishedName
		,Division = u1.Division
		,EmailAddress = u1.EmailAddress
		,EmployeeID = u1.EmployeeID
		,EmployeeNumber = u1.EmployeeNumber
		,[Enabled] = Case u1.[Enabled] when 'True' then 1 Else 0 End 
		,HomeDirectory = u1.HomeDirectory
		,LastLogonDate = u1.LastLogonDate
		,MobilePhone = u1.MobilePhone
		,Mail = u1.Mail
		,ObjectCategory = u1.ObjectCategory
		,ObjectClass = u1.ObjectClass
		,Office = u1.Office
		,OfficePhone = u1.OfficePhone
		,Organization = u1.Organization
		,OtherName = u1.OtherName
		,OU = u1.OU
		,POBox = u1.POBox
		,PostalCode = u1.PostalCode
		,SamAccountName = u1.SamAccountName
		,[SID] = u1.[SID]
		,[State] = u1.[State]
		,UserPrincipalName = u1.UserPrincipalName
		,lastModDate = GetDate()
	FROM [dbo].[_ad_users] u1 
	INNER JOIN [dbo].[ad_users] u2 
	ON u1.objectGuid = u2.ObjectGuid 
	where 
	(
		u2.GivenName <> u1.GivenName OR
		u2.Surname <> u1.Surname OR 
		u2.[Name] <> u1.[Name] OR 
		u2.Department <> u1.Department OR 
		u2.Title <> u1.Title OR 
		u2.[Description] <> u1.[Description] OR 
		u2.Manager <> u1.Manager OR 
		u2.City <> u1.City OR 
		u2.CN <> u1.CN OR 
		u2.Company <> u1.Company OR 
		u2.Country <> u1.Country OR 
		u2.DistinguishedName <> u1.DistinguishedName OR 
		u2.Division <> u1.Division OR 
		u2.EmailAddress <> u1.EmailAddress OR 
		u2.EmployeeID <> u1.EmployeeID OR 
		u2.EmployeeNumber <> u1.EmployeeNumber OR 
		u2.[Enabled] <> Case u1.[Enabled] when 'True' then 1 Else 0 End  OR 
		u2.HomeDirectory <> u1.HomeDirectory OR 
		u2.LastLogonDate <> u1.LastLogonDate OR 
		u2.MobilePhone <> u1.MobilePhone OR 
		u2.Mail <> u1.Mail OR 
		u2.ObjectCategory <> u1.ObjectCategory OR 
		u2.ObjectClass <> u1.ObjectClass OR 
		u2.Office <> u1.Office OR 
		u2.OfficePhone <> u1.OfficePhone OR 
		u2.Organization <> u1.Organization OR 
		u2.OtherName <> u1.OtherName OR 
		u2.OU <> u1.OU OR 
		u2.POBox <> u1.POBox OR 
		u2.PostalCode <> u1.PostalCode OR 
		u2.SamAccountName <> u1.SamAccountName OR 
		u2.[SID] <> u1.[SID] OR 
		u2.[State] <> u1.[State] OR 
		u2.UserPrincipalName <> u1.UserPrincipalName
	)


	-- DELETE  -- 
	UPDATE u2 set 
		deletedDate = GetDate() 
	From [dbo].[ad_users] u2 
	where not exists (
		select 1 from [dbo].[_ad_users] u1 
		where u1.objectGuid = u2.objectGuid 
	) 
	and u2.deletedDate is NULL 

-- ============================= GROUP MEMBERSHIP OF USERS ===========================
-- The AD Query returns the groups as 'DistinguishedNames' and the table is just object IDs, so 
-- this query joins the _ad_user_memberOf table to the ad_objects table to get the DN
-- Then it checks to see if the objectGuids exist in the ad_members table  
-- ===================================================================================

	-- UNDELETE -- 
	Update m set 
		RemovedDate = NULL, 
		lastModDate = GetDate() 
	from ad_members m
	where exists (
		select 
			1 
		From  _ad_user_memberof adm  
			inner join ad_objects usr 
				on adm.user_objectGuid = usr.objectGuid  
			inner join ad_objects grp 
				on adm.memberOf_DN = grp.DistinguishedName
		where 1 = 1 
		and m.objectGuid = grp.objectGuid 
		and m.memberGuid = usr.objectGuid 
	)
	and m.removedDate is NOT NULL 



	-- INSERT -- 
	Insert into ad_members (objectGuid, MemberGuid)
	Select 
		dn.objectGuid, 
		adumt.user_objectGuid
	from _ad_user_memberof adumt 
		inner join ad_objects dn 
			on dn.distinguishedName = adumt.MemberOf_DN
	where not exists ( 
		select 
			user_ObjectGuid = adoU.objectGuid, 
			MemberOf_DN = adoG.DistinguishedName, 
			--'adm' = 'adm' , adm.*
			--'adoU' = 'adoU', adoU.*
			'adoG' = 'adoG', adoG.*
		from ad_members adm 
		inner join ad_objects adoU
			on adm.MemberGuid = adoU.ObjectGuid 
			and adoU.objectClass = 'user' 
		inner join ad_objects adoG
			on adm.ObjectGuid = adoG.ObjectGuid
		where adumt.user_objectGuid = adou.ObjectGuid
		and adumt.MemberOf_DN = adoG.DistinguishedName
	) 



	-- DELETE -- 
	Update m set 
		RemovedDate = GetDate()
	from ad_members m
		inner join ad_objects o
			on m.objectGuid = o.objectGuid 
			and o.objectClass = 'USER' 
	where not exists (
		select 
			1 
		From  _ad_user_memberof adm  
			inner join ad_objects usr 
				on adm.user_objectGuid = usr.objectGuid
			inner join ad_objects grp 
				on adm.memberOf_DN = grp.DistinguishedName
		where 1 = 1 
		and m.objectGuid = grp.objectGuid 
		and m.memberGuid = usr.objectGuid 
	)
	and m.removedDate is null 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[_ad_objects]'
GO
CREATE TABLE [dbo].[_ad_objects]
(
[ObjectGuid] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CanonicalName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CN] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistinguishedName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OU] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Modified] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectCategory] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectClass] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_insert_update_ad_objects]'
GO
CREATE  proc [dbo].[ad_insert_update_ad_objects] 
as

-- INSERT NEW RECORDS -- 
insert into [dbo].[ad_objects](
    [ObjectGuid], [Name], [DisplayName], [Description], 
    [CanonicalName], [CN], [DistinguishedName], [OU], [Created], [Modified], [Deleted], [ObjectCategory], [ObjectClass]
)
select
    [ObjectGuid]
    , [Name]
    , [DisplayName]
    , [Description]
    , [CanonicalName]
    , [CN]
    , [DistinguishedName]
	, [OU]
    , cast([Created] as datetime)
    , cast([Modified] as datetime) 
    , case when [Deleted] = '' then NULL ELSE cast([Deleted] as datetime) end
    , [ObjectCategory]
    , [ObjectClass]
from [dbo].[_ad_objects] adot
where not exists (
    select 1 from [dbo].[ad_objects] adop
    where adot.ObjectGuid = adop.ObjectGuid 
)

-- UPDATE CHANGED OBJECTS ON THE PERMANENT TABLE -- 
update adop set
      [Name] = adot.[Name]
    , [DisplayName] = adot.[DisplayName]
    , [Description]= adot.[Description]
    , [CanonicalName]= adot.[CanonicalName]
    , [CN]= adot.[CN]
    , [DistinguishedName]= adot.[DistinguishedName]
	, [OU] = adot.[OU]
    , [Created]= CAST(adot.[Created] AS datetime)
    , [Modified]= CAST(adot.[Modified] AS datetime)
    , [Deleted]= CASE WHEN adot.[Deleted] = '' THEN NULL ELSE CAST(adot.[Deleted] AS datetime) END
    , [ObjectCategory]= adot.[ObjectCategory]
    , [ObjectClass]= adot.[ObjectClass]
FROM [dbo].[ad_objects] adop 
inner join [dbo].[_ad_objects] adot 
on adot.ObjectGuid = adop.ObjectGuid 
where 1 = 1 and 
(
       adop.[Name] <> adot.[Name]
    OR adop.[DisplayName] <> adot.[DisplayName]
    OR adop.[Description] <> adot.[Description]
    OR adop.[CanonicalName] <> adot.[CanonicalName]
    OR adop.[CN] <> adot.[CN]
    OR adop.[DistinguishedName] <> adot.[DistinguishedName]
	OR adop.[OU] <> adot.[OU]
    OR adop.[Created] <> cast(adot.[Created] as datetime)
    OR adop.[Modified] <> cast(adot.[Modified] as datetime)
    OR isnull(adop.[Deleted], '') <> adot.[Deleted]
    OR adop.[ObjectCategory] <> adot.[ObjectCategory]
    OR adop.[ObjectClass] <> adot.[ObjectClass]
)


-- DELETE RECORDS THAT NO LONGER EXIST -- 
update adop set 
    [Deleted] = Getdate() 
from [dbo].[ad_objects] adop 
where not exists ( 
    select 1 from [dbo].[_ad_objects] adot 
    where adot.ObjectGuid = adop.ObjectGuid
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_groups]'
GO
CREATE TABLE [dbo].[ad_groups]
(
[ObjectGUID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CanonicalName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DistinguishedName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupCategory] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupScope] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ManagedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectCategory] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ObjectClass] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OU] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SamAccountName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF_ad_groups_Created] DEFAULT (getdate()),
[Modified] [datetime] NOT NULL CONSTRAINT [DF_ad_groups_Modified] DEFAULT (getdate()),
[Deleted] [datetime] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_ad_groups] on [dbo].[ad_groups]'
GO
ALTER TABLE [dbo].[ad_groups] ADD CONSTRAINT [PK_ad_groups] PRIMARY KEY CLUSTERED  ([ObjectGUID])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[_ad_groups]'
GO
CREATE TABLE [dbo].[_ad_groups]
(
[ObjectGUID] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CanonicalName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CN] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DistinguishedName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupCategory] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupScope] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManagedBy] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberOf] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Members] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OU] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SamAccountName] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SID] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Modified] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectCategory] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectClass] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[_ad_group_members]'
GO
CREATE TABLE [dbo].[_ad_group_members]
(
[objectguid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[member_DN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[_ad_group_memberOf]'
GO
CREATE TABLE [dbo].[_ad_group_memberOf]
(
[objectguid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[memberOf_DN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[ad_insert_update_ad_groups]'
GO
CREATE proc [dbo].[ad_insert_update_ad_groups] 
as 

	-- UNDELETE -- 
	 UPDATE g2 set 
		deleted = NULL 
	 FROM [dbo].[ad_groups] g2 
	 WHERE 1 = 1 
	 AND g2.deleted is not null 
	 and exists ( 
		select 1 from [dbo].[_ad_groups] g1 
		where g1.objectGuid = g2.objectGuid 
	 )

	-- INSERT -- 
	INSERT INTO ad_groups (
		[ObjectGUID]
		,[Name]
		,[DisplayName]
		,[Description]
		,[CanonicalName]
		,[CN]
		,[DistinguishedName]
		,[GroupCategory]
		,[GroupScope]
		,[ManagedBy]
		,[ObjectCategory]
		,[ObjectClass]
		,[OU]
		,[SamAccountName]
		,[SID]
		,[Created]
		,[Modified]
	)
	SELECT 
		[ObjectGUID]
		,[Name]
		,[DisplayName]
		,[Description]
		,[CanonicalName]
		,[CN]
		,[DistinguishedName]
		,[GroupCategory]
		,[GroupScope]
		,[ManagedBy]
		,[ObjectCategory]
		,[ObjectClass]
		,[OU]
		,[SamAccountName]
		,[SID]
		,CAST([Created] AS DATETIME)
		,CAST([Modified] AS DATETIME) 
	FROM _ad_groups t
	WHERE NOT EXISTS (
		SELECT 
			ObjectGuid
		From ad_groups p 
		where p.objectGuid = t.objectGuid 
	)

	-- UPDATE -- 
	update g2 set 
		[Name] = g1.[Name]
		,DisplayName = g1.DisplayName
		,[Description] = g1.[Description]
		,CanonicalName = g1.CanonicalName
		,CN = g1.CN
		,DistinguishedName = g1.DistinguishedName
		,GroupCategory = g1.GroupCategory
		,GroupScope = g1.GroupScope
		,ManagedBy = g1.ManagedBy
		,OU = g1.OU
		,SamAccountName = g1.SamAccountName
		,[SID] = g1.[SID]
		,Created = cast(g1.Created as datetime)
		,Modified = cast(g1.Modified as datetime)
		,Deleted = case when g1.Deleted = '' then NULL else cast(g1.Deleted as datetime) end
		,ObjectCategory = g1.ObjectCategory
		,ObjectClass = g1.ObjectClass
	FROM [dbo].[_ad_groups] g1
	INNER JOIN [dbo].[ad_groups] g2
	ON g1.objectGuid = g2.objectGuid 
	where 1 = 1 
	and (
			g2.[Name] <> g1.[Name] OR 
			g2.DisplayName <> g1.DisplayName OR 
			g2.[Description] <> g1.[Description] OR 
			g2.CanonicalName <> g1.CanonicalName OR 
			g2.CN <> g1.CN OR 
			g2.DistinguishedName <> g1.DistinguishedName OR 
			g2.GroupCategory <> g1.GroupCategory OR 
			g2.GroupScope <> g1.GroupScope OR 
			g2.ManagedBy <> g1.ManagedBy OR 
			g2.OU <> g1.OU OR 
			g2.SamAccountName <> g1.SamAccountName OR 
			g2.[SID] <> g1.[SID] OR 
			g2.Created <> cast(g1.Created as datetime) OR 
			g2.Modified <> cast(g1.Modified as datetime) OR 
			g2.Deleted <> case when g1.Deleted = '' then NULL ELSE CAST(g1.deleted as datetime) end OR 
			g2.ObjectCategory <> g1.ObjectCategory OR 
			g2.ObjectClass <> g1.ObjectClass
		)



	-- DELETE -- 
	UPDATE g2 set
		deleted = GetDate() 
	From [dbo].[ad_groups] g2 
	where not exists (
		select 1 from [dbo].[_ad_groups] g1 
		where g1.objectGuid = g2.objectGuid 
	) 
	and g2.deleted is null 



	-- ================================ MEMBERSHIP OF GROUPS =============================
	-- The AD Query returns the MEMBERS as 'DistinguishedNames' and the table is just object IDs, so 
	-- this query joins the _ad_group_memberOf table to the ad_objects table to get the DN
	-- Then it checks to see if the objectGuids exist in the ad_members table  
	-- ===================================================================================

	 -- Mem = (Member) object, Cont = Container (object) (because they're both groups, and it gets confusing) 

	-- UNDELETE -- 
	Update m set 
		RemovedDate = NULL, 
		lastModDate = GetDate() 
	from ad_members m
	where exists (
		select 
			1 
		From  _ad_group_memberof adm  
			inner join ad_objects Mem 
				on adm.objectGuid = Mem.objectGuid  
			inner join ad_objects Cont
				on adm.memberOf_DN = Cont.DistinguishedName
		where 1 = 1 
		and m.objectGuid = Mem.objectGuid 
		and m.memberGuid = Cont.objectGuid 
	)
	and m.removedDate is NOT NULL 

	-- INSERT -- 
	Insert into ad_members (objectGuid, MemberGuid)
	Select 
		dn.objectGuid,   --ObjectGuid
		adgmt.objectGuid  --MemberGuid 
	from _ad_group_memberof adgmt 
		inner join ad_objects dn 
			on dn.distinguishedName = adgmt.MemberOf_DN
	where not exists ( 
		select 
			ObjectGuid = Mem.objectGuid, 
			MemberOf_DN = Cont.DistinguishedName, 
			--'adm' = 'adm' , adm.*
			--'Mem' = 'Mem', Mem.*
			'Cont' = 'Cont', cont.*
		from ad_members adm 
		inner join ad_objects Mem
			on adm.MemberGuid = Mem.ObjectGuid 
			and Mem.objectClass = 'group' 
		inner join ad_objects Cont
			on adm.ObjectGuid = Cont.ObjectGuid
		where adgmt.objectGuid = Mem.ObjectGuid
		and adgmt.MemberOf_DN = Cont.DistinguishedName
	) 

	-- No need to update because a changed GUID is something else entirely -- 

	-- DELETE -- 
	Update m set 
		RemovedDate = GetDate()
	from ad_members m 
		inner join ad_objects o
		on o.objectGuid = m.memberGuid 
		and o.objectClass = 'group' 
	where not exists (
		select 
			*
		From  _ad_group_memberof adm  
			inner join ad_objects Mem 
				on adm.objectGuid = Mem.objectGuid
				and Mem.objectClass = 'group'   
			inner join ad_objects Cont 
				on adm.memberOf_DN = Cont.DistinguishedName
				and Cont.objectClass = 'group' 
		where 1 = 1 
		and m.objectGuid = Cont.objectGuid 
		and m.memberGuid = Mem.objectGuid 
	)
	
	--and m.removedDate is null 
	-- =============================== GROUP MEMBEROF GROUPS ============================
	-- FLIPPED : GROUPS CAN BOTH HAVE MEMBERS AND BE MEMBERS, SO I WILL TREAT THE GROUP AS A USER HERE... 
	-- The AD Query returns the MEMBERS as 'DistinguishedNames' and the table is just object IDs, so 
	-- this query joins the _ad_group_members table to the ad_objects table to get the DN
	-- Then it checks to see if the objectGuids exist in the ad_members table  
	-- ===================================================================================

	-- UNDELETE -- 
	Update m set 
		RemovedDate = NULL, 
		lastModDate = GetDate() 
	from ad_members m
	where exists (
		select 
			1 
		From  _ad_group_members adm  
			inner join ad_objects Mem 
				on adm.Member_DN = Mem.DistinguishedName  
			inner join ad_objects Cont
				on adm.objectGuid = Cont.objectGuid
		where 1 = 1 
		and m.objectGuid = Cont.objectGuid 
		and m.memberGuid = Mem.objectGuid 
	)
	and m.removedDate is NOT NULL 


	-- INSERT -- 
	Insert into ad_members (objectGuid, MemberGuid)
	Select 
		adgmt.objectGuid,   --ObjectGuid
		dn.objectGuid		--MemberGuid 
	from _ad_group_members adgmt 
		inner join ad_objects dn 
			on dn.distinguishedName = adgmt.Member_DN
	where not exists ( 
		select 
			ObjectGuid = Cont.objectGuid, 
			MemberGuid = Mem.objectGuid
		from ad_members adm 
		inner join ad_objects Mem
			on adm.MemberGuid = Mem.ObjectGuid 
		inner join ad_objects Cont
			on adm.ObjectGuid = Cont.ObjectGuid
		where dn.objectGuid = Mem.ObjectGuid
		and adgmt.objectGuid = Cont.objectGuid
		and dn.objectGuid = Mem.objectGuid
	) 
	-- No need to update because a changed GUID is something else entirely -- 
 
	-- DELETE -- 
	Update m set 
		RemovedDate = GetDate() 
	from ad_members m 
		inner join ad_objects Mem
		on Mem.objectGuid = m.memberGuid
		--and Mem.ObjectClass = 'group'  
	where not exists (
		select 
			*
		From  _ad_group_members adm  
			inner join ad_objects Mem 
				on adm.Member_DN = Mem.DistinguishedName
				--and Mem.objectClass = 'group'   
			inner join ad_objects Cont 
				on adm.objectGuid = Cont.objectGuid
				and Cont.objectClass = 'group' 
		where 1 = 1 
		and m.objectGuid = Cont.objectGuid 
		and m.memberGuid = Mem.objectGuid 
	)

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
