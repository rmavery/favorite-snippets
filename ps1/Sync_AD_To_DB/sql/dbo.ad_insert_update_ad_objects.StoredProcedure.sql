USE [MYDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
