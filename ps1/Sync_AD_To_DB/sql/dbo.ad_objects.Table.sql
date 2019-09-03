
CREATE TABLE [dbo].[ad_objects](
	[ObjectGuid] [varchar](100) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[DisplayName] [varchar](255) NOT NULL,
	[Description] [varchar](512) NOT NULL,
	[CanonicalName] [varchar](512) NOT NULL,
	[CN] [varchar](255) NOT NULL,
	[DistinguishedName] [varchar](512) NOT NULL,
	[OU] [varchar](512) NULL,
	[Created] [datetime] NOT NULL,
	[Modified] [datetime] NOT NULL,
	[Deleted] [datetime] NULL,
	[ObjectCategory] [varchar](255) NOT NULL,
	[ObjectClass] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ad_objects] PRIMARY KEY CLUSTERED 
(
	[ObjectGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
