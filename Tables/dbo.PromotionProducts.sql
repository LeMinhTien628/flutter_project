CREATE TABLE [dbo].[PromotionProducts] (
  [PromotionProductID] [int] IDENTITY,
  [PromotionID] [int] NOT NULL,
  [ProductID] [int] NOT NULL,
  PRIMARY KEY CLUSTERED ([PromotionProductID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[PromotionProducts]
  ADD FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO

ALTER TABLE [dbo].[PromotionProducts]
  ADD FOREIGN KEY ([PromotionID]) REFERENCES [dbo].[Promotions] ([PromotionID])
GO