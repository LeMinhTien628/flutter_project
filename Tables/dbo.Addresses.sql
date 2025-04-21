CREATE TABLE [dbo].[Addresses] (
  [AddressID] [int] IDENTITY,
  [UserID] [int] NOT NULL,
  [AddressName] [nvarchar](255) NOT NULL,
  [IsDefault] [bit] NOT NULL DEFAULT (0),
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([AddressID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Addresses]
  ADD FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO