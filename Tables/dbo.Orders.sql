CREATE TABLE [dbo].[Orders] (
  [OrderID] [int] IDENTITY,
  [UserID] [int] NOT NULL,
  [AddressID] [int] NULL,
  [OrderDate] [datetime] NOT NULL DEFAULT (getdate()),
  [TotalAmount] [decimal](18, 2) NOT NULL,
  [Status] [nvarchar](50) NOT NULL,
  [PaymentMethod] [nvarchar](50) NOT NULL,
  [ShippingFee] [decimal](18, 2) NOT NULL DEFAULT (0),
  [PromotionID] [int] NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([OrderID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Orders]
  ADD FOREIGN KEY ([AddressID]) REFERENCES [dbo].[Addresses] ([AddressID])
GO

ALTER TABLE [dbo].[Orders]
  ADD FOREIGN KEY ([PromotionID]) REFERENCES [dbo].[Promotions] ([PromotionID])
GO

ALTER TABLE [dbo].[Orders]
  ADD FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO