CREATE TABLE [dbo].[Users] (
  [UserID] [int] IDENTITY,
  [Username] [nvarchar](50) NOT NULL,
  [Email] [nvarchar](100) NOT NULL,
  [Phone] [nvarchar](15) NOT NULL,
  [PasswordHash] [nvarchar](255) NOT NULL,
  [ProfilePicture] [nvarchar](255) NULL,
  [CreatedDate] [datetime] NOT NULL DEFAULT (getdate()),
  PRIMARY KEY CLUSTERED ([UserID]),
  UNIQUE ([Username]),
  UNIQUE ([Phone]),
  UNIQUE ([Email])
)
ON [PRIMARY]
GO