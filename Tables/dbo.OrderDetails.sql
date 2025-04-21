CREATE TABLE [dbo].[OrderDetails] (
  [OrderDetailID] [int] IDENTITY,
  [OrderID] [int] NOT NULL,
  [ProductID] [int] NOT NULL,
  [Quantity] [int] NOT NULL,
  [Size] [nvarchar](10) NULL,
  [CrustType] [nvarchar](50) NULL,
  [UnitPrice] [decimal](18, 2) NOT NULL,
  [ToppingID] [int] NULL,
  [ToppingPrice] [decimal](18, 2) NOT NULL DEFAULT (0),
  PRIMARY KEY CLUSTERED ([OrderDetailID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[OrderDetails]
  ADD FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID])
GO

ALTER TABLE [dbo].[OrderDetails]
  ADD FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO

ALTER TABLE [dbo].[OrderDetails]
  ADD FOREIGN KEY ([ToppingID]) REFERENCES [dbo].[Toppings] ([ToppingID])
GO