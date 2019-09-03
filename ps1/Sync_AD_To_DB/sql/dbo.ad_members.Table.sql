
CREATE TABLE [dbo].[ad_members](
	[record_id] [int] IDENTITY(1,1) NOT NULL,
	[objectGuid] [varchar](100) NOT NULL,
	[memberGuid] [varchar](100) NOT NULL,
	[addedDate] [datetime] NOT NULL,
	[lastModDate] [datetime] NOT NULL,
	[removedDate] [datetime] NULL,
 CONSTRAINT [PK_ad_members] PRIMARY KEY CLUSTERED 
(
	[record_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[ad_members] ADD  CONSTRAINT [DF_ad_members_CreatedDate]  DEFAULT (getdate()) FOR [addedDate]
GO
ALTER TABLE [dbo].[ad_members] ADD  CONSTRAINT [DF_ad_members_lastModDate]  DEFAULT (getdate()) FOR [lastModDate]
GO
