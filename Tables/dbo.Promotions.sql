CREATE TABLE [dbo].[Promotions] (
  [PromotionID] [int] IDENTITY,
  [PromotionName] [nvarchar](100) NOT NULL,
  [Description] [nvarchar](255) NULL,
  [DiscountPercentage] [decimal](5, 2) NULL,
  [ImageURL] [nvarchar](255) NULL,
  [StartDate] [datetime] NOT NULL,
  [EndDate] [datetime] NOT NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([PromotionID])
)
ON [PRIMARY]
GO