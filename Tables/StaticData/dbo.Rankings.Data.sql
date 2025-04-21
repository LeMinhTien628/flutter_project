SET IDENTITY_INSERT dbo.Rankings ON
GO
INSERT dbo.Rankings(RankingID, ProductID, AverageRating, RankPosition, Period, CreatedDate) VALUES (1, 1, 4.80, 1, N'Weekly', '2025-04-07 00:00:00.000');
INSERT dbo.Rankings(RankingID, ProductID, AverageRating, RankPosition, Period, CreatedDate) VALUES (2, 2, 4.60, 2, N'Weekly', '2025-04-07 00:00:00.000');
INSERT dbo.Rankings(RankingID, ProductID, AverageRating, RankPosition, Period, CreatedDate) VALUES (3, 1, 4.75, 1, N'Monthly', '2025-04-01 00:00:00.000');
INSERT dbo.Rankings(RankingID, ProductID, AverageRating, RankPosition, Period, CreatedDate) VALUES (4, 2, 4.55, 2, N'Monthly', '2025-04-01 00:00:00.000');
GO
SET IDENTITY_INSERT dbo.Rankings OFF
GO