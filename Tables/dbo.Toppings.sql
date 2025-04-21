CREATE TABLE [dbo].[Toppings] (
  [ToppingID] [int] IDENTITY,
  [ToppingName] [nvarchar](50) NOT NULL,
  [Price] [decimal](18, 2) NOT NULL,
  [ProductID] [int] NOT NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([ToppingID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Toppings]
  ADD FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
GO