USE [MYDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
