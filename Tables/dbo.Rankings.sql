CREATE TABLE [dbo].[Rankings] (
  [RankingID] [int] IDENTITY,
  [ProductID] [int] NOT NULL,
  [AverageRating] [decimal](3, 2) NOT NULL,
  [RankPosition] [int] NOT NULL,
  [Period] [nvarchar](20) NOT NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([RankingID]),
  CONSTRAINT [CK_Rankings_Period] CHECK ([Period]='Monthly' OR [Period]='Weekly')
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Rankings]
  ADD FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO