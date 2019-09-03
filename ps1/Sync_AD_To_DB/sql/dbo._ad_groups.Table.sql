
CREATE TABLE [dbo].[_ad_groups](
	[ObjectGUID] [varchar](512) NULL,
	[Name] [varchar](512) NULL,
	[DisplayName] [varchar](512) NULL,
	[Description] [varchar](512) NULL,
	[CanonicalName] [varchar](512) NULL,
	[CN] [varchar](512) NULL,
	[DistinguishedName] [varchar](512) NULL,
	[GroupCategory] [varchar](512) NULL,
	[GroupScope] [varchar](512) NULL,
	[ManagedBy] [varchar](512) NULL,
	[MemberOf] [text] NULL,
	[Members] [text] NULL,
	[OU] [varchar](512) NULL,
	[SamAccountName] [varchar](512) NULL,
	[SID] [varchar](512) NULL,
	[Created] [varchar](512) NULL,
	[Modified] [varchar](512) NULL,
	[Deleted] [varchar](512) NULL,
	[ObjectCategory] [varchar](512) NULL,
	[ObjectClass] [varchar](512) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
