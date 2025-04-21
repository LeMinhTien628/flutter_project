CREATE TABLE [dbo].[Products] (
  [ProductID] [int] IDENTITY,
  [ProductName] [nvarchar](100) NOT NULL,
  [Description] [nvarchar](max) NULL,
  [Price] [decimal](18, 2) NOT NULL,
  [CategoryID] [int] NOT NULL,
  [SubCategoryID] [int] NULL,
  [ImageURL] [nvarchar](255) NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([ProductID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Products]
  ADD FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Categories] ([CategoryID])
GO

ALTER TABLE [dbo].[Products]
  ADD FOREIGN KEY ([SubCategoryID]) REFERENCES [dbo].[SubCategories] ([SubCategoryID])
GO