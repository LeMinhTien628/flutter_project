CREATE TABLE [dbo].[SubCategories] (
  [SubCategoryID] [int] IDENTITY,
  [CategoryID] [int] NOT NULL,
  [SubCategoryName] [nvarchar](100) NOT NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([SubCategoryID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SubCategories]
  ADD FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Categories] ([CategoryID])
GO