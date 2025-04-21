CREATE TABLE [dbo].[Feedbacks] (
  [FeedbackID] [int] IDENTITY,
  [OrderID] [int] NOT NULL,
  [UserID] [int] NOT NULL,
  [CrustRating] [tinyint] NOT NULL,
  [SauceRating] [tinyint] NOT NULL,
  [CheeseRating] [tinyint] NOT NULL,
  [ToppingRating] [tinyint] NOT NULL,
  [OverallTasteRating] [tinyint] NOT NULL,
  [PresentationRating] [tinyint] NOT NULL,
  [ServiceRating] [tinyint] NOT NULL,
  [Comment] [nvarchar](500) NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([FeedbackID]),
  CONSTRAINT [CK_Feedbacks_CheeseRating] CHECK ([CheeseRating]>=(1) AND [CheeseRating]<=(5)),
  CONSTRAINT [CK_Feedbacks_CrustRating] CHECK ([CrustRating]>=(1) AND [CrustRating]<=(5)),
  CONSTRAINT [CK_Feedbacks_OverallTasteRating] CHECK ([OverallTasteRating]>=(1) AND [OverallTasteRating]<=(5)),
  CONSTRAINT [CK_Feedbacks_PresentationRating] CHECK ([PresentationRating]>=(1) AND [PresentationRating]<=(5)),
  CONSTRAINT [CK_Feedbacks_SauceRating] CHECK ([SauceRating]>=(1) AND [SauceRating]<=(5)),
  CONSTRAINT [CK_Feedbacks_ServiceRating] CHECK ([ServiceRating]>=(1) AND [ServiceRating]<=(5)),
  CONSTRAINT [CK_Feedbacks_ToppingRating] CHECK ([ToppingRating]>=(1) AND [ToppingRating]<=(5))
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Feedbacks]
  ADD FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID])
GO

ALTER TABLE [dbo].[Feedbacks]
  ADD FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO