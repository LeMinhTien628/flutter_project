SET IDENTITY_INSERT dbo.Suggestions ON
GO
INSERT dbo.Suggestions(SuggestionID, ProductID, SuggestedProductID, Confidence, CreatedDate) VALUES (1, 1, 2, 75.00, '2025-04-01 00:00:00.000');
INSERT dbo.Suggestions(SuggestionID, ProductID, SuggestedProductID, Confidence, CreatedDate) VALUES (2, 1, 55, 60.00, '2025-04-01 00:00:00.000');
INSERT dbo.Suggestions(SuggestionID, ProductID, SuggestedProductID, Confidence, CreatedDate) VALUES (3, 2, 3, 65.00, '2025-04-01 00:00:00.000');
INSERT dbo.Suggestions(SuggestionID, ProductID, SuggestedProductID, Confidence, CreatedDate) VALUES (4, 37, 1, 50.00, '2025-04-02 00:00:00.000');
GO
SET IDENTITY_INSERT dbo.Suggestions OFF
GO