
CREATE TABLE [dbo].[ad_users](
	[ObjectGUID] [varchar](100) NOT NULL,
	[GivenName] [varchar](255) NOT NULL,
	[Surname] [varchar](100) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Department] [varchar](255) NOT NULL,
	[Title] [varchar](255) NOT NULL,
	[Description] [varchar](512) NOT NULL,
	[Manager] [varchar](255) NOT NULL,
	[City] [varchar](100) NOT NULL,
	[CN] [varchar](255) NOT NULL,
	[Company] [varchar](255) NOT NULL,
	[Country] [varchar](100) NOT NULL,
	[DistinguishedName] [varchar](255) NOT NULL,
	[Division] [varchar](255) NOT NULL,
	[EmailAddress] [varchar](100) NOT NULL,
	[EmployeeID] [varchar](50) NOT NULL,
	[EmployeeNumber] [varchar](50) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[HomeDirectory] [varchar](255) NOT NULL,
	[LastLogonDate] [datetime] NOT NULL,
	[MobilePhone] [varchar](50) NOT NULL,
	[Mail] [varchar](255) NOT NULL,
	[ObjectCategory] [varchar](100) NOT NULL,
	[ObjectClass] [varchar](50) NOT NULL,
	[Office] [varchar](100) NOT NULL,
	[OfficePhone] [varchar](50) NOT NULL,
	[Organization] [varchar](255) NOT NULL,
	[OtherName] [varchar](255) NOT NULL,
	[OU] [varchar](255) NOT NULL,
	[POBox] [varchar](50) NOT NULL,
	[PostalCode] [varchar](50) NOT NULL,
	[SamAccountName] [varchar](255) NOT NULL,
	[SID] [varchar](100) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[UserPrincipalName] [varchar](100) NOT NULL,
	[createDate] [datetime] NOT NULL,
	[lastModDate] [datetime] NOT NULL,
	[deletedDate] [datetime] NULL,
 CONSTRAINT [PK_ad_users] PRIMARY KEY CLUSTERED 
(
	[ObjectGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[ad_users] ADD  CONSTRAINT [DF_ad_users_Enabled]  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[ad_users] ADD  CONSTRAINT [DF_ad_users_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[ad_users] ADD  CONSTRAINT [DF_ad_users_lastModDate]  DEFAULT (getdate()) FOR [lastModDate]
GO
