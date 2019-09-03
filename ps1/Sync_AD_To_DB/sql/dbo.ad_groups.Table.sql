
CREATE TABLE [dbo].[ad_groups](
	[ObjectGUID] [varchar](100) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[DisplayName] [varchar](255) NOT NULL,
	[Description] [varchar](512) NOT NULL,
	[CanonicalName] [varchar](255) NOT NULL,
	[CN] [varchar](255) NOT NULL,
	[DistinguishedName] [varchar](255) NOT NULL,
	[GroupCategory] [varchar](100) NOT NULL,
	[GroupScope] [varchar](100) NOT NULL,
	[ManagedBy] [varchar](255) NOT NULL,
	[ObjectCategory] [varchar](100) NOT NULL,
	[ObjectClass] [varchar](50) NOT NULL,
	[OU] [varchar](255) NOT NULL,
	[SamAccountName] [varchar](255) NOT NULL,
	[SID] [varchar](255) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Modified] [datetime] NOT NULL,
	[Deleted] [datetime] NULL,
 CONSTRAINT [PK_ad_groups] PRIMARY KEY CLUSTERED 
(
	[ObjectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[ad_groups] ADD  CONSTRAINT [DF_ad_groups_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [dbo].[ad_groups] ADD  CONSTRAINT [DF_ad_groups_Modified]  DEFAULT (getdate()) FOR [Modified]
GO
