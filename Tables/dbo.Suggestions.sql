CREATE TABLE [dbo].[Suggestions] (
  [SuggestionID] [int] IDENTITY,
  [ProductID] [int] NOT NULL,
  [SuggestedProductID] [int] NOT NULL,
  [Confidence] [decimal](5, 2) NOT NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([SuggestionID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Suggestions]
  ADD FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO

ALTER TABLE [dbo].[Suggestions]
  ADD FOREIGN KEY ([SuggestedProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO