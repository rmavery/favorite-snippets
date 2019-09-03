USE [MYDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
