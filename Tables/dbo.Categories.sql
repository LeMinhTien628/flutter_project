CREATE TABLE [dbo].[Categories] (
  [CategoryID] [int] IDENTITY,
  [CategoryName] [nvarchar](100) NOT NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([CategoryID]),
  UNIQUE ([CategoryName])
)
ON [PRIMARY]
GO