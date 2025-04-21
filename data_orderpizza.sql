-- =============================================
-- BÔI ĐEN NHẤN CHẠY LÀ CHẠY ĐƯỢC
-- KHI SỬA DỮ LIỆU CHỨ BÔI ĐEN LÀ CẬP NHẬP LẠI KHÔNG CẦN XÓA DATABASE VÌ ĐÃ CÓ LỆNH
-- =============================================
USE master
GO
IF DB_ID('PizzaOrderDB') IS NOT NULL
  DROP DATABASE PizzaOrderDB;
GO

-- =============================================
-- 1. TẠO DATABASE VÀ CHUYỂN CONTEXT
-- =============================================
CREATE DATABASE PizzaOrderDB;
GO
USE PizzaOrderDB;
GO

-- =============================================
-- 2. BẢNG CATEGORIES & SUBCATEGORIES
-- =============================================
CREATE TABLE Categories (
    CategoryID    INT           PRIMARY KEY IDENTITY(1,1),
    CategoryName  NVARCHAR(100) NOT NULL UNIQUE,
    CreatedDate   DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE SubCategories (
    SubCategoryID   INT           PRIMARY KEY IDENTITY(1,1),
    CategoryID      INT           NOT NULL,
    SubCategoryName NVARCHAR(100) NOT NULL,
    CreatedDate     DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- =============================================
-- 3. BẢNG USERS & ADDRESSES
-- =============================================
CREATE TABLE Users (
    UserID         INT           PRIMARY KEY IDENTITY(1,1),
    Username       NVARCHAR(50)  NOT NULL UNIQUE,
    Email          NVARCHAR(100) NOT NULL UNIQUE,
    Phone          NVARCHAR(15)  NOT NULL UNIQUE,
    PasswordHash   NVARCHAR(255) NOT NULL,
    ProfilePicture NVARCHAR(255) NULL,
    CreatedDate    DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Addresses (
    AddressID    INT           PRIMARY KEY IDENTITY(1,1),
    UserID       INT           NOT NULL,
    AddressName  NVARCHAR(255) NOT NULL,
    IsDefault    BIT           NOT NULL DEFAULT 0,
    CreatedDate  DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- =============================================
-- 4. BẢNG PRODUCTS & TOPPINGS
-- =============================================
CREATE TABLE Products (
    ProductID     INT           PRIMARY KEY IDENTITY(1,1),
    ProductName   NVARCHAR(100) NOT NULL,
    Description   NVARCHAR(MAX) NULL,
    Price         DECIMAL(18,2) NOT NULL,
    CategoryID    INT           NOT NULL,
    SubCategoryID INT           NULL,
    ImageURL      NVARCHAR(255) NULL,
    CreatedDate   DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID)    REFERENCES Categories(CategoryID),
    FOREIGN KEY (SubCategoryID) REFERENCES SubCategories(SubCategoryID)
);
GO

CREATE TABLE Toppings (
    ToppingID    INT           PRIMARY KEY IDENTITY(1,1),
    ToppingName  NVARCHAR(50)  NOT NULL,
    Price        DECIMAL(18,2) NOT NULL,
    ProductID    INT           NOT NULL,
    CreatedDate  DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- =============================================
-- 5. BẢNG PROMOTIONS & PROMOTIONPRODUCTS
-- =============================================
CREATE TABLE Promotions (
    PromotionID        INT           PRIMARY KEY IDENTITY(1,1),
    PromotionName      NVARCHAR(100) NOT NULL,
    Description        NVARCHAR(255) NULL,
    DiscountPercentage DECIMAL(5,2)  NULL,
	ImageURL		   NVARCHAR(255) NULL,
    StartDate          DATETIME      NOT NULL,
    EndDate            DATETIME      NOT NULL,
    CreatedDate        DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE PromotionProducts (
    PromotionProductID INT PRIMARY KEY IDENTITY(1,1),
    PromotionID        INT NOT NULL,
    ProductID          INT NOT NULL,
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (ProductID)   REFERENCES Products(ProductID)
);
GO

-- =============================================
-- 6. BẢNG ORDERS & ORDERDETAILS
-- =============================================
CREATE TABLE Orders (
    OrderID        INT           PRIMARY KEY IDENTITY(1,1),
    UserID         INT           NOT NULL,
    AddressID      INT           NULL,
    OrderDate      DATETIME      NOT NULL DEFAULT GETDATE(),
    TotalAmount    DECIMAL(18,2) NOT NULL,
    Status         NVARCHAR(50)  NOT NULL,
    PaymentMethod  NVARCHAR(50)  NOT NULL,
    ShippingFee    DECIMAL(18,2) NOT NULL DEFAULT 0,
    PromotionID    INT           NULL,
    CreatedDate    DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID)      REFERENCES Users(UserID),
    FOREIGN KEY (AddressID)   REFERENCES Addresses(AddressID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID)
);
GO

CREATE TABLE OrderDetails (
    OrderDetailID INT           PRIMARY KEY IDENTITY(1,1),
    OrderID       INT           NOT NULL,
    ProductID     INT           NOT NULL,
    Quantity      INT           NOT NULL,
    Size          NVARCHAR(10)  NULL,
    CrustType     NVARCHAR(50)  NULL,
    UnitPrice     DECIMAL(18,2) NOT NULL,
    ToppingID     INT           NULL,
    ToppingPrice  DECIMAL(18,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (ToppingID) REFERENCES Toppings(ToppingID)
);
GO

-- =============================================
-- 7. BẢNG FEEDBACKS
-- =============================================
CREATE TABLE Feedbacks (
    FeedbackID            INT           PRIMARY KEY IDENTITY(1,1),
    OrderID               INT           NOT NULL,
    UserID                INT           NOT NULL,
    CrustRating           TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_CrustRating       CHECK (CrustRating BETWEEN 1 AND 5),
    SauceRating           TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_SauceRating       CHECK (SauceRating BETWEEN 1 AND 5),
    CheeseRating          TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_CheeseRating      CHECK (CheeseRating BETWEEN 1 AND 5),
    ToppingRating         TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_ToppingRating     CHECK (ToppingRating BETWEEN 1 AND 5),
    OverallTasteRating    TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_OverallTasteRating CHECK (OverallTasteRating BETWEEN 1 AND 5),
    PresentationRating    TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_PresentationRating CHECK (PresentationRating BETWEEN 1 AND 5),
    ServiceRating		  TINYINT       NOT NULL CONSTRAINT CK_Feedbacks_ServiceRating      CHECK (ServiceRating BETWEEN 1 AND 5),
    Comment               NVARCHAR(500) NULL,
    CreatedDate			  DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (UserID)  REFERENCES Users(UserID)
);
GO

-- =============================================
-- 8. BẢNG SUGGESTIONS & RANKINGS
-- =============================================
CREATE TABLE Suggestions (
    SuggestionID       INT           PRIMARY KEY IDENTITY(1,1),
    ProductID          INT           NOT NULL,
    SuggestedProductID INT           NOT NULL,
    Confidence         DECIMAL(5,2)  NOT NULL,
    CreatedDate        DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ProductID)          REFERENCES Products(ProductID),
    FOREIGN KEY (SuggestedProductID) REFERENCES Products(ProductID)
);
GO

CREATE TABLE Rankings (
    RankingID     INT           PRIMARY KEY IDENTITY(1,1),
    ProductID     INT           NOT NULL,
    AverageRating DECIMAL(3,2)  NOT NULL,
    RankPosition  INT           NOT NULL,
    Period        NVARCHAR(20)  NOT NULL CONSTRAINT CK_Rankings_Period CHECK (Period IN ('Weekly','Monthly')),
    CreatedDate   DATETIME      NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- =============================================
-- 9. DML: Thêm dữ liệu mẫu, theo thứ tự tránh FK lỗi
-- =============================================

-- 9.1 Categories
INSERT INTO Categories (CategoryName, CreatedDate) VALUES
  (N'Pizza',        '2025-01-01 08:00:00'),
  (N'Gà',			'2025-01-01 08:00:00'),
  (N'Mỳ Ý',			'2025-01-01 08:00:00'),
  (N'Khai Vị',      '2025-01-01 08:00:00'),
  (N'Tráng Miệng',  '2025-01-01 08:00:00'),
  (N'Thức Uống',    '2025-01-01 08:00:00');
GO

-- 9.2 SubCategories
INSERT INTO SubCategories (CategoryID, SubCategoryName, CreatedDate) VALUES
  (1, N'SUPER TOPPTING',			'2025-01-01 08:00:00'),
  (1, N'SEAFOOD CRAVERS',			'2025-01-01 08:00:00'),
  (1, N'KID FAVORS',				'2025-01-01 08:00:00'),
  (1, N'TRADITION & MEAT LOVERS',   '2025-01-01 08:00:00'),
  (4, N'XÚC XÍCH',					'2025-01-01 08:00:00'),
  (4, N'BÁNH MÌ',					'2025-01-01 08:00:00'),
  (4, N'KHOAI TÂY',					'2025-01-01 08:00:00');
GO

-- 9.3 Users
INSERT INTO Users (Username, Email, Phone, PasswordHash, ProfilePicture, CreatedDate)
VALUES
    (N'Nguyễn Văn Hùng', N'nguyenvanhung1990@gmail.com', N'0901234567', N'hash1', NULL, '2025-01-01 08:00:00'),
    (N'Trần Thị Mai', N'tranthimai92@yahoo.com', N'0935678901', N'hash2', NULL, '2025-01-02 09:15:00'),
    (N'Phạm Minh Tuấn', N'phamminhtuan88@outlook.com', N'0987654321', N'hash3', NULL, '2025-01-03 10:30:00'),
    (N'Lê Hồng Nhung', N'lehongnhung95@gmail.com', N'0912345678', N'hash4', NULL, '2025-01-04 11:45:00'),
    (N'Hoàng Quốc Anh', N'hoangquocanh87@gmail.com', N'0967890123', N'hash5', NULL, '2025-01-05 13:00:00'),
    (N'Vũ Thị Lan', N'vuthilan93@yahoo.com', N'0329876543', N'hash6', NULL, '2025-01-06 14:20:00'),
    (N'Đỗ Văn Nam', N'dovannam89@outlook.com', N'0341234567', N'hash7', NULL, '2025-01-07 15:40:00'),
    (N'Bùi Thanh Tâm', N'buithanhtam94@gmail.com', N'0974567890', N'hash8', NULL, '2025-01-08 17:00:00'),
    (N'Ngô Thị Hà', N'ngothiha91@gmail.com', N'0943210987', N'hash9', NULL, '2025-01-09 18:25:00'),
    (N'Tạ Minh Đức', N'taminhduc90@yahoo.com', N'0336789012', N'hash10', NULL, '2025-01-10 19:50:00'),
    (N'Nguyễn Thị Linh', N'nguyenthilinh89@gmail.com', N'0908765432', N'hash11', NULL, '2025-01-11 08:10:00'),
    (N'Trần Văn Long', N'tranvanlong91@yahoo.com', N'0931234567', N'hash12', NULL, '2025-01-12 09:30:00'),
    (N'Phạm Thị Ngọc', N'phamthingoc93@outlook.com', N'0982345678', N'hash13', NULL, '2025-01-13 10:45:00'),
    (N'Lê Văn Khánh', N'levankhanh87@gmail.com', N'0913456789', N'hash14', NULL, '2025-01-14 12:00:00'),
    (N'Hoàng Thị Thu', N'hoangthithu95@yahoo.com', N'0964567890', N'hash15', NULL, '2025-01-15 13:15:00'),
    (N'Vũ Minh Châu', N'vuminhchau88@gmail.com', N'0326789012', N'hash16', NULL, '2025-01-16 14:30:00'),
    (N'Đỗ Thị Hương', N'dothihuong94@outlook.com', N'0347890123', N'hash17', NULL, '2025-01-17 15:50:00'),
    (N'Bùi Văn Quang', N'buivanquang90@gmail.com', N'0971234567', N'hash18', NULL, '2025-01-18 17:10:00'),
    (N'Ngô Minh Hiếu', N'ngominhhieu92@yahoo.com', N'0945678901', N'hash19', NULL, '2025-01-19 18:35:00'),
    (N'Tạ Thị Phương', N'tathiphuong89@gmail.com', N'0332345678', N'hash20', NULL, '2025-01-20 19:55:00'),
    (N'Nguyễn Văn Dũng', N'nguyenvandung87@outlook.com', N'0904567890', N'hash21', NULL, '2025-01-21 08:20:00'),
    (N'Trần Thị Bích', N'tranthibich91@gmail.com', N'0937890123', N'hash22', NULL, '2025-01-22 09:40:00'),
    (N'Phạm Văn Huy', N'phamvanhuy94@yahoo.com', N'0981234567', N'hash23', NULL, '2025-01-23 11:00:00'),
    (N'Lê Thị Oanh', N'lethioanh88@gmail.com', N'0916789012', N'hash24', NULL, '2025-01-24 12:25:00'),
    (N'Hoàng Văn Phong', N'hoangvanphong90@outlook.com', N'0962345678', N'hash25', NULL, '2025-01-25 13:45:00');
GO

-- 9.4 Addresses
INSERT INTO Addresses (UserID, AddressName, IsDefault, CreatedDate)
VALUES
    -- UserID 1
    (1, N'123 Nguyễn Trãi, Quận 5, TP.HCM', 1, '2025-01-01 08:00:00'),
    (1, N'456 Lê Văn Sỹ, Quận 3, TP.HCM', 0, '2025-01-02 09:30:00'),
    -- UserID 2
    (2, N'789 Phạm Văn Đồng, TP. Thủ Đức, TP.HCM', 1, '2025-01-03 10:15:00'),
    (2, N'101 Trần Hưng Đạo, Quận 1, TP.HCM', 0, '2025-01-04 11:45:00'),
    -- UserID 3
    (3, N'202 Nguyễn Thị Thập, Quận 7, TP.HCM', 1, '2025-01-05 14:20:00'),
    (3, N'333 Cách Mạng Tháng Tám, Quận 10, TP.HCM', 0, '2025-01-06 15:00:00'),
    -- UserID 4
    (4, N'444 Hai Bà Trưng, Quận 3, TP.HCM', 1, '2025-01-07 16:30:00'),
    -- UserID 5
    (5, N'555 Tôn Đức Thắng, Quận 1, TP.HCM', 1, '2025-01-08 08:45:00'),
    (5, N'666 Nguyễn Đình Chiểu, Quận 3, TP.HCM', 0, '2025-01-09 10:00:00'),
    -- UserID 6
    (6, N'777 Lê Lợi, Quận 1, TP.HCM', 1, '2025-01-10 11:15:00'),
    (6, N'888 Trường Chinh, Quận Tân Bình, TP.HCM', 0, '2025-01-11 12:30:00'),
    -- UserID 7
    (7, N'999 Lý Thường Kiệt, Quận Tân Bình, TP.HCM', 1, '2025-01-12 13:45:00'),
    -- UserID 8
    (8, N'101 Ba Đình, Quận Hoàn Kiếm, Hà Nội', 1, '2025-01-13 15:00:00'),
    (8, N'202 Hàng Bông, Quận Hoàn Kiếm, Hà Nội', 0, '2025-01-14 16:15:00'),
    -- UserID 9
    (9, N'303 Tây Hồ, Quận Tây Hồ, Hà Nội', 1, '2025-01-15 17:30:00'),
    (9, N'404 Nguyễn Trãi, Quận Thanh Xuân, Hà Nội', 0, '2025-01-16 18:45:00'),
    -- UserID 10
    (10, N'505 Giải Phóng, Quận Hoàng Mai, Hà Nội', 1, '2025-01-17 08:00:00'),
    -- UserID 11
    (11, N'606 Trần Phú, Quận Hải Châu, Đà Nẵng', 1, '2025-01-18 09:15:00'),
    (11, N'707 Nguyễn Văn Linh, Quận Thanh Khê, Đà Nẵng', 0, '2025-01-19 10:30:00'),
    -- UserID 12
    (12, N'808 Lê Duẩn, Quận Hải Châu, Đà Nẵng', 1, '2025-01-20 11:45:00'),
    (12, N'909 Ông Ích Khiêm, Quận Thanh Khê, Đà Nẵng', 0, '2025-01-21 13:00:00'),
    -- UserID 13
    (13, N'101 Trần Phú, TP. Cần Thơ', 1, '2025-01-22 14:15:00'),
    -- UserID 14
    (14, N'202 Nguyễn An Ninh, Quận Ninh Kiều, Cần Thơ', 1, '2025-01-23 15:30:00'),
    (14, N'303 Mậu Thân, Quận Ninh Kiều, Cần Thơ', 0, '2025-01-24 16:45:00'),
    -- UserID 15
    (15, N'404 Lạch Tray, Quận Ngô Quyền, Hải Phòng', 1, '2025-01-25 18:00:00'),
    (15, N'505 Lê Hồng Phong, Quận Hải An, Hải Phòng', 0, '2025-01-26 19:15:00'),
    -- UserID 16
    (16, N'606 Nguyễn Văn Cừ, Quận Long Biên, Hà Nội', 1, '2025-01-27 08:30:00'),
    -- UserID 17
    (17, N'707 Âu Cơ, Quận Tây Hồ, Hà Nội', 1, '2025-01-28 09:45:00'),
    (17, N'808 Kim Mã, Quận Ba Đình, Hà Nội', 0, '2025-01-29 11:00:00'),
    -- UserID 18
    (18, N'909 Nguyễn Hữu Thọ, Quận 7, TP.HCM', 1, '2025-01-30 12:15:00'),
    (18, N'101 Lê Văn Chí, TP. Thủ Đức, TP.HCM', 0, '2025-01-31 13:30:00'),
    -- UserID 19
    (19, N'202 Võ Văn Tần, Quận 3, TP.HCM', 1, '2025-02-01 14:45:00'),
    -- UserID 20
    (20, N'303 Nguyễn Thái Học, Quận 1, TP.HCM', 1, '2025-02-02 16:00:00'),
    (20, N'404 Điện Biên Phủ, Quận Bình Thạnh, TP.HCM', 0, '2025-02-03 17:15:00'),
    -- UserID 21
    (21, N'505 Cộng Hòa, Quận Tân Bình, TP.HCM', 1, '2025-02-04 18:30:00'),
    (21, N'606 Lê Quang Định, Quận Bình Thạnh, TP.HCM', 0, '2025-02-05 19:45:00'),
    -- UserID 22
    (22, N'707 Nguyễn Văn Trỗi, Quận Phú Nhuận, TP.HCM', 1, '2025-02-06 08:00:00'),
    -- UserID 23
    (23, N'808 Bạch Đằng, Quận Hai Bà Trưng, Hà Nội', 1, '2025-02-07 09:15:00'),
    (23, N'909 Láng, Quận Đống Đa, Hà Nội', 0, '2025-02-08 10:30:00'),
    -- UserID 24
    (24, N'101 Nguyễn Huệ, Quận 1, TP.HCM', 1, '2025-02-09 11:45:00'),
    (24, N'202 Xô Viết Nghệ Tĩnh, Quận Bình Thạnh, TP.HCM', 0, '2025-02-10 13:00:00'),
    -- UserID 25
    (25, N'303 Lê Đại Hành, Quận 11, TP.HCM', 1, '2025-02-11 14:15:00');
GO

-- 9.5 Products
DECLARE 
    -- Pizza
    @PizzaSieuToppingHaiSan4Mua NVARCHAR(MAX) = N'Tăng 50% Tôm Có Đuôi, Mực Khoanh; Thêm Phô Mai Mozzarella, Xốt Pesto Kem Chanh, Xốt Kim Quất, Xốt Vải, Xốt Xoài, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh',
    @PizzaSieuToppingHaiSanPestoChanh NVARCHAR(MAX) = N'Tăng 50% Mực Khoanh, Tôm Có Đuôi; Thêm Phô Mai Mozzarella, Cà Chua, Hành Tây, Xốt Pesto, Xốt Chanh, Parsley',
    @PizzaSieuToppingBoGoMy NVARCHAR(MAX) = N'Tăng 50% Thịt Bò Bơ Gơ Nhập Khẩu, Thịt Heo Xông Khói; Thêm Xốt Phô Mai, Xốt Mayonnaise, Phô Mai Mozzarella, Phô Mai Cheddar, Cà Chua, Hành Tây, Nấm',
    @PizzaSieuToppingHaiSanMayonnaise NVARCHAR(MAX) = N'Tăng 50% Tôm, Mực, Thanh Cua; Thêm Phô Mai Mozzarella, Xốt Mayonnaise, Húng Tây, Hành',
    @PizzaSieuToppingHaiSanTieuDen NVARCHAR(MAX) = N'Tăng 50% Tôm, Mực; Thêm Phô Mai Mozzarella, Phô Mai Cheddar, Thơm, Hành Tây, Xốt Mayonnaise, Xốt Tiêu Đen',
    @PizzaSieuToppingBoMexico NVARCHAR(MAX) = N'Tăng 50% Tôm, Thịt Bò Mexico; Thêm Phô Mai Mozzarella, Cà Chua, Hành, Xốt Cà Chua, Xốt Mayonnaise, Xốt Phô Mai',
    @PizzaSieuToppingDamBongDua NVARCHAR(MAX) = N'Tăng 50% Thịt Dăm Bông; Thêm Phô Mai Mozzarella, Dứa, Xốt Mayonnaise, Xốt Cà Chua',
    @PizzaSieuToppingXucXichPepperoni NVARCHAR(MAX) = N'Tăng 50% Xúc Xích Pepperoni; Thêm Phô Mai Mozzarella, Xốt Cà Chua',
    @PizzaPhoMaiPestoKemChanh NVARCHAR(MAX) = N'Phô Mai Mozzarella, Xốt Pesto Kem Chanh, Xốt Kim Quất, Xốt Vải, Xốt Xoài, Tôm Có Đuôi, Mực Khoanh, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh',
    @PizzaPhoMaiKimQuat NVARCHAR(MAX) = N'Phô Mai Mozzarella, Xốt Kim Quất, Tôm Có Đuôi, Mực Khoanh, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh',
    @PizzaPhoMaiVai NVARCHAR(MAX) = N'Phô Mai Mozzarella, Xốt Vải, Tôm Có Đuôi, Mực Khoanh, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh',
    @PizzaPhoMaiXoai NVARCHAR(MAX) = N'Phô Mai Mozzarella, Xốt Xoài, Tôm Có Đuôi, Mực Khoanh, Hành Tây, Cà Chua, Lá Mùi Tây, Xốt Bơ Tỏi Viền Bánh',
    @PizzaMucTomPestoChanh NVARCHAR(MAX) = N'Mực Khoanh, Tôm Có Đuôi, Phô Mai Mozzarella, Cà Chua, Hành Tây, Xốt Pesto, Xốt Chanh, Parsley',
    @PizzaMayonnaiseHaiSan NVARCHAR(MAX) = N'Xốt Mayonnaise, Phô Mai Mozzarella, Tôm, Mực, Thanh Cua, Hành Tây',
    @PizzaCaChuaBoMexico NVARCHAR(MAX) = N'Xốt Cà Chua, Xốt Phô Mai, Phô Mai Mozzarella, Tôm, Thịt Bò Mexico, Cà Chua, Hành Tây',
    @PizzaCaChuaHaiSan NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella, Tôm, Mực, Thanh Cua, Hành Tây',
    @PizzaTieuDenHaiSan NVARCHAR(MAX) = N'Xốt Tiêu Đen, Phô Mai Mozzarella, Phô Mai Cheddar, Thơm, Hành Tây, Tôm, Mực',
    @PizzaMayonnaiseThanhCuaDua NVARCHAR(MAX) = N'Xốt Mayonnaise, Phô Mai Mozzarella, Thanh Cua, Dứa',
    @PizzaPhoMaiDamBongXongKhoi NVARCHAR(MAX) = N'Xốt Phô Mai, Phô Mai Mozzarella, Thịt Dăm Bông, Thịt Xông Khói, Bắp',
    @PizzaPhoMaiXucXichXongKhoi NVARCHAR(MAX) = N'Xốt Phô Mai, Phô Mai Mozzarella, Xúc Xích, Thịt Heo Xông Khói, Bắp, Thơm',
    @PizzaPhoMaiGaVienXongKhoi NVARCHAR(MAX) = N'Xốt Phô Mai, Gà Viên, Thịt Heo Xông Khói, Phô Mai Mozzarella, Cà Chua',
    @PizzaPhoMaiHaoHang NVARCHAR(MAX) = N'Phô Mai Cheddar, Phô Mai Mozzarella, Phô Mai Xanh Viên, Viền Phô Mai, Xốt Phô Mai Và Phục Vụ Cùng Mật Ong',
    @PizzaBoGoXongKhoi NVARCHAR(MAX) = N'Thịt Bò Bơ Gơ Nhập Khẩu, Thịt Heo Xông Khói, Xốt Phô Mai, Xốt Mayonnaise, Phô Mai Mozzarella, Phô Mai Cheddar, Cà Chua, Hành Tây, Nấm',
    @PizzaThapCamThit NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella, Xúc Xích Pepperoni, Thịt Dăm Bông, Xúc Xích Ý, Thịt Bò Nướng, Nấm Mỡ, Hành Tây, Ô-liu',
    @PizzaRauCuThapCam NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella, Hành Tây, Ớt Chuông Xanh, Ô-liu, Nấm Mỡ, Cà Chua, Thơm',
    @PizzaNamLoaiThit NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella, Xúc Xích Pepperoni, Thịt Dăm Bông, Xúc Xích Ý, Thịt Heo Xông Khói',
    @PizzaXucXichPepperoni NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella, Xúc Xích Pepperoni',
    @PizzaDamBongDuaHawaii NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella, Thịt Dăm Bông, Thơm',
    @PizzaPhoMaiTruyenThong NVARCHAR(MAX) = N'Xốt Cà Chua, Phô Mai Mozzarella',

    -- Gà
    @GaVienPopcornXongKhoi NVARCHAR(MAX) = N'Gà Viên Popcorn, Thịt Heo Xông Khói, Phô Mai Mozzarella, Xốt Pizza',
    @GaPopcornDuaCaChua NVARCHAR(MAX) = N'Gà Popcorn, Dứa, Cà Chua, Mè, Xốt Hàn Quốc',
	@GaPopcornSotMayo NVARCHAR(MAX) = N'Gà Popcorn, Khoai, Dăm bông, Xốt Mayone, Xốt BBQ',
    @CanhGaXotHanQuoc NVARCHAR(MAX) = N'Cánh Gà, Xốt Hàn Quốc',
    @CanhGaXotBBQ NVARCHAR(MAX) = N'Cánh Gà, Xốt BBQ',

    -- Mỳ Ý
    @MyYCarbonaraXongKhoi NVARCHAR(MAX) = N'Mỳ Ý, Xốt Carbonara, Thịt Xông Khói, Bột Rong Biển, Bột Tỏi',
    @MyYBoBamMarinara NVARCHAR(MAX) = N'Mỳ Ý, Xốt Bò Bằm, Bột Rong Biển, Bột Tỏi',
    @MyYHaiSanPesto NVARCHAR(MAX) = N'Mỳ Ý, Hành Tây, Mực Khoanh, Tôm Có Đuôi, Xốt Pesto, Bột Rong Biển, Bột Tỏi',
    @MyYXucXichMarinara NVARCHAR(MAX) = N'Mỳ Ý, Xúc Xích Parsley, Thịt Xông Khói, Xúc Xích Pepperoni, Xốt Marinara, Bột Rong Biển, Bột Tỏi',
    @MyYTomMarinaraCay NVARCHAR(MAX) = N'Mỳ Ý, Hành Tây, Tôm, Xốt Marinara, Ớt Vẩy, Bột Rong Biển, Bột Tỏi',
    @MyYXongKhoiMarinaraCay NVARCHAR(MAX) = N'Mỳ Ý, Thịt Xông Khói, Thịt Xông Khói Miếng, Xốt Marinara, Ớt Vẩy, Bột Rong Biển, Bột Tỏi',
    @MyYRauCuMarinara NVARCHAR(MAX) = N'Mỳ Ý, Ớt Chuông Xanh, Nấm, Cà Chua, Dứa, Ô-Liu Đen, Xốt Marinara, Bột Rong Biển, Bột Tỏi',

    -- Khai Vị
    @XucXichXongKhoiBBQ1 NVARCHAR(MAX) = N'Xúc Xích Xông Khói, Xốt BBQ',
    @XucXichXongKhoiBBQ2 NVARCHAR(MAX) = N'Xúc Xích Xông Khói, Xốt BBQ',
    @PhoMaiQueBoToi NVARCHAR(MAX) = N'Bơ Thực Vật, Phô Mai Que, Lá Mùi Tây, Bột Tỏi',
    @XucXichParsleyBoToi NVARCHAR(MAX) = N'Bơ Thực Vật, Xúc Xích Parsley, Lá Mùi Tây, Bột Tỏi',
    @BanhMiBoXotPizza NVARCHAR(MAX) = N'Bánh Mì, Bơ, Bột Tỏi, Xốt Pizza',
    @BanhMiPhoMaiXotPizza NVARCHAR(MAX) = N'Bánh Mì, Bơ, Phô Mai, Bột Tỏi, Xốt Pizza',
    @KhoaiTayXongKhoiPhoMai NVARCHAR(MAX) = N'Khoai Tây, Thịt Heo Xông Khói, Phô Mai',

    -- Tráng Miệng
    @PhoMaiQueSoCoLa NVARCHAR(MAX) = N'Phô Mai Que, Bơ Thực Vật, Xốt Sô-Cô-La Đen',
    @PhoMaiQueXoaiMatOng NVARCHAR(MAX) = N'Phô Mai Que, Bơ Thực Vật, Xốt Xoài, Mật Ong',
    @BanhCuonSoCoLaChip NVARCHAR(MAX) = N'Bánh Cuộn Mềm Xốp, Sô-Cô-La Chip Đen Và Trắng, Xốt Sô-Cô-La Đen',
    @BanhSoCoLaNguyenChat NVARCHAR(MAX) = N'Bánh Sô-Cô-La Nguyên Chất';

-- Chèn dữ liệu vào bảng Products với Description từ các biến
INSERT INTO Products (ProductName, Description, Price, CategoryID, SubCategoryID, ImageURL, CreatedDate) 
VALUES
    -- Pizza
    (N'Pizza Siêu Topping Hải Sản 4 Mùa',					 @PizzaSieuToppingHaiSan4Mua,		 150000, 1, 1, 'PizzaSieuToppingHaiSan4Mua.png',		'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Hải Sản Xốt Pesto "Chanh Sả"',	 @PizzaSieuToppingHaiSanPestoChanh,	 150000, 1, 1, 'PizzaSieuToppingPestoKemChanh.png',		'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Bơ Gơ Bò Mỹ Xốt Phô Mai Ngập Vị',	 @PizzaSieuToppingBoGoMy,			 150000, 1, 1, 'PizzaSieuToppingBoGoMy.png.jpg',		'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Hải Sản Xốt Mayonnaise',			 @PizzaSieuToppingHaiSanMayonnaise,	 150000, 1, 1, 'PizzaSieuToppingHaiSanMayonnaise.png',	'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Hải Sản Nhiệt Đới Xốt Tiêu',		 @PizzaSieuToppingHaiSanTieuDen,	 150000, 1, 1, 'PizzaSieuToppingHaiSanTieuDen.png',		'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Bò Và Tôm Nướng Kiểu Mỹ',			 @PizzaSieuToppingBoMexico,			 150000, 1, 1, 'PizzaSieuToppingBoMexico.png',			'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Dăm Bông Dứa Kiểu Hawaiian',	     @PizzaSieuToppingDamBongDua,		 150000, 1, 1, 'PizzaSieuToppingDamBongDua.png',		'2025-01-01 08:00:00'),
    (N'Pizza Siêu Topping Xúc Xích Ý Truyền Thống',			 @PizzaSieuToppingXucXichPepperoni,	 150000, 1, 1, 'PizzaSieuToppingXucXichPepperoni.png',	'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản 4 Mùa',								 @PizzaPhoMaiPestoKemChanh,			 150000, 1, 2, 'PizzaHaiSan4Mua.png.jpg',				'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Xốt Kim Quất',							 @PizzaPhoMaiKimQuat,				 150000, 1, 2, 'PizzaPhoMaiKimQuat.png',				'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Xốt Vải',								 @PizzaPhoMaiVai,					 150000, 1, 2, 'PizzaPhoMaiVai.png',					'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Xốt Xoài',								 @PizzaPhoMaiXoai,					 150000, 1, 2, 'PizzaPhoMaiXoai.png',					'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Xốt Pesto "Chanh Sả"',					 @PizzaMucTomPestoChanh,			 150000, 1, 2, 'PizzaMucTomPestoChanh.png',				'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Xốt Mayonnaise',						 @PizzaMayonnaiseHaiSan,			 150000, 1, 2, 'PizzaMayonnaiseHaiSan.png',				'2025-01-01 08:00:00'),
    (N'Pizza Bò & Tôm Nướng Kiểu Mỹ',						 @PizzaCaChuaBoMexico,				 150000, 1, 2, 'PizzaCaChuaBoMexico.png',				'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Xốt Cà Chua',							 @PizzaCaChuaHaiSan,				 150000, 1, 2, 'PizzaCaChuaHaiSan.png',					'2025-01-01 08:00:00'),
    (N'Pizza Hải Sản Nhiệt Đới Xốt Tiêu',					 @PizzaTieuDenHaiSan,				 150000, 1, 2, 'PizzaTieuDenHaiSan.png',				'2025-01-01 08:00:00'),
    (N'Pizza Thanh Cua Dứa Xốt Phô Mai',					 @PizzaMayonnaiseThanhCuaDua,		 150000, 1, 3, 'PizzaMayonnaiseThanhCuaDua.png',		'2025-01-01 08:00:00'),
    (N'Pizza Dăm Bông Bắp Xốt Phô Mai',						 @PizzaPhoMaiDamBongXongKhoi,		 150000, 1, 3, 'PizzaPhoMaiDamBongXongKhoi.png',		'2025-01-01 08:00:00'),
    (N'Pizza Xúc Xích Xốt Phô Mai',							 @PizzaPhoMaiXucXichXongKhoi,		 150000, 1, 3, 'PizzaPhoMaiXucXichXongKhoi.png',		'2025-01-01 08:00:00'),
    (N'Pizza Gà Phô Mai Thịt Heo Xông Khói',				 @PizzaPhoMaiGaVienXongKhoi,		 150000, 1, 3, 'PizzaPhoMaiGaVienXongKhoi.png',			'2025-01-01 08:00:00'),
    (N'Pizza Ngập Vị Phô Mai Hảo Hạng',						 @PizzaPhoMaiHaoHang,				 150000, 1, 4, 'PizzaPhoMaiHaoHang.png',				'2025-01-01 08:00:00'),
    (N'Pizza Thập Cẩm Thượng Hạng',							 @PizzaThapCamThit,					 150000, 1, 4, 'PizzaThapCamThit.png',					'2025-01-01 08:00:00'),
    (N'Pizza Rau Củ Thập Cẩm',								 @PizzaRauCuThapCam,				 150000, 1, 4, 'PizzaRauCuThapCam.png',					'2025-01-01 08:00:00'),
    (N'Pizza 5 Loại Thịt Thượng Hạng',						 @PizzaNamLoaiThit,					 150000, 1, 4, 'PizzaNamLoaiThit.png',					'2025-01-01 08:00:00'),
    (N'Pizza Dăm Bông Dứa Kiểu Hawaii',						 @PizzaDamBongDuaHawaii,			 150000, 1, 4, 'PizzaDamBongDuaHawaii.png',				'2025-01-01 08:00:00'),
    (N'Pizza Phô Mai Truyền Thống',							 @PizzaPhoMaiTruyenThong,			 150000, 1, 4, 'PizzaPhoMaiTruyenThong.png',			'2025-01-01 08:00:00'),
    -- Gà
    (N'Gà Viên Phô Mai Đút Lò',					@GaVienPopcornXongKhoi,		80000,	2,	NULL, 'GaVienPopcornXongKhoi.png',	'2025-01-01 08:00:00'),
    (N'Gà Viên Xốt Chua Ngọt Đút Lò',			@GaPopcornDuaCaChua,		80000,	2,	NULL, 'GaPopcornDuaCaChua.png',		'2025-01-01 08:00:00'),
    (N'Gà Viên Xốt BBQ Mayo Đút Lò',			@GaPopcornSotMayo,			80000,	2,	NULL, 'GaVienPopcornXongKhoi.png',	'2025-01-01 08:00:00'),
	(N'Cánh Gà Phủ Xốt Hàn Quốc (4 Miếng)',		@CanhGaXotHanQuoc,			80000,	2,	NULL, 'CanhGa4XotHanQuoc.png',		'2025-01-01 08:00:00'),
    (N'Cánh Gà Phủ Xốt Hàn Quốc (6 Miếng)',		@CanhGaXotHanQuoc,			80000,	2,	NULL, 'CanhGa6XotHanQuoc.png',		'2025-01-01 08:00:00'),
    (N'Cánh Gà Phủ Xốt BBQ Kiểu Mỹ (4 miếng)',	@CanhGaXotBBQ,				80000,	2,	NULL, 'CanhGa4XotBBQ.png',			'2025-01-01 08:00:00'),
    (N'Cánh Gà Phủ Xốt BBQ Kiểu Mỹ (6 Miếng)',	@CanhGaXotBBQ,				80000,	2,	NULL, 'CanhGa6XotBBQ.png',			'2025-01-01 08:00:00'),
    -- Mỳ Ý
    (N'Mỳ Ý Thịt Heo Xông Khói Xốt Kem',			@MyYCarbonaraXongKhoi,		90000,	3,	NULL, 'MyYCarbonaraXongKhoi.png',		'2025-01-01 08:00:00'),
    (N'Mỳ Ý Bò Bằm Xốt Marinara',					@MyYBoBamMarinara,			90000,	3,	NULL, 'MyYBoBamMarinara.png',			'2025-01-1 08:00:00'),
    (N'Mỳ Ý Hải Sản Xốt Pesto',						@MyYHaiSanPesto,			90000,	3,	NULL, 'MyYHaiSanPesto.png',				'2025-01-01 08:00:00'),
    (N'Mỳ Ý Xúc Xích Xốt Marinara',					@MyYXucXichMarinara,		90000,	3,	NULL, 'MyYXucXichMarinara.png',			'2025-01-01 08:00:00'),
    (N'Mỳ Ý Tôm Xốt Marinara Cay',					@MyYTomMarinaraCay,			90000,	3,	NULL, 'MyYTomMarinaraCay.png',			'2025-01-01 08:00:00'),
    (N'Mỳ Ý Thịt Heo Xông Khói Xốt Marinara Cay',	@MyYXongKhoiMarinaraCay,	90000,	3,	NULL, 'MyYXongKhoiMarinaraCay.png',		'2025-01-01 08:00:00'),
    (N'Mỳ Ý Rau Củ Xốt Marinara',					@MyYRauCuMarinara,			90000,	3,	NULL, 'MyYRauCuMarinara.png',			'2025-01-01 08:00:00'),
    -- Khai Vị
    (N'Xúc Xích Xông Khói Đút Lò (4 miếng)',	@XucXichXongKhoiBBQ1,		60000,	4,	5, 'XucXich4XongKhoiBBQ.png',		'2025-01-01 08:00:00'),
    (N'Xúc Xích Xông Khói Đút Lò (8 miếng)',	@XucXichXongKhoiBBQ2,		60000,	4,	5, 'XucXich8XongKhoiBBQ.png',		'2025-01-01 08:00:00'),
    (N'Bánh Sừng Bò Phô Mai (6 Miếng)',			@PhoMaiQueBoToi,			60000,	4,	6, 'PhoMaiQueBoToi.png',			'2025-01-01 08:00:00'),
    (N'Bánh Sừng Bò Xúc Xích (6 Miếng)',		@XucXichParsleyBoToi,		60000,	4,	6, 'XucXichParsleyBoToi.png',		'2025-01-01 08:00:00'),
    (N'Bánh Mì Nướng Bơ Tỏi',					@BanhMiBoXotPizza,			60000,	4,	6, 'BanhMiBoToi.png',				'2025-01-01 08:00:00'),
    (N'Bánh Mì Nướng Phô Mai',					@BanhMiPhoMaiXotPizza,		60000,	4,	6, 'BanhMiPhoMai.png',				'2025-01-01 08:00:00'),
    (N'Khoai Tây Phô Mai Đút Lò',				@KhoaiTayXongKhoiPhoMai,	60000,	4,	7, 'KhoaiTayXongKhoiPhoMai.png',	'2025-01-01 08:00:00'),
    -- Tráng Miệng
    (N'Bánh Phô Mai Xốt Sô-Cô-La',	@PhoMaiQueSoCoLa,		50000,	5,	NULL, 'PhoMaiQueXoaiMatOng.png',	'2025-01-01 08:00:00'),
    (N'Bánh Phô Mai Xốt Xoài',		@PhoMaiQueXoaiMatOng,	50000,	5,	NULL, 'PhoMaiQueSoCoLa.png',		'2025-01-01 08:00:00'),
    (N'Bánh Cuộn Xốt Sô-Cô-La',		@BanhCuonSoCoLaChip,	50000,	5,	NULL, 'BanhCuonSoCoLaChip.png',		'2025-01-01 08:00:00'),
    (N'Bánh Sô-Cô-La Đút Lò',		@BanhSoCoLaNguyenChat,	50000,	5,	NULL, 'BanhSoCoLaNguyenChat.png',	'2025-01-01 08:00:00'),
    -- Thức Uống (giữ nguyên Description)
    (N'Chai Coca‑Cola 390ml',				N'',	30000,	6,	NULL, 'Coke390ml.png',		 '2025-01-01 08:00:00'),
    (N'Chai Fanta 390ml',					N'',	30000,	6,	NULL, 'Fanta390ml.png',		 '2025-01-01 08:00:00'),
    (N'Chai Sprite 390ml',					N'',	30000,	6,	NULL, 'Sprite390ml.png',	 '2025-01-01 08:00:00'),
    (N'Lon Coca‑Cola zero 320ml',			N'',	30000,	6,	NULL, 'CokeZero390ml.png',	 '2025-01-01 08:00:00'),
    (N'Chai Coca‑Cola 1.5L',					N'',	30000,	6,	NULL, 'Coke1l5.png',		 '2025-01-01 08:00:00'),
    (N'Chai Coca‑Cola Zero Sugar 1.5L',		N'',	30000,	6,	NULL, 'CokeZero1l5.png',	 '2025-01-01 08:00:00'),
    (N'Chai Sprite 1.5L',					N'',	30000,	6,	NULL, 'Sprite1l5.png',		 '2025-01-01 08:00:00'),
    (N'Chai Fanta 1.5L',					N'',	30000,	6,	NULL, 'Fanta1l5.png',		 '2025-01-01 08:00:00'),
    (N'Trà đào hạt chia 350ml',				N'',	30000,	6,	NULL, 'TraDao390ml.png',	 '2025-01-01 08:00:00'),
    (N'Chanh Dây Hạt Chia 350ml',			N'',	30000,	6,	NULL, 'TraChanh390ml.png',	 '2025-01-01 08:00:00'),
    (N'Nước suối Dasani 510ml',				N'',	30000,	6,	NULL, 'Dasini390ml.png',	 '2025-01-01 08:00:00'),
    (N'Nước Suối Dasani 1.5L',				N'',	30000,	6,	NULL, 'Dasini1l5.png',		 '2025-01-01 08:00:00');
GO

-- 9.6 Toppings
INSERT INTO Toppings (ToppingName, Price, ProductID, CreatedDate) VALUES
  (N'Phô Mai',        20000, 1,  '2025-01-01 08:00:00'),
  (N'Tôm',            30000, 1,  '2025-01-01 08:00:00'),
  (N'Mực',            25000, 1,  '2025-01-01 08:00:00'),
  (N'Thịt Xông Khói', 25000, 1,  '2025-01-01 08:00:00'),
  (N'Gà',             20000, 1,  '2025-01-01 08:00:00'),
  (N'Xúc Xích Ý',     25000, 1,  '2025-01-01 08:00:00'),
  (N'Dứa',            15000, 1,  '2025-01-01 08:00:00'),
  (N'Giăm Bông',      20000, 1,  '2025-01-01 08:00:00'),
  (N'Nấm',            15000, 1,  '2025-01-01 08:00:00'),
  (N'Ớt Chuông',      15000, 1,  '2025-01-01 08:00:00'),
  (N'Hành Tây',       10000, 1,  '2025-01-01 08:00:00'),
  (N'Cà Chua',        10000, 1,  '2025-01-01 08:00:00'),
  (N'Olive',          20000, 1,  '2025-01-01 08:00:00'),
  (N'Xúc xích viên',  20000, 1,  '2025-01-01 08:00:00'),
  (N'Bò xé Mexico',   20000, 1,  '2025-01-01 08:00:00'),
  (N'Bắp',            20000, 1,  '2025-01-01 08:00:00');
GO

-- 9.7 Promotions
INSERT INTO Promotions (PromotionName, Description, DiscountPercentage, ImageURL, StartDate, EndDate, CreatedDate) VALUES
  (N'Giảm 70% Pizza Thứ 2',			N'Áp dụng cho tất cả pizza',      10.00,	'Giam70%.png',			'2025-02-01',	'2025-02-28',	'2025-01-15'),
  (N'Family Combo Pizza + Nước',    N'Mua pizza tặng 1 nước ngọt',     0.00,	'FamilyCombo.png',		'2025-03-01',	'2025-03-31',	'2025-02-20'),
  (N'Đồng Giá - Same Price',		N'Mua pizza tặng 1 nước ngọt',     0.00,	'DongGia.png',			'2025-03-01',	'2025-03-31',	'2025-02-20'),
  (N'Nửa Giá',						N'Mua pizza tặng 1 nước ngọt',     0.00,	'NuaGia.png',			'2025-03-01',	'2025-03-31',	'2025-02-20'),
  (N'Mua 1 Tặng 1',					N'Mua pizza tặng 1 nước ngọt',     0.00,	'Mua1Tang1.png',		'2025-03-01',	'2025-03-31',	'2025-02-20'),
  (N'Mua 1 Tặng 1 Thứ 5',			N'Mua pizza tặng 1 nước ngọt',     0.00,	'Mua1Tang1Thu5.png',	'2025-03-01',	'2025-03-31',	'2025-02-20'),
  (N'Mua 2 Tặng 3',					N'Áp dụng cho món gà',            20.00,	'Mua2Tang3.png',		'2025-04-01',	'2025-04-30',	'2025-03-20');
GO

-- 9.8 PromotionProducts
INSERT INTO PromotionProducts (PromotionID, ProductID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(6, 9),
(7, 29);

-- 9.9 Orders
INSERT INTO Orders (UserID, AddressID, OrderDate, TotalAmount, Status, PaymentMethod, ShippingFee, PromotionID, CreatedDate)
VALUES
    -- UserID 1
    (1, 1, '2025-04-01 18:30:00', 320000, N'Hoàn tất', N'Tiền mặt', 20000, 1, '2025-04-01 18:30:00'),
    (1, 2, '2025-04-05 12:15:00', 165000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-05 12:15:00'),
    (1, 1, '2025-04-10 20:45:00', 450000, N'Chờ xác nhận', N'Ví điện tử', 20000, 2, '2025-04-10 20:45:00'),
    (1, 2, '2025-04-15 14:00:00', 90000,  N'Hoàn tất', N'Thẻ', 0, 3, '2025-04-15 14:00:00'),
    (1, 1, '2025-04-18 19:30:00', 380000, N'Đang giao', N'Tiền mặt', 20000, 1, '2025-04-18 19:30:00'),
    (1, 2, '2025-04-21 13:45:00', 210000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-04-21 13:45:00'),
    (1, 1, '2025-04-24 17:15:00', 300000, N'Chờ xác nhận', N'Thẻ', 20000, 2, '2025-04-24 17:15:00'),
    (1, 2, '2025-04-27 11:30:00', 160000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-04-27 11:30:00'),
    (1, 1, '2025-04-29 20:00:00', 420000, N'Đang giao', N'Ví điện tử', 20000, 1, '2025-04-29 20:00:00'),
    (1, 2, '2025-04-30 15:45:00', 270000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-04-30 15:45:00'),
    -- UserID 2
    (2, 3, '2025-04-02 09:00:00', 250000, N'Hoàn tất', N'Tiền mặt', 15000, 2, '2025-04-02 09:00:00'),
    (2, 4, '2025-04-06 14:30:00', 180000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-06 14:30:00'),
    (2, 3, '2025-04-11 10:15:00', 390000, N'Chờ xác nhận', N'Ví điện tử', 15000, 3, '2025-04-11 10:15:00'),
    (2, 4, '2025-04-16 16:45:00', 120000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-04-16 16:45:00'),
    (2, 3, '2025-04-19 12:00:00', 340000, N'Đang giao', N'Tiền mặt', 20000, 2, '2025-04-19 12:00:00'),
    (2, 4, '2025-04-22 18:30:00', 230000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-04-22 18:30:00'),
    (2, 3, '2025-04-25 13:45:00', 280000, N'Chờ xác nhận', N'Thẻ', 20000, 3, '2025-04-25 13:45:00'),
    (2, 4, '2025-04-28 09:00:00', 190000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-04-28 09:00:00'),
    (2, 3, '2025-04-30 14:15:00', 410000, N'Đang giao', N'Ví điện tử', 15000, 2, '2025-04-30 14:15:00'),
    (2, 4, '2025-05-01 10:30:00', 260000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-01 10:30:00'),
    -- UserID 3
    (3, 5, '2025-04-03 11:00:00', 300000, N'Hoàn tất', N'Tiền mặt', 20000, 3, '2025-04-03 11:00:00'),
    (3, 6, '2025-04-07 15:45:00', 200000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-07 15:45:00'),
    (3, 5, '2025-04-12 09:30:00', 430000, N'Chờ xác nhận', N'Ví điện tử', 20000, 1, '2025-04-12 09:30:00'),
    (3, 6, '2025-04-17 14:00:00', 140000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-04-17 14:00:00'),
    (3, 5, '2025-04-20 18:15:00', 360000, N'Đang giao', N'Tiền mặt', 15000, 3, '2025-04-20 18:15:00'),
    (3, 6, '2025-04-23 12:45:00', 250000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-04-23 12:45:00'),
    (3, 5, '2025-04-26 16:00:00', 310000, N'Chờ xác nhận', N'Thẻ', 15000, 1, '2025-04-26 16:00:00'),
    (3, 6, '2025-04-29 10:45:00', 210000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-04-29 10:45:00'),
    (3, 5, '2025-05-01 15:00:00', 440000, N'Đang giao', N'Ví điện tử', 20000, 3, '2025-05-01 15:00:00'),
    (3, 6, '2025-05-02 11:15:00', 280000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-02 11:15:00'),
    -- UserID 4
    (4, 7, '2025-04-04 13:30:00', 270000, N'Hoàn tất', N'Tiền mặt', 15000, 2, '2025-04-04 13:30:00'),
    (4, 7, '2025-04-08 17:00:00', 220000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-08 17:00:00'),
    (4, 7, '2025-04-13 11:45:00', 460000, N'Chờ xác nhận', N'Ví điện tử', 15000, 3, '2025-04-13 11:45:00'),
    (4, 7, '2025-04-18 15:15:00', 160000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-04-18 15:15:00'),
    (4, 7, '2025-04-21 19:30:00', 380000, N'Đang giao', N'Tiền mặt', 20000, 2, '2025-04-21 19:30:00'),
    (4, 7, '2025-04-24 13:00:00', 270000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-04-24 13:00:00'),
    (4, 7, '2025-04-27 17:15:00', 330000, N'Chờ xác nhận', N'Thẻ', 20000, 3, '2025-04-27 17:15:00'),
    (4, 7, '2025-04-30 12:30:00', 230000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-04-30 12:30:00'),
    (4, 7, '2025-05-02 16:45:00', 470000, N'Đang giao', N'Ví điện tử', 15000, 2, '2025-05-02 16:45:00'),
    (4, 7, '2025-05-03 10:00:00', 290000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-03 10:00:00'),
    -- UserID 5
    (5, 8, '2025-04-05 15:00:00', 290000, N'Hoàn tất', N'Tiền mặt', 20000, 3, '2025-04-05 15:00:00'),
    (5, 9, '2025-04-09 18:30:00', 240000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-09 18:30:00'),
    (5, 8, '2025-04-14 12:15:00', 480000, N'Chờ xác nhận', N'Ví điện tử', 20000, 1, '2025-04-14 12:15:00'),
    (5, 9, '2025-04-19 16:45:00', 180000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-04-19 16:45:00'),
    (5, 8, '2025-04-22 20:00:00', 400000, N'Đang giao', N'Tiền mặt', 15000, 3, '2025-04-22 20:00:00'),
    (5, 9, '2025-04-25 14:30:00', 290000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-04-25 14:30:00'),
    (5, 8, '2025-04-28 18:45:00', 350000, N'Chờ xác nhận', N'Thẻ', 15000, 1, '2025-04-28 18:45:00'),
    (5, 9, '2025-05-01 13:00:00', 250000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-01 13:00:00'),
    (5, 8, '2025-05-03 17:15:00', 490000, N'Đang giao', N'Ví điện tử', 20000, 3, '2025-05-03 17:15:00'),
    (5, 9, '2025-05-04 11:30:00', 310000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-04 11:30:00'),
    -- UserID 6
    (6, 10, '2025-04-06 16:15:00', 310000, N'Hoàn tất', N'Tiền mặt', 15000, 1, '2025-04-06 16:15:00'),
    (6, 11, '2025-04-10 19:45:00', 260000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-10 19:45:00'),
    (6, 10, '2025-04-15 13:30:00', 500000, N'Chờ xác nhận', N'Ví điện tử', 15000, 2, '2025-04-15 13:30:00'),
    (6, 11, '2025-04-20 17:00:00', 200000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-04-20 17:00:00'),
    (6, 10, '2025-04-23 21:15:00', 420000, N'Đang giao', N'Tiền mặt', 20000, 1, '2025-04-23 21:15:00'),
    (6, 11, '2025-04-26 15:45:00', 310000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-04-26 15:45:00'),
    (6, 10, '2025-04-29 19:00:00', 370000, N'Chờ xác nhận', N'Thẻ', 20000, 2, '2025-04-29 19:00:00'),
    (6, 11, '2025-05-02 14:15:00', 270000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-02 14:15:00'),
    (6, 10, '2025-05-04 18:30:00', 510000, N'Đang giao', N'Ví điện tử', 15000, 1, '2025-05-04 18:30:00'),
    (6, 11, '2025-05-05 12:45:00', 330000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-05 12:45:00'),
    -- UserID 7
    (7, 12, '2025-04-07 17:30:00', 330000, N'Hoàn tất', N'Tiền mặt', 20000, 2, '2025-04-07 17:30:00'),
    (7, 12, '2025-04-11 20:00:00', 280000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-11 20:00:00'),
    (7, 12, '2025-04-16 14:45:00', 520000, N'Chờ xác nhận', N'Ví điện tử', 20000, 3, '2025-04-16 14:45:00'),
    (7, 12, '2025-04-21 18:15:00', 220000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-04-21 18:15:00'),
    (7, 12, '2025-04-24 22:30:00', 440000, N'Đang giao', N'Tiền mặt', 15000, 2, '2025-04-24 22:30:00'),
    (7, 12, '2025-04-27 16:00:00', 330000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-04-27 16:00:00'),
    (7, 12, '2025-04-30 20:15:00', 390000, N'Chờ xác nhận', N'Thẻ', 15000, 3, '2025-04-30 20:15:00'),
    (7, 12, '2025-05-03 15:30:00', 290000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-03 15:30:00'),
    (7, 12, '2025-05-05 19:45:00', 530000, N'Đang giao', N'Ví điện tử', 20000, 2, '2025-05-05 19:45:00'),
    (7, 12, '2025-05-06 13:00:00', 350000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-06 13:00:00'),
    -- UserID 8
    (8, 13, '2025-04-08 18:45:00', 350000, N'Hoàn tất', N'Tiền mặt', 15000, 3, '2025-04-08 18:45:00'),
    (8, 14, '2025-04-12 21:15:00', 300000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-12 21:15:00'),
    (8, 13, '2025-04-17 15:00:00', 540000, N'Chờ xác nhận', N'Ví điện tử', 15000, 1, '2025-04-17 15:00:00'),
    (8, 14, '2025-04-22 19:30:00', 240000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-04-22 19:30:00'),
    (8, 13, '2025-04-25 23:45:00', 460000, N'Đang giao', N'Tiền mặt', 20000, 3, '2025-04-25 23:45:00'),
    (8, 14, '2025-04-28 17:15:00', 350000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-04-28 17:15:00'),
    (8, 13, '2025-05-01 21:30:00', 410000, N'Chờ xác nhận', N'Thẻ', 20000, 1, '2025-05-01 21:30:00'),
    (8, 14, '2025-05-04 16:45:00', 310000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-04 16:45:00'),
    (8, 13, '2025-05-06 20:00:00', 550000, N'Đang giao', N'Ví điện tử', 15000, 3, '2025-05-06 20:00:00'),
    (8, 14, '2025-05-07 14:15:00', 370000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-07 14:15:00'),
    -- UserID 9
    (9, 15, '2025-04-09 19:00:00', 370000, N'Hoàn tất', N'Tiền mặt', 20000, 1, '2025-04-09 19:00:00'),
    (9, 16, '2025-04-13 22:30:00', 320000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-13 22:30:00'),
    (9, 15, '2025-04-18 16:15:00', 560000, N'Chờ xác nhận', N'Ví điện tử', 20000, 2, '2025-04-18 16:15:00'),
    (9, 16, '2025-04-23 20:45:00', 260000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-04-23 20:45:00'),
    (9, 15, '2025-04-26 00:00:00', 480000, N'Đang giao', N'Tiền mặt', 15000, 1, '2025-04-26 00:00:00'),
    (9, 16, '2025-04-29 18:30:00', 370000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-04-29 18:30:00'),
    (9, 15, '2025-05-02 22:45:00', 430000, N'Chờ xác nhận', N'Thẻ', 15000, 2, '2025-05-02 22:45:00'),
    (9, 16, '2025-05-05 18:00:00', 330000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-05 18:00:00'),
    (9, 15, '2025-05-07 21:15:00', 570000, N'Đang giao', N'Ví điện tử', 20000, 1, '2025-05-07 21:15:00'),
    (9, 16, '2025-05-08 15:30:00', 390000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-08 15:30:00'),
    -- UserID 10
    (10, 17, '2025-04-10 20:15:00', 390000, N'Hoàn tất', N'Tiền mặt', 15000, 2, '2025-04-10 20:15:00'),
    (10, 17, '2025-04-14 23:45:00', 340000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-14 23:45:00'),
    (10, 17, '2025-04-19 17:30:00', 580000, N'Chờ xác nhận', N'Ví điện tử', 15000, 3, '2025-04-19 17:30:00'),
    (10, 17, '2025-04-24 21:00:00', 280000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-04-24 21:00:00'),
    (10, 17, '2025-04-27 01:15:00', 500000, N'Đang giao', N'Tiền mặt', 20000, 2, '2025-04-27 01:15:00'),
    (10, 17, '2025-04-30 19:45:00', 390000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-04-30 19:45:00'),
    (10, 17, '2025-05-03 23:00:00', 450000, N'Chờ xác nhận', N'Thẻ', 20000, 3, '2025-05-03 23:00:00'),
    (10, 17, '2025-05-06 19:15:00', 350000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-06 19:15:00'),
    (10, 17, '2025-05-08 22:30:00', 590000, N'Đang giao', N'Ví điện tử', 15000, 2, '2025-05-08 22:30:00'),
    (10, 17, '2025-05-09 16:45:00', 410000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-09 16:45:00'),
    -- UserID 11
    (11, 18, '2025-04-11 21:30:00', 410000, N'Hoàn tất', N'Tiền mặt', 20000, 3, '2025-04-11 21:30:00'),
    (11, 19, '2025-04-15 00:00:00', 360000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-15 00:00:00'),
    (11, 18, '2025-04-20 18:45:00', 600000, N'Chờ xác nhận', N'Ví điện tử', 20000, 1, '2025-04-20 18:45:00'),
    (11, 19, '2025-04-25 22:15:00', 300000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-04-25 22:15:00'),
    (11, 18, '2025-04-28 02:30:00', 520000, N'Đang giao', N'Tiền mặt', 15000, 3, '2025-04-28 02:30:00'),
    (11, 19, '2025-05-01 20:00:00', 410000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-01 20:00:00'),
    (11, 18, '2025-05-04 00:15:00', 470000, N'Chờ xác nhận', N'Thẻ', 15000, 1, '2025-05-04 00:15:00'),
    (11, 19, '2025-05-07 20:30:00', 370000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-07 20:30:00'),
    (11, 18, '2025-05-09 23:45:00', 610000, N'Đang giao', N'Ví điện tử', 20000, 3, '2025-05-09 23:45:00'),
    (11, 19, '2025-05-10 18:00:00', 430000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-10 18:00:00'),
    -- UserID 12
    (12, 20, '2025-04-12 22:45:00', 430000, N'Hoàn tất', N'Tiền mặt', 15000, 1, '2025-04-12 22:45:00'),
    (12, 21, '2025-04-16 01:15:00', 380000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-16 01:15:00'),
    (12, 20, '2025-04-21 19:00:00', 620000, N'Chờ xác nhận', N'Ví điện tử', 15000, 2, '2025-04-21 19:00:00'),
    (12, 21, '2025-04-26 23:30:00', 320000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-04-26 23:30:00'),
    (12, 20, '2025-04-29 03:45:00', 540000, N'Đang giao', N'Tiền mặt', 20000, 1, '2025-04-29 03:45:00'),
    (12, 21, '2025-05-02 21:15:00', 430000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-02 21:15:00'),
    (12, 20, '2025-05-05 01:30:00', 490000, N'Chờ xác nhận', N'Thẻ', 20000, 2, '2025-05-05 01:30:00'),
    (12, 21, '2025-05-08 21:45:00', 390000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-08 21:45:00'),
    (12, 20, '2025-05-10 00:00:00', 630000, N'Đang giao', N'Ví điện tử', 15000, 1, '2025-05-10 00:00:00'),
    (12, 21, '2025-05-11 19:15:00', 450000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-11 19:15:00'),
    -- UserID 13
    (13, 22, '2025-04-13 00:00:00', 450000, N'Hoàn tất', N'Tiền mặt', 20000, 2, '2025-04-13 00:00:00'),
    (13, 22, '2025-04-17 02:30:00', 400000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-17 02:30:00'),
    (13, 22, '2025-04-22 20:15:00', 640000, N'Chờ xác nhận', N'Ví điện tử', 20000, 3, '2025-04-22 20:15:00'),
    (13, 22, '2025-04-27 00:45:00', 340000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-04-27 00:45:00'),
    (13, 22, '2025-04-30 05:00:00', 560000, N'Đang giao', N'Tiền mặt', 15000, 2, '2025-04-30 05:00:00'),
    (13, 22, '2025-05-03 22:30:00', 450000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-03 22:30:00'),
    (13, 22, '2025-05-06 02:45:00', 510000, N'Chờ xác nhận', N'Thẻ', 15000, 3, '2025-05-06 02:45:00'),
    (13, 22, '2025-05-09 23:00:00', 410000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-09 23:00:00'),
    (13, 22, '2025-05-11 01:15:00', 650000, N'Đang giao', N'Ví điện tử', 20000, 2, '2025-05-11 01:15:00'),
    (13, 22, '2025-05-12 20:30:00', 470000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-12 20:30:00'),
    -- UserID 14
    (14, 23, '2025-04-14 01:15:00', 470000, N'Hoàn tất', N'Tiền mặt', 15000, 3, '2025-04-14 01:15:00'),
    (14, 24, '2025-04-18 03:45:00', 420000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-18 03:45:00'),
    (14, 23, '2025-04-23 21:30:00', 660000, N'Chờ xác nhận', N'Ví điện tử', 15000, 1, '2025-04-23 21:30:00'),
    (14, 24, '2025-04-28 01:00:00', 360000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-04-28 01:00:00'),
    (14, 23, '2025-05-01 06:15:00', 580000, N'Đang giao', N'Tiền mặt', 20000, 3, '2025-05-01 06:15:00'),
    (14, 24, '2025-05-04 23:45:00', 470000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-04 23:45:00'),
    (14, 23, '2025-05-07 04:00:00', 530000, N'Chờ xác nhận', N'Thẻ', 20000, 1, '2025-05-07 04:00:00'),
    (14, 24, '2025-05-10 00:15:00', 430000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-10 00:15:00'),
    (14, 23, '2025-05-12 02:30:00', 670000, N'Đang giao', N'Ví điện tử', 15000, 3, '2025-05-12 02:30:00'),
    (14, 24, '2025-05-13 21:45:00', 490000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-13 21:45:00'),
    -- UserID 15
    (15, 25, '2025-04-15 02:30:00', 490000, N'Hoàn tất', N'Tiền mặt', 20000, 1, '2025-04-15 02:30:00'),
    (15, 26, '2025-04-19 05:00:00', 440000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-19 05:00:00'),
    (15, 25, '2025-04-24 22:45:00', 680000, N'Chờ xác nhận', N'Ví điện tử', 20000, 2, '2025-04-24 22:45:00'),
    (15, 26, '2025-04-29 02:15:00', 380000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-04-29 02:15:00'),
    (15, 25, '2025-05-02 07:30:00', 600000, N'Đang giao', N'Tiền mặt', 15000, 1, '2025-05-02 07:30:00'),
    (15, 26, '2025-05-05 00:00:00', 490000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-05 00:00:00'),
    (15, 25, '2025-05-08 05:15:00', 550000, N'Chờ xác nhận', N'Thẻ', 15000, 2, '2025-05-08 05:15:00'),
    (15, 26, '2025-05-11 01:30:00', 450000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-11 01:30:00'),
    (15, 25, '2025-05-13 03:45:00', 690000, N'Đang giao', N'Ví điện tử', 20000, 1, '2025-05-13 03:45:00'),
    (15, 26, '2025-05-14 23:00:00', 510000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-14 23:00:00'),
    -- UserID 16
    (16, 27, '2025-04-16 03:45:00', 510000, N'Hoàn tất', N'Tiền mặt', 15000, 2, '2025-04-16 03:45:00'),
    (16, 27, '2025-04-20 06:15:00', 460000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-20 06:15:00'),
    (16, 27, '2025-04-25 23:00:00', 700000, N'Chờ xác nhận', N'Ví điện tử', 15000, 3, '2025-04-25 23:00:00'),
    (16, 27, '2025-04-30 03:30:00', 400000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-04-30 03:30:00'),
    (16, 27, '2025-05-03 08:45:00', 620000, N'Đang giao', N'Tiền mặt', 20000, 2, '2025-05-03 08:45:00'),
    (16, 27, '2025-05-06 01:15:00', 510000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-06 01:15:00'),
    (16, 27, '2025-05-09 06:30:00', 570000, N'Chờ xác nhận', N'Thẻ', 20000, 3, '2025-05-09 06:30:00'),
    (16, 27, '2025-05-12 02:45:00', 470000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-12 02:45:00'),
    (16, 27, '2025-05-14 05:00:00', 710000, N'Đang giao', N'Ví điện tử', 15000, 2, '2025-05-14 05:00:00'),
    (16, 27, '2025-05-15 00:15:00', 530000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-15 00:15:00'),
    -- UserID 17
    (17, 28, '2025-04-17 05:00:00', 530000, N'Hoàn tất', N'Tiền mặt', 20000, 3, '2025-04-17 05:00:00'),
    (17, 29, '2025-04-21 07:30:00', 480000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-21 07:30:00'),
    (17, 28, '2025-04-26 00:15:00', 720000, N'Chờ xác nhận', N'Ví điện tử', 20000, 1, '2025-04-26 00:15:00'),
    (17, 29, '2025-05-01 04:45:00', 420000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-05-01 04:45:00'),
    (17, 28, '2025-05-04 10:00:00', 640000, N'Đang giao', N'Tiền mặt', 15000, 3, '2025-05-04 10:00:00'),
    (17, 29, '2025-05-07 02:30:00', 530000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-07 02:30:00'),
    (17, 28, '2025-05-10 07:45:00', 590000, N'Chờ xác nhận', N'Thẻ', 15000, 1, '2025-05-10 07:45:00'),
    (17, 29, '2025-05-13 04:00:00', 490000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-13 04:00:00'),
    (17, 28, '2025-05-15 06:15:00', 730000, N'Đang giao', N'Ví điện tử', 20000, 3, '2025-05-15 06:15:00'),
    (17, 29, '2025-05-16 01:30:00', 550000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-16 01:30:00'),
    -- UserID 18
    (18, 30, '2025-04-18 06:15:00', 550000, N'Hoàn tất', N'Tiền mặt', 15000, 1, '2025-04-18 06:15:00'),
    (18, 31, '2025-04-22 08:45:00', 500000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-22 08:45:00'),
    (18, 30, '2025-04-27 01:30:00', 740000, N'Chờ xác nhận', N'Ví điện tử', 15000, 2, '2025-04-27 01:30:00'),
    (18, 31, '2025-05-02 06:00:00', 440000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-05-02 06:00:00'),
    (18, 30, '2025-05-05 11:15:00', 660000, N'Đang giao', N'Tiền mặt', 20000, 1, '2025-05-05 11:15:00'),
    (18, 31, '2025-05-08 03:45:00', 550000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-08 03:45:00'),
    (18, 30, '2025-05-11 09:00:00', 610000, N'Chờ xác nhận', N'Thẻ', 20000, 2, '2025-05-11 09:00:00'),
    (18, 31, '2025-05-14 05:15:00', 510000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-14 05:15:00'),
    (18, 30, '2025-05-16 07:30:00', 750000, N'Đang giao', N'Ví điện tử', 15000, 1, '2025-05-16 07:30:00'),
    (18, 31, '2025-05-17 02:45:00', 570000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-17 02:45:00'),
    -- UserID 19
    (19, 32, '2025-04-19 07:30:00', 570000, N'Hoàn tất', N'Tiền mặt', 20000, 2, '2025-04-19 07:30:00'),
    (19, 32, '2025-04-23 10:00:00', 520000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-23 10:00:00'),
    (19, 32, '2025-04-28 02:45:00', 760000, N'Chờ xác nhận', N'Ví điện tử', 20000, 3, '2025-04-28 02:45:00'),
    (19, 32, '2025-05-03 07:15:00', 460000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-05-03 07:15:00'),
    (19, 32, '2025-05-06 12:30:00', 680000, N'Đang giao', N'Tiền mặt', 15000, 2, '2025-05-06 12:30:00'),
    (19, 32, '2025-05-09 05:00:00', 570000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-09 05:00:00'),
    (19, 32, '2025-05-12 10:15:00', 630000, N'Chờ xác nhận', N'Thẻ', 15000, 3, '2025-05-12 10:15:00'),
    (19, 32, '2025-05-15 06:30:00', 530000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-15 06:30:00'),
    (19, 32, '2025-05-17 08:45:00', 770000, N'Đang giao', N'Ví điện tử', 20000, 2, '2025-05-17 08:45:00'),
    (19, 32, '2025-05-18 04:00:00', 590000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-18 04:00:00'),
    -- UserID 20
    (20, 33, '2025-04-20 08:45:00', 590000, N'Hoàn tất', N'Tiền mặt', 15000, 3, '2025-04-20 08:45:00'),
    (20, 34, '2025-04-24 11:15:00', 540000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-24 11:15:00'),
    (20, 33, '2025-04-29 04:00:00', 780000, N'Chờ xác nhận', N'Ví điện tử', 15000, 1, '2025-04-29 04:00:00'),
    (20, 34, '2025-05-04 08:30:00', 480000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-05-04 08:30:00'),
    (20, 33, '2025-05-07 13:45:00', 700000, N'Đang giao', N'Tiền mặt', 20000, 3, '2025-05-07 13:45:00'),
    (20, 34, '2025-05-10 06:15:00', 590000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-10 06:15:00'),
    (20, 33, '2025-05-13 11:30:00', 650000, N'Chờ xác nhận', N'Thẻ', 20000, 1, '2025-05-13 11:30:00'),
    (20, 34, '2025-05-16 07:45:00', 550000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-16 07:45:00'),
    (20, 33, '2025-05-18 10:00:00', 790000, N'Đang giao', N'Ví điện tử', 15000, 3, '2025-05-18 10:00:00'),
    (20, 34, '2025-05-19 05:15:00', 610000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-19 05:15:00'),
    -- UserID 21
    (21, 35, '2025-04-21 10:00:00', 610000, N'Hoàn tất', N'Tiền mặt', 20000, 1, '2025-04-21 10:00:00'),
    (21, 36, '2025-04-25 12:30:00', 560000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-25 12:30:00'),
    (21, 35, '2025-04-30 05:15:00', 800000, N'Chờ xác nhận', N'Ví điện tử', 20000, 2, '2025-04-30 05:15:00'),
    (21, 36, '2025-05-05 09:45:00', 500000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-05-05 09:45:00'),
    (21, 35, '2025-05-08 15:00:00', 720000, N'Đang giao', N'Tiền mặt', 15000, 1, '2025-05-08 15:00:00'),
    (21, 36, '2025-05-11 07:30:00', 610000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-11 07:30:00'),
    (21, 35, '2025-05-14 12:45:00', 670000, N'Chờ xác nhận', N'Thẻ', 15000, 2, '2025-05-14 12:45:00'),
    (21, 36, '2025-05-17 09:00:00', 570000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-17 09:00:00'),
    (21, 35, '2025-05-19 11:15:00', 810000, N'Đang giao', N'Ví điện tử', 20000, 1, '2025-05-19 11:15:00'),
    (21, 36, '2025-05-20 06:30:00', 630000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-20 06:30:00'),
    -- UserID 22
    (22, 37, '2025-04-22 11:15:00', 630000, N'Hoàn tất', N'Tiền mặt', 15000, 2, '2025-04-22 11:15:00'),
    (22, 37, '2025-04-26 13:45:00', 580000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-26 13:45:00'),
    (22, 37, '2025-05-01 06:30:00', 820000, N'Chờ xác nhận', N'Ví điện tử', 15000, 3, '2025-05-01 06:30:00'),
    (22, 37, '2025-05-06 11:00:00', 520000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-05-06 11:00:00'),
    (22, 37, '2025-05-09 16:15:00', 740000, N'Đang giao', N'Tiền mặt', 20000, 2, '2025-05-09 16:15:00'),
    (22, 37, '2025-05-12 08:45:00', 630000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-12 08:45:00'),
    (22, 37, '2025-05-15 14:00:00', 690000, N'Chờ xác nhận', N'Thẻ', 20000, 3, '2025-05-15 14:00:00'),
    (22, 37, '2025-05-18 10:15:00', 590000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-18 10:15:00'),
    (22, 37, '2025-05-20 12:30:00', 830000, N'Đang giao', N'Ví điện tử', 15000, 2, '2025-05-20 12:30:00'),
    (22, 37, '2025-05-21 07:45:00', 650000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-21 07:45:00'),
    -- UserID 23
    (23, 38, '2025-04-23 12:30:00', 650000, N'Hoàn tất', N'Tiền mặt', 20000, 3, '2025-04-23 12:30:00'),
    (23, 39, '2025-04-27 15:00:00', 600000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-27 15:00:00'),
    (23, 38, '2025-05-02 07:45:00', 840000, N'Chờ xác nhận', N'Ví điện tử', 20000, 1, '2025-05-02 07:45:00'),
    (23, 39, '2025-05-07 12:15:00', 540000, N'Hoàn tất', N'Thẻ', 0, 2, '2025-05-07 12:15:00'),
    (23, 38, '2025-05-10 17:30:00', 760000, N'Đang giao', N'Tiền mặt', 15000, 3, '2025-05-10 17:30:00'),
    (23, 39, '2025-05-13 10:00:00', 650000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-13 10:00:00'),
    (23, 38, '2025-05-16 15:15:00', 710000, N'Chờ xác nhận', N'Thẻ', 15000, 1, '2025-05-16 15:15:00'),
    (23, 39, '2025-05-19 11:30:00', 610000, N'Hoàn tất', N'Tiền mặt', 0, 2, '2025-05-19 11:30:00'),
    (23, 38, '2025-05-21 13:45:00', 850000, N'Đang giao', N'Ví điện tử', 20000, 3, '2025-05-21 13:45:00'),
    (23, 39, '2025-05-22 09:00:00', 670000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-22 09:00:00'),
    -- UserID 24
    (24, 40, '2025-04-24 13:45:00', 670000, N'Hoàn tất', N'Tiền mặt', 15000, 1, '2025-04-24 13:45:00'),
    (24, 41, '2025-04-28 16:15:00', 620000, N'Đang giao', N'Thẻ', 20000, NULL, '2025-04-28 16:15:00'),
    (24, 40, '2025-05-03 09:00:00', 860000, N'Chờ xác nhận', N'Ví điện tử', 15000, 2, '2025-05-03 09:00:00'),
    (24, 41, '2025-05-08 13:30:00', 560000, N'Hoàn tất', N'Thẻ', 0, 3, '2025-05-08 13:30:00'),
    (24, 40, '2025-05-11 18:45:00', 780000, N'Đang giao', N'Tiền mặt', 20000, 1, '2025-05-11 18:45:00'),
    (24, 41, '2025-05-14 11:15:00', 670000, N'Đã hủy', N'Ví điện tử', 15000, NULL, '2025-05-14 11:15:00'),
    (24, 40, '2025-05-17 16:30:00', 730000, N'Chờ xác nhận', N'Thẻ', 20000, 2, '2025-05-17 16:30:00'),
    (24, 41, '2025-05-20 12:45:00', 630000, N'Hoàn tất', N'Tiền mặt', 0, 3, '2025-05-20 12:45:00'),
    (24, 40, '2025-05-22 15:00:00', 870000, N'Đang giao', N'Ví điện tử', 15000, 1, '2025-05-22 15:00:00'),
    (24, 41, '2025-05-23 10:15:00', 690000, N'Đã hủy', N'Thẻ', 20000, NULL, '2025-05-23 10:15:00'),
    -- UserID 25
    (25, 42, '2025-04-25 15:00:00', 690000, N'Hoàn tất', N'Tiền mặt', 20000, 2, '2025-04-25 15:00:00'),
    (25, 42, '2025-04-29 17:30:00', 640000, N'Đang giao', N'Thẻ', 15000, NULL, '2025-04-29 17:30:00'),
    (25, 42, '2025-05-04 10:15:00', 880000, N'Chờ xác nhận', N'Ví điện tử', 20000, 3, '2025-05-04 10:15:00'),
    (25, 42, '2025-05-09 14:45:00', 580000, N'Hoàn tất', N'Thẻ', 0, 1, '2025-05-09 14:45:00'),
    (25, 42, '2025-05-12 20:00:00', 800000, N'Đang giao', N'Tiền mặt', 15000, 2, '2025-05-12 20:00:00'),
    (25, 42, '2025-05-15 12:30:00', 690000, N'Đã hủy', N'Ví điện tử', 20000, NULL, '2025-05-15 12:30:00'),
    (25, 42, '2025-05-18 17:45:00', 750000, N'Chờ xác nhận', N'Thẻ', 15000, 3, '2025-05-18 17:45:00'),
    (25, 42, '2025-05-21 14:00:00', 650000, N'Hoàn tất', N'Tiền mặt', 0, 1, '2025-05-21 14:00:00'),
    (25, 42, '2025-05-23 16:15:00', 890000, N'Đang giao', N'Ví điện tử', 20000, 2, '2025-05-23 16:15:00'),
    (25, 42, '2025-05-24 11:30:00', 710000, N'Đã hủy', N'Thẻ', 15000, NULL, '2025-05-24 11:30:00');
GO
-- 9.10 OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Size, CrustType, UnitPrice, ToppingID, ToppingPrice)
VALUES
    -- OrderID 1 (TotalAmount 320,000, ShippingFee 20,000, PromotionID 1, Target 300,000)
    (1, 1, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (1, 2, 1, 'M', N'Đế dày', 150000, NULL, 0),
    -- OrderID 2 (TotalAmount 165,000, ShippingFee 15,000, PromotionID NULL, Target 150,000)
    (2, 3, 1, 'M', N'Đế mỏng', 150000, NULL, 0),
    (2, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 3 (TotalAmount 450,000, ShippingFee 20,000, PromotionID 2, Target 430,000)
    (3, 4, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (3, 5, 1, 'M', N'Đế mỏng', 150000, 3, 25000),
    (3, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 4 (TotalAmount 90,000, ShippingFee 0, PromotionID 3, Target 90,000)
    (4, 6, 1, 'S', N'Đế mỏng', 120000, NULL, 0),
    (4, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 5 (TotalAmount 380,000, ShippingFee 20,000, PromotionID 1, Target 360,000)
    (5, 7, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (5, 8, 1, 'M', N'Đế mỏng', 150000, 5, 20000),
    (5, 42, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 6 (TotalAmount 210,000, ShippingFee 15,000, PromotionID NULL, Target 195,000)
    (6, 9, 1, 'M', N'Đế dày', 150000, 6, 25000),
    (6, 48, 1, NULL, NULL, 50000, NULL, 0),
    -- OrderID 7 (TotalAmount 300,000, ShippingFee 20,000, PromotionID 2, Target 280,000)
    (7, 10, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (7, 35, 1, NULL, NULL, 90000, NULL, 0),
    (7, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 8 (TotalAmount 160,000, ShippingFee 0, PromotionID 3, Target 160,000)
    (8, 11, 1, 'M', N'Đế mỏng', 150000, 8, 20000),
    (8, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 9 (TotalAmount 420,000, ShippingFee 20,000, PromotionID 1, Target 400,000)
    (9, 12, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (9, 13, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (9, 29, 1, NULL, NULL, 80000, NULL, 0),
    (9, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 10 (TotalAmount 270,000, ShippingFee 15,000, PromotionID NULL, Target 255,000)
    (10, 14, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (10, 43, 1, NULL, NULL, 60000, NULL, 0),
    (10, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 11 (TotalAmount 250,000, ShippingFee 15,000, PromotionID 2, Target 235,000)
    (11, 15, 1, 'M', N'Đế mỏng', 150000, 12, 10000),
    (11, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 12 (TotalAmount 180,000, ShippingFee 20,000, PromotionID NULL, Target 160,000)
    (12, 16, 1, 'S', N'Đế dày', 120000, 13, 20000),
    (12, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 13 (TotalAmount 390,000, ShippingFee 15,000, PromotionID 3, Target 375,000)
    (13, 17, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (13, 18, 1, 'M', N'Đế dày', 150000, 15, 20000),
    (13, 44, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 14 (TotalAmount 120,000, ShippingFee 0, PromotionID 1, Target 120,000)
    (14, 19, 1, 'S', N'Đế mỏng', 120000, NULL, 0),
    (14, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 15 (TotalAmount 340,000, ShippingFee 20,000, PromotionID 2, Target 320,000)
    (15, 20, 1, 'L', N'Đế dày', 180000, 16, 20000),
    (15, 37, 1, NULL, NULL, 90000, NULL, 0),
    (15, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 16 (TotalAmount 230,000, ShippingFee 15,000, PromotionID NULL, Target 215,000)
    (16, 21, 1, 'M', N'Đế mỏng', 150000, 1, 20000),
    (16, 49, 1, NULL, NULL, 50000, NULL, 0),
    -- OrderID 17 (TotalAmount 280,000, ShippingFee 20,000, PromotionID 3, Target 260,000)
    (17, 22, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (17, 45, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 18 (TotalAmount 190,000, ShippingFee 0, PromotionID 1, Target 190,000)
    (18, 23, 1, 'M', N'Đế mỏng', 150000, 3, 25000),
    (18, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 19 (TotalAmount 410,000, ShippingFee 15,000, PromotionID 2, Target 395,000)
    (19, 24, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (19, 25, 1, 'M', N'Đế mỏng', 150000, 5, 20000),
    (19, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 20 (TotalAmount 260,000, ShippingFee 20,000, PromotionID NULL, Target 240,000)
    (20, 26, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (20, 46, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 21 (TotalAmount 300,000, ShippingFee 20,000, PromotionID 3, Target 280,000)
    (21, 27, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (21, 38, 1, NULL, NULL, 90000, NULL, 0),
    (21, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 22 (TotalAmount 200,000, ShippingFee 15,000, PromotionID NULL, Target 185,000)
    (22, 1, 1, 'M', N'Đế mỏng', 150000, 8, 20000),
    (22, 50, 1, NULL, NULL, 50000, NULL, 0),
    -- OrderID 23 (TotalAmount 430,000, ShippingFee 20,000, PromotionID 1, Target 410,000)
    (23, 2, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (23, 3, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (23, 31, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 24 (TotalAmount 140,000, ShippingFee 0, PromotionID 2, Target 140,000)
    (24, 4, 1, 'S', N'Đế mỏng', 120000, 11, 10000),
    (24, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 25 (TotalAmount 360,000, ShippingFee 15,000, PromotionID 3, Target 345,000)
    (25, 5, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (25, 6, 1, 'M', N'Đế mỏng', 150000, 13, 20000),
    (25, 47, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 26 (TotalAmount 250,000, ShippingFee 20,000, PromotionID NULL, Target 230,000)
    (26, 7, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (26, 51, 1, NULL, NULL, 50000, NULL, 0),
    -- OrderID 27 (TotalAmount 310,000, ShippingFee 15,000, PromotionID 1, Target 295,000)
    (27, 8, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (27, 39, 1, NULL, NULL, 90000, NULL, 0),
    (27, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 28 (TotalAmount 210,000, ShippingFee 0, PromotionID 2, Target 210,000)
    (28, 9, 1, 'M', N'Đế mỏng', 150000, 16, 20000),
    (28, 32, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 29 (TotalAmount 440,000, ShippingFee 20,000, PromotionID 3, Target 420,000)
    (29, 10, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (29, 11, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (29, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 30 (TotalAmount 280,000, ShippingFee 15,000, PromotionID NULL, Target 265,000)
    (30, 12, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (30, 33, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 31 (TotalAmount 270,000, ShippingFee 15,000, PromotionID 2, Target 255,000)
    (31, 13, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (31, 41, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 32 (TotalAmount 220,000, ShippingFee 20,000, PromotionID NULL, Target 200,000)
    (32, 14, 1, 'M', N'Đế mỏng', 150000, 5, 20000),
    (32, 34, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 33 (TotalAmount 460,000, ShippingFee 15,000, PromotionID 3, Target 445,000)
    (33, 15, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (33, 16, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (33, 42, 1, NULL, NULL, 60000, NULL, 0),
    (33, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 34 (TotalAmount 160,000, ShippingFee 0, PromotionID 1, Target 160,000)
    (34, 17, 1, 'M', N'Đế mỏng', 150000, 8, 20000),
    (34, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 35 (TotalAmount 380,000, ShippingFee 20,000, PromotionID 2, Target 360,000)
    (35, 18, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (35, 19, 1, 'M', N'Đế mỏng', 150000, 10, 15000),
    (35, 43, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 36 (TotalAmount 270,000, ShippingFee 15,000, PromotionID NULL, Target 255,000)
    (36, 20, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (36, 44, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 37 (TotalAmount 330,000, ShippingFee 20,000, PromotionID 3, Target 310,000)
    (37, 21, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (37, 45, 1, NULL, NULL, 60000, NULL, 0),
    (37, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 38 (TotalAmount 230,000, ShippingFee 0, PromotionID 1, Target 230,000)
    (38, 22, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (38, 46, 1, NULL, NULL, 60000, NULL, 0),
    -- OrderID 39 (TotalAmount 470,000, ShippingFee 15,000, PromotionID 2, Target 455,000)
    (39, 23, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (39, 24, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (39, 47, 1, NULL, NULL, 60000, NULL, 0),
    (39, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 40 (TotalAmount 290,000, ShippingFee 20,000, PromotionID NULL, Target 270,000)
    (40, 25, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (40, 35, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 41 (TotalAmount 290,000, ShippingFee 20,000, PromotionID 3, Target 270,000)
    (41, 26, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (41, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 42 (TotalAmount 240,000, ShippingFee 15,000, PromotionID NULL, Target 225,000)
    (42, 27, 1, 'M', N'Đế mỏng', 150000, 2, 30000),
    (42, 37, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 43 (TotalAmount 480,000, ShippingFee 20,000, PromotionID 1, Target 460,000)
    (43, 1, 1, 'L', N'Đế dày', 180000, 3, 25000),
    (43, 2, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (43, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 44 (TotalAmount 180,000, ShippingFee 0, PromotionID 2, Target 180,000)
    (44, 3, 1, 'M', N'Đế mỏng', 150000, 5, 20000),
    (44, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 45 (TotalAmount 400,000, ShippingFee 15,000, PromotionID 3, Target 385,000)
    (45, 4, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (45, 5, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (45, 39, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 46 (TotalAmount 290,000, ShippingFee 20,000, PromotionID NULL, Target 270,000)
    (46, 6, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (46, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 47 (TotalAmount 350,000, ShippingFee 15,000, PromotionID 1, Target 335,000)
    (47, 7, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (47, 8, 1, 'M', N'Đế mỏng', 150000, 10, 15000),
    (47, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 48 (TotalAmount 250,000, ShippingFee 0, PromotionID 2, Target 250,000)
    (48, 9, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (48, 41, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 49 (TotalAmount 490,000, ShippingFee 20,000, PromotionID 3, Target 470,000)
    (49, 10, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (49, 11, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (49, 28, 1, NULL, NULL, 80000, NULL, 0),
    (49, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 50 (TotalAmount 310,000, ShippingFee 15,000, PromotionID NULL, Target 295,000)
    (50, 12, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (50, 29, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 51 (TotalAmount 310,000, ShippingFee 15,000, PromotionID 1, Target 295,000)
    (51, 13, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (51, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 52 (TotalAmount 260,000, ShippingFee 20,000, PromotionID NULL, Target 240,000)
    (52, 14, 1, 'M', N'Đế mỏng', 150000, 16, 20000),
    (52, 31, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 53 (TotalAmount 540,000, ShippingFee 15,000, PromotionID 1, Target 525,000)
    (53, 15, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (53, 16, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (53, 32, 1, NULL, NULL, 80000, NULL, 0),
    (53, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 54 (TotalAmount 240,000, ShippingFee 0, PromotionID 2, Target 240,000)
    (54, 17, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (54, 33, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 55 (TotalAmount 460,000, ShippingFee 20,000, PromotionID 3, Target 440,000)
    (55, 18, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (55, 19, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (55, 34, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 56 (TotalAmount 350,000, ShippingFee 15,000, PromotionID NULL, Target 335,000)
    (56, 20, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (56, 35, 1, NULL, NULL, 90000, NULL, 0),
    (56, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 57 (TotalAmount 410,000, ShippingFee 20,000, PromotionID 1, Target 390,000)
    (57, 21, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (57, 22, 1, 'M', N'Đế mỏng', 150000, 8, 20000),
    (57, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 58 (TotalAmount 310,000, ShippingFee 0, PromotionID 2, Target 310,000)
    (58, 23, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (58, 37, 1, NULL, NULL, 90000, NULL, 0),
    (58, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 59 (TotalAmount 550,000, ShippingFee 15,000, PromotionID 3, Target 535,000)
    (59, 24, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (59, 25, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (59, 38, 1, NULL, NULL, 90000, NULL, 0),
    (59, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 60 (TotalAmount 370,000, ShippingFee 20,000, PromotionID NULL, Target 350,000)
    (60, 26, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (60, 39, 1, NULL, NULL, 90000, NULL, 0),
    (60, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 61 (TotalAmount 370,000, ShippingFee 20,000, PromotionID 1, Target 350,000)
    (61, 27, 1, 'L', N'Đế dày', 180000, 13, 20000),
    (61, 40, 1, NULL, NULL, 90000, NULL, 0),
    (61, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 62 (TotalAmount 320,000, ShippingFee 15,000, PromotionID NULL, Target 305,000)
    (62, 1, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (62, 41, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 63 (TotalAmount 560,000, ShippingFee 20,000, PromotionID 2, Target 540,000)
    (63, 2, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (63, 3, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (63, 28, 1, NULL, NULL, 80000, NULL, 0),
    (63, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 64 (TotalAmount 260,000, ShippingFee 0, PromotionID 3, Target 260,000)
    (64, 4, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (64, 29, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 65 (TotalAmount 480,000, ShippingFee 15,000, PromotionID 1, Target 465,000)
    (65, 5, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (65, 6, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (65, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 66 (TotalAmount 370,000, ShippingFee 20,000, PromotionID NULL, Target 350,000)
    (66, 7, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (66, 31, 1, NULL, NULL, 80000, NULL, 0),
    (66, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 67 (TotalAmount 430,000, ShippingFee 15,000, PromotionID 2, Target 415,000)
    (67, 8, 1, 'L', N'Đế dày', 180000, 5, 20000),
    (67, 9, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (67, 32, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 68 (TotalAmount 330,000, ShippingFee 0, PromotionID 3, Target 330,000)
    (68, 10, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (68, 33, 1, NULL, NULL, 80000, NULL, 0),
    (68, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 69 (TotalAmount 570,000, ShippingFee 20,000, PromotionID 1, Target 550,000)
    (69, 11, 1, 'L', N'Đế dày', 180000, 8, 20000),
    (69, 12, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (69, 34, 1, NULL, NULL, 80000, NULL, 0),
    (69, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 70 (TotalAmount 390,000, ShippingFee 15,000, PromotionID NULL, Target 375,000)
    (70, 13, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (70, 35, 1, NULL, NULL, 90000, NULL, 0),
    (70, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 71 (TotalAmount 390,000, ShippingFee 15,000, PromotionID 2, Target 375,000)
    (71, 14, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (71, 15, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (71, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 72 (TotalAmount 340,000, ShippingFee 20,000, PromotionID NULL, Target 320,000)
    (72, 16, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (72, 37, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 73 (TotalAmount 580,000, ShippingFee 15,000, PromotionID 3, Target 565,000)
    (73, 17, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (73, 18, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (73, 38, 1, NULL, NULL, 90000, NULL, 0),
    (73, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 74 (TotalAmount 280,000, ShippingFee 0, PromotionID 1, Target 280,000)
    (74, 19, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (74, 39, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 75 (TotalAmount 500,000, ShippingFee 20,000, PromotionID 2, Target 480,000)
    (75, 20, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (75, 21, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (75, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 76 (TotalAmount 390,000, ShippingFee 15,000, PromotionID NULL, Target 375,000)
    (76, 22, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (76, 41, 1, NULL, NULL, 90000, NULL, 0),
    (76, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 77 (TotalAmount 450,000, ShippingFee 20,000, PromotionID 3, Target 430,000)
    (77, 23, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (77, 24, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (77, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 78 (TotalAmount 350,000, ShippingFee 0, PromotionID 1, Target 350,000)
    (78, 25, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (78, 29, 1, NULL, NULL, 80000, NULL, 0),
    (78, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 79 (TotalAmount 590,000, ShippingFee 15,000, PromotionID 2, Target 575,000)
    (79, 26, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (79, 27, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (79, 30, 1, NULL, NULL, 80000, NULL, 0),
    (79, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 80 (TotalAmount 410,000, ShippingFee 20,000, PromotionID NULL, Target 390,000)
    (80, 1, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (80, 31, 1, NULL, NULL, 80000, NULL, 0),
    (80, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 81 (TotalAmount 410,000, ShippingFee 20,000, PromotionID 3, Target 390,000)
    (81, 2, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (81, 32, 1, NULL, NULL, 80000, NULL, 0),
    (81, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 82 (TotalAmount 360,000, ShippingFee 15,000, PromotionID NULL, Target 345,000)
    (82, 3, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (82, 33, 1, NULL, NULL, 80000, NULL, 0),
    (82, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 83 (TotalAmount 600,000, ShippingFee 20,000, PromotionID 1, Target 580,000)
    (83, 4, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (83, 5, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (83, 34, 1, NULL, NULL, 80000, NULL, 0),
    (83, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 84 (TotalAmount 300,000, ShippingFee 0, PromotionID 2, Target 300,000)
    (84, 6, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (84, 35, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 85 (TotalAmount 520,000, ShippingFee 15,000, PromotionID 3, Target 505,000)
    (85, 7, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (85, 8, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (85, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 86 (TotalAmount 410,000, ShippingFee 20,000, PromotionID NULL, Target 390,000)
    (86, 9, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (86, 37, 1, NULL, NULL, 90000, NULL, 0),
    (86, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 87 (TotalAmount 470,000, ShippingFee 15,000, PromotionID 1, Target 455,000)
    (87, 10, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (87, 11, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (87, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 88 (TotalAmount 370,000, ShippingFee 0, PromotionID 2, Target 370,000)
    (88, 12, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (88, 39, 1, NULL, NULL, 90000, NULL, 0),
    (88, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 89 (TotalAmount 610,000, ShippingFee 20,000, PromotionID 3, Target 590,000)
    (89, 13, 1, 'L', N'Đế dày', 180000, 5, 20000),
    (89, 14, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (89, 40, 1, NULL, NULL, 90000, NULL, 0),
    (89, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 90 (TotalAmount 430,000, ShippingFee 15,000, PromotionID NULL, Target 415,000)
    (90, 15, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (90, 41, 1, NULL, NULL, 90000, NULL, 0),
    (90, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 91 (TotalAmount 430,000, ShippingFee 15,000, PromotionID 1, Target 415,000)
    (91, 16, 1, 'L', N'Đế dày', 180000, 8, 20000),
    (91, 17, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (91, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 92 (TotalAmount 380,000, ShippingFee 20,000, PromotionID NULL, Target 360,000)
    (92, 18, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (92, 29, 1, NULL, NULL, 80000, NULL, 0),
    (92, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 93 (TotalAmount 620,000, ShippingFee 15,000, PromotionID 2, Target 605,000)
    (93, 19, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (93, 20, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (93, 30, 1, NULL, NULL, 80000, NULL, 0),
    (93, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 94 (TotalAmount 320,000, ShippingFee 0, PromotionID 3, Target 320,000)
    (94, 21, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (94, 31, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 95 (TotalAmount 540,000, ShippingFee 20,000, PromotionID 1, Target 520,000)
    (95, 22, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (95, 23, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (95, 32, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 96 (TotalAmount 430,000, ShippingFee 15,000, PromotionID NULL, Target 415,000)
    (96, 24, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (96, 33, 1, NULL, NULL, 80000, NULL, 0),
    (96, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 97 (TotalAmount 490,000, ShippingFee 20,000, PromotionID 2, Target 470,000)
    (97, 25, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (97, 26, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (97, 34, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 98 (TotalAmount 390,000, ShippingFee 0, PromotionID 3, Target 390,000)
    (98, 27, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (98, 35, 1, NULL, NULL, 90000, NULL, 0),
    (98, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 99 (TotalAmount 630,000, ShippingFee 15,000, PromotionID 1, Target 615,000)
    (99, 1, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (99, 2, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (99, 36, 1, NULL, NULL, 90000, NULL, 0),
    (99, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 100 (TotalAmount 450,000, ShippingFee 20,000, PromotionID NULL, Target 430,000)
    (100, 3, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (100, 37, 1, NULL, NULL, 90000, NULL, 0),
    (100, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 101 (TotalAmount 450,000, ShippingFee 20,000, PromotionID 2, Target 430,000)
    (101, 4, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (101, 5, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (101, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 102 (TotalAmount 400,000, ShippingFee 15,000, PromotionID NULL, Target 385,000)
    (102, 6, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (102, 39, 1, NULL, NULL, 90000, NULL, 0),
    (102, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 103 (TotalAmount 640,000, ShippingFee 20,000, PromotionID 3, Target 620,000)
    (103, 7, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (103, 8, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (103, 40, 1, NULL, NULL, 90000, NULL, 0),
    (103, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 104 (TotalAmount 340,000, ShippingFee 0, PromotionID 1, Target 340,000)
    (104, 9, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (104, 41, 1, NULL, NULL, 90000, NULL, 0),
    (104, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 105 (TotalAmount 560,000, ShippingFee 15,000, PromotionID 2, Target 545,000)
    (105, 10, 1, 'L', N'Đế dày', 180000, 13, 20000),
    (105, 11, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (105, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 106 (TotalAmount 450,000, ShippingFee 20,000, PromotionID NULL, Target 430,000)
    (106, 12, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (106, 29, 1, NULL, NULL, 80000, NULL, 0),
    (106, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 107 (TotalAmount 510,000, ShippingFee 15,000, PromotionID 3, Target 495,000)
    (107, 13, 1, 'L', N'Đế dày', 180000, 16, 20000),
    (107, 14, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (107, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 108 (TotalAmount 410,000, ShippingFee 0, PromotionID 1, Target 410,000)
    (108, 15, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (108, 31, 1, NULL, NULL, 80000, NULL, 0),
    (108, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 109 (TotalAmount 650,000, ShippingFee 20,000, PromotionID 2, Target 630,000)
    (109, 16, 1, 'L', N'Đế dày', 180000, 3, 25000),
    (109, 17, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (109, 32, 1, NULL, NULL, 80000, NULL, 0),
    (109, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 110 (TotalAmount 470,000, ShippingFee 15,000, PromotionID NULL, Target 455,000)
    (110, 18, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (110, 33, 1, NULL, NULL, 80000, NULL, 0),
    (110, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 111 (TotalAmount 470,000, ShippingFee 15,000, PromotionID 3, Target 455,000)
    (111, 19, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (111, 20, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (111, 34, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 112 (TotalAmount 420,000, ShippingFee 20,000, PromotionID NULL, Target 400,000)
    (112, 21, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (112, 35, 1, NULL, NULL, 90000, NULL, 0),
    (112, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 113 (TotalAmount 660,000, ShippingFee 15,000, PromotionID 1, Target 645,000)
    (113, 22, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (113, 23, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (113, 36, 1, NULL, NULL, 90000, NULL, 0),
    (113, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 114 (TotalAmount 360,000, ShippingFee 0, PromotionID 2, Target 360,000)
    (114, 24, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (114, 37, 1, NULL, NULL, 90000, NULL, 0),
    (114, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 115 (TotalAmount 580,000, ShippingFee 20,000, PromotionID 3, Target 560,000)
    (115, 25, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (115, 26, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (115, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 116 (TotalAmount 470,000, ShippingFee 15,000, PromotionID NULL, Target 455,000)
    (116, 27, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (116, 39, 1, NULL, NULL, 90000, NULL, 0),
    (116, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 117 (TotalAmount 530,000, ShippingFee 20,000, PromotionID 1, Target 510,000)
    (117, 1, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (117, 2, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (117, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 118 (TotalAmount 430,000, ShippingFee 0, PromotionID 2, Target 430,000)
    (118, 3, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (118, 41, 1, NULL, NULL, 90000, NULL, 0),
    (118, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 119 (TotalAmount 670,000, ShippingFee 15,000, PromotionID 3, Target 655,000)
    (119, 4, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (119, 5, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (119, 28, 1, NULL, NULL, 80000, NULL, 0),
    (119, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 120 (TotalAmount 490,000, ShippingFee 20,000, PromotionID NULL, Target 470,000)
    (120, 6, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (120, 29, 1, NULL, NULL, 80000, NULL, 0),
    (120, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 121 (TotalAmount 490,000, ShippingFee 20,000, PromotionID 1, Target 470,000)
    (121, 7, 1, 'L', N'Đế dày', 180000, 5, 20000),
    (121, 8, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (121, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 122 (TotalAmount 440,000, ShippingFee 15,000, PromotionID NULL, Target 425,000)
    (122, 9, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (122, 31, 1, NULL, NULL, 80000, NULL, 0),
    (122, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 123 (TotalAmount 680,000, ShippingFee 20,000, PromotionID 2, Target 660,000)
    (123, 10, 1, 'L', N'Đế dày', 180000, 8, 20000),
    (123, 11, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (123, 32, 1, NULL, NULL, 80000, NULL, 0),
    (123, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 124 (TotalAmount 380,000, ShippingFee 0, PromotionID 3, Target 380,000)
    (124, 12, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (124, 33, 1, NULL, NULL, 80000, NULL, 0),
    (124, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 125 (TotalAmount 600,000, ShippingFee 15,000, PromotionID 1, Target 585,000)
    (125, 13, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (125, 14, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (125, 34, 1, NULL, NULL, 80000, NULL, 0),
    (125, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 126 (TotalAmount 490,000, ShippingFee 20,000, PromotionID NULL, Target 470,000)
    (126, 15, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (126, 35, 1, NULL, NULL, 90000, NULL, 0),
    (126, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 127 (TotalAmount 550,000, ShippingFee 15,000, PromotionID 2, Target 535,000)
    (127, 16, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (127, 17, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (127, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 128 (TotalAmount 450,000, ShippingFee 0, PromotionID 3, Target 450,000)
    (128, 18, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (128, 37, 1, NULL, NULL, 90000, NULL, 0),
    (128, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 129 (TotalAmount 690,000, ShippingFee 20,000, PromotionID 1, Target 670,000)
    (129, 19, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (129, 20, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (129, 38, 1, NULL, NULL, 90000, NULL, 0),
    (129, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 130 (TotalAmount 510,000, ShippingFee 15,000, PromotionID NULL, Target 495,000)
    (130, 21, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (130, 39, 1, NULL, NULL, 90000, NULL, 0),
    (130, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 131 (TotalAmount 510,000, ShippingFee 15,000, PromotionID 2, Target 495,000)
    (131, 22, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (131, 23, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (131, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 132 (TotalAmount 460,000, ShippingFee 20,000, PromotionID NULL, Target 440,000)
    (132, 24, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (132, 41, 1, NULL, NULL, 90000, NULL, 0),
    (132, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 133 (TotalAmount 700,000, ShippingFee 15,000, PromotionID 3, Target 685,000)
    (133, 25, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (133, 26, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (133, 28, 1, NULL, NULL, 80000, NULL, 0),
    (133, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 134 (TotalAmount 400,000, ShippingFee 0, PromotionID 1, Target 400,000)
    (134, 27, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (134, 29, 1, NULL, NULL, 80000, NULL, 0),
    (134, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 135 (TotalAmount 620,000, ShippingFee 20,000, PromotionID 2, Target 600,000)
    (135, 1, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (135, 2, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (135, 30, 1, NULL, NULL, 80000, NULL, 0),
    (135, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 136 (TotalAmount 510,000, ShippingFee 15,000, PromotionID NULL, Target 495,000)
    (136, 3, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (136, 31, 1, NULL, NULL, 80000, NULL, 0),
    (136, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 137 (TotalAmount 570,000, ShippingFee 20,000, PromotionID 3, Target 550,000)
    (137, 4, 1, 'L', N'Đế dày', 180000, 13, 20000),
    (137, 5, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (137, 32, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 138 (TotalAmount 470,000, ShippingFee 0, PromotionID 1, Target 470,000)
    (138, 6, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (138, 33, 1, NULL, NULL, 80000, NULL, 0),
    (138, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 139 (TotalAmount 710,000, ShippingFee 15,000, PromotionID 2, Target 695,000)
    (139, 7, 1, 'L', N'Đế dày', 180000, 16, 20000),
    (139, 8, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (139, 34, 1, NULL, NULL, 80000, NULL, 0),
    (139, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 140 (TotalAmount 530,000, ShippingFee 20,000, PromotionID NULL, Target 510,000)
    (140, 9, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (140, 35, 1, NULL, NULL, 90000, NULL, 0),
    (140, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 141 (TotalAmount 530,000, ShippingFee 20,000, PromotionID 3, Target 510,000)
    (141, 10, 1, 'L', N'Đế dày', 180000, 3, 25000),
    (141, 11, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (141, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 142 (TotalAmount 480,000, ShippingFee 15,000, PromotionID NULL, Target 465,000)
    (142, 12, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (142, 37, 1, NULL, NULL, 90000, NULL, 0),
    (142, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 143 (TotalAmount 720,000, ShippingFee 20,000, PromotionID 1, Target 700,000)
    (143, 13, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (143, 14, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (143, 38, 1, NULL, NULL, 90000, NULL, 0),
    (143, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 144 (TotalAmount 420,000, ShippingFee 0, PromotionID 2, Target 420,000)
    (144, 15, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (144, 39, 1, NULL, NULL, 90000, NULL, 0),
    (144, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 145 (TotalAmount 640,000, ShippingFee 15,000, PromotionID 3, Target 625,000)
    (145, 16, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (145, 17, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (145, 40, 1, NULL, NULL, 90000, NULL, 0),
    (145, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 146 (TotalAmount 530,000, ShippingFee 20,000, PromotionID NULL, Target 510,000)
    (146, 18, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (146, 41, 1, NULL, NULL, 90000, NULL, 0),
    (146, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 147 (TotalAmount 590,000, ShippingFee 15,000, PromotionID 1, Target 575,000)
    (147, 19, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (147, 20, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (147, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 148 (TotalAmount 490,000, ShippingFee 0, PromotionID 2, Target 490,000)
    (148, 21, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (148, 29, 1, NULL, NULL, 80000, NULL, 0),
    (148, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 149 (TotalAmount 730,000, ShippingFee 20,000, PromotionID 3, Target 710,000)
    (149, 22, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (149, 23, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (149, 30, 1, NULL, NULL, 80000, NULL, 0),
    (149, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 150 (TotalAmount 550,000, ShippingFee 15,000, PromotionID NULL, Target 535,000)
    (150, 24, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (150, 31, 1, NULL, NULL, 80000, NULL, 0),
    (150, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 151 (TotalAmount 550,000, ShippingFee 15,000, PromotionID 1, Target 535,000)
    (151, 25, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (151, 32, 1, NULL, NULL, 80000, NULL, 0),
    (151, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 152 (TotalAmount 500,000, ShippingFee 20,000, PromotionID NULL, Target 480,000)
    (152, 26, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (152, 33, 1, NULL, NULL, 80000, NULL, 0),
    (152, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 153 (TotalAmount 740,000, ShippingFee 15,000, PromotionID 2, Target 725,000)
    (153, 27, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (153, 1, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (153, 34, 1, NULL, NULL, 80000, NULL, 0),
    (153, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 154 (TotalAmount 440,000, ShippingFee 0, PromotionID 3, Target 440,000)
    (154, 2, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (154, 35, 1, NULL, NULL, 90000, NULL, 0),
    (154, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 155 (TotalAmount 660,000, ShippingFee 20,000, PromotionID 1, Target 640,000)
    (155, 3, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (155, 4, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (155, 36, 1, NULL, NULL, 90000, NULL, 0),
    (155, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 156 (TotalAmount 550,000, ShippingFee 15,000, PromotionID NULL, Target 535,000)
    (156, 5, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (156, 37, 1, NULL, NULL, 90000, NULL, 0),
    (156, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 157 (TotalAmount 610,000, ShippingFee 20,000, PromotionID 2, Target 590,000)
    (157, 6, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (157, 7, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (157, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 158 (TotalAmount 510,000, ShippingFee 0, PromotionID 3, Target 510,000)
    (158, 8, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (158, 39, 1, NULL, NULL, 90000, NULL, 0),
    (158, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 159 (TotalAmount 750,000, ShippingFee 15,000, PromotionID 1, Target 735,000)
    (159, 9, 1, 'L', N'Đế dày', 180000, 13, 20000),
    (159, 10, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (159, 40, 1, NULL, NULL, 90000, NULL, 0),
    (159, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 160 (TotalAmount 570,000, ShippingFee 20,000, PromotionID NULL, Target 550,000)
    (160, 11, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (160, 41, 1, NULL, NULL, 90000, NULL, 0),
    (160, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 161 (TotalAmount 570,000, ShippingFee 20,000, PromotionID 2, Target 550,000)
    (161, 12, 1, 'L', N'Đế dày', 180000, 16, 20000),
    (161, 13, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (161, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 162 (TotalAmount 520,000, ShippingFee 15,000, PromotionID NULL, Target 505,000)
    (162, 14, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (162, 29, 1, NULL, NULL, 80000, NULL, 0),
    (162, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 163 (TotalAmount 760,000, ShippingFee 20,000, PromotionID 3, Target 740,000)
    (163, 15, 1, 'L', N'Đế dày', 180000, 3, 25000),
    (163, 16, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (163, 30, 1, NULL, NULL, 80000, NULL, 0),
    (163, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 164 (TotalAmount 460,000, ShippingFee 0, PromotionID 1, Target 460,000)
    (164, 17, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (164, 31, 1, NULL, NULL, 80000, NULL, 0),
    (164, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 165 (TotalAmount 680,000, ShippingFee 15,000, PromotionID 2, Target 665,000)
    (165, 18, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (165, 19, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (165, 32, 1, NULL, NULL, 80000, NULL, 0),
    (165, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 166 (TotalAmount 570,000, ShippingFee 20,000, PromotionID NULL, Target 550,000)
    (166, 20, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (166, 33, 1, NULL, NULL, 80000, NULL, 0),
    (166, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 167 (TotalAmount 630,000, ShippingFee 15,000, PromotionID 3, Target 615,000)
    (167, 21, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (167, 22, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (167, 34, 1, NULL, NULL, 80000, NULL, 0),
    (167, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 168 (TotalAmount 530,000, ShippingFee 0, PromotionID 1, Target 530,000)
    (168, 23, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (168, 35, 1, NULL, NULL, 90000, NULL, 0),
    (168, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 169 (TotalAmount 770,000, ShippingFee 20,000, PromotionID 2, Target 750,000)
    (169, 24, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (169, 25, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (169, 36, 1, NULL, NULL, 90000, NULL, 0),
    (169, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 170 (TotalAmount 590,000, ShippingFee 15,000, PromotionID NULL, Target 575,000)
    (170, 26, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (170, 37, 1, NULL, NULL, 90000, NULL, 0),
    (170, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 171 (TotalAmount 590,000, ShippingFee 15,000, PromotionID 3, Target 575,000)
    (171, 27, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (171, 1, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (171, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 172 (TotalAmount 540,000, ShippingFee 20,000, PromotionID NULL, Target 520,000)
    (172, 2, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (172, 39, 1, NULL, NULL, 90000, NULL, 0),
    (172, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 173 (TotalAmount 780,000, ShippingFee 15,000, PromotionID 1, Target 765,000)
    (173, 3, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (173, 4, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (173, 40, 1, NULL, NULL, 90000, NULL, 0),
    (173, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 174 (TotalAmount 480,000, ShippingFee 0, PromotionID 2, Target 480,000)
    (174, 5, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (174, 41, 1, NULL, NULL, 90000, NULL, 0),
    (174, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 175 (TotalAmount 700,000, ShippingFee 20,000, PromotionID 3, Target 680,000)
    (175, 6, 1, 'L', N'Đế dày', 180000, 5, 20000),
    (175, 7, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (175, 28, 1, NULL, NULL, 80000, NULL, 0),
    (175, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 176 (TotalAmount 590,000, ShippingFee 15,000, PromotionID NULL, Target 575,000)
    (176, 8, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (176, 29, 1, NULL, NULL, 80000, NULL, 0),
    (176, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 177 (TotalAmount 650,000, ShippingFee 20,000, PromotionID 1, Target 630,000)
    (177, 9, 1, 'L', N'Đế dày', 180000, 8, 20000),
    (177, 10, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (177, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 178 (TotalAmount 550,000, ShippingFee 0, PromotionID 2, Target 550,000)
    (178, 11, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (178, 31, 1, NULL, NULL, 80000, NULL, 0),
    (178, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 179 (TotalAmount 790,000, ShippingFee 15,000, PromotionID 3, Target 775,000)
    (179, 12, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (179, 13, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (179, 32, 1, NULL, NULL, 80000, NULL, 0),
    (179, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 180 (TotalAmount 610,000, ShippingFee 20,000, PromotionID NULL, Target 590,000)
    (180, 14, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (180, 33, 1, NULL, NULL, 80000, NULL, 0),
    (180, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 181 (TotalAmount 610,000, ShippingFee 20,000, PromotionID 1, Target 590,000)
    (181, 15, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (181, 16, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (181, 34, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 182 (TotalAmount 560,000, ShippingFee 15,000, PromotionID NULL, Target 545,000)
    (182, 17, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (182, 35, 1, NULL, NULL, 90000, NULL, 0),
    (182, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 183 (TotalAmount 800,000, ShippingFee 20,000, PromotionID 2, Target 780,000)
    (183, 18, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (183, 19, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (183, 36, 1, NULL, NULL, 90000, NULL, 0),
    (183, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 184 (TotalAmount 500,000, ShippingFee 0, PromotionID 3, Target 500,000)
    (184, 20, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (184, 37, 1, NULL, NULL, 90000, NULL, 0),
    (184, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 185 (TotalAmount 720,000, ShippingFee 15,000, PromotionID 1, Target 705,000)
    (185, 21, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (185, 22, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (185, 38, 1, NULL, NULL, 90000, NULL, 0),
    (185, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 186 (TotalAmount 610,000, ShippingFee 20,000, PromotionID NULL, Target 590,000)
    (186, 23, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (186, 39, 1, NULL, NULL, 90000, NULL, 0),
    (186, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 187 (TotalAmount 670,000, ShippingFee 15,000, PromotionID 2, Target 655,000)
    (187, 24, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (187, 25, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (187, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 188 (TotalAmount 570,000, ShippingFee 0, PromotionID 3, Target 570,000)
    (188, 26, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (188, 41, 1, NULL, NULL, 90000, NULL, 0),
    (188, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 189 (TotalAmount 810,000, ShippingFee 20,000, PromotionID 1, Target 790,000)
    (189, 27, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (189, 1, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (189, 28, 1, NULL, NULL, 80000, NULL, 0),
    (189, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 190 (TotalAmount 630,000, ShippingFee 15,000, PromotionID NULL, Target 615,000)
    (190, 2, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (190, 29, 1, NULL, NULL, 80000, NULL, 0),
    (190, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 191 (TotalAmount 630,000, ShippingFee 15,000, PromotionID 2, Target 615,000)
    (191, 3, 1, 'L', N'Đế dày', 180000, 13, 20000),
    (191, 4, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (191, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 192 (TotalAmount 580,000, ShippingFee 20,000, PromotionID NULL, Target 560,000)
    (192, 5, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (192, 31, 1, NULL, NULL, 80000, NULL, 0),
    (192, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 193 (TotalAmount 820,000, ShippingFee 15,000, PromotionID 3, Target 805,000)
    (193, 6, 1, 'L', N'Đế dày', 180000, 16, 20000),
    (193, 7, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (193, 32, 1, NULL, NULL, 80000, NULL, 0),
    (193, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 194 (TotalAmount 520,000, ShippingFee 0, PromotionID 1, Target 520,000)
    (194, 8, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (194, 33, 1, NULL, NULL, 80000, NULL, 0),
    (194, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 195 (TotalAmount 740,000, ShippingFee 20,000, PromotionID 2, Target 720,000)
    (195, 9, 1, 'L', N'Đế dày', 180000, 3, 25000),
    (195, 10, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (195, 34, 1, NULL, NULL, 80000, NULL, 0),
    (195, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 196 (TotalAmount 630,000, ShippingFee 15,000, PromotionID NULL, Target 615,000)
    (196, 11, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (196, 35, 1, NULL, NULL, 90000, NULL, 0),
    (196, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 197 (TotalAmount 690,000, ShippingFee 20,000, PromotionID 3, Target 670,000)
    (197, 12, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (197, 13, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (197, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 198 (TotalAmount 590,000, ShippingFee 0, PromotionID 1, Target 590,000)
    (198, 14, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (198, 37, 1, NULL, NULL, 90000, NULL, 0),
    (198, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 199 (TotalAmount 830,000, ShippingFee 15,000, PromotionID 2, Target 815,000)
    (199, 15, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (199, 16, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (199, 38, 1, NULL, NULL, 90000, NULL, 0),
    (199, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 200 (TotalAmount 650,000, ShippingFee 20,000, PromotionID NULL, Target 630,000)
    (200, 17, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (200, 39, 1, NULL, NULL, 90000, NULL, 0),
    (200, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 201 (TotalAmount 650,000, ShippingFee 20,000, PromotionID 3, Target 630,000)
    (201, 18, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (201, 19, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (201, 40, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 202 (TotalAmount 600,000, ShippingFee 15,000, PromotionID NULL, Target 585,000)
    (202, 20, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (202, 41, 1, NULL, NULL, 90000, NULL, 0),
    (202, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 203 (TotalAmount 840,000, ShippingFee 20,000, PromotionID 1, Target 820,000)
    (203, 21, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (203, 22, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (203, 28, 1, NULL, NULL, 80000, NULL, 0),
    (203, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 204 (TotalAmount 540,000, ShippingFee 0, PromotionID 2, Target 540,000)
    (204, 23, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (204, 29, 1, NULL, NULL, 80000, NULL, 0),
    (204, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 205 (TotalAmount 760,000, ShippingFee 15,000, PromotionID 3, Target 745,000)
    (205, 24, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (205, 25, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (205, 30, 1, NULL, NULL, 80000, NULL, 0),
    (205, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 206 (TotalAmount 650,000, ShippingFee 20,000, PromotionID NULL, Target 630,000)
    (206, 26, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (206, 31, 1, NULL, NULL, 80000, NULL, 0),
    (206, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 207 (TotalAmount 710,000, ShippingFee 15,000, PromotionID 1, Target 695,000)
    (207, 27, 1, 'L', N'Đế dày', 180000, 5, 20000),
    (207, 1, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (207, 32, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 208 (TotalAmount 610,000, ShippingFee 0, PromotionID 2, Target 610,000)
    (208, 2, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (208, 33, 1, NULL, NULL, 80000, NULL, 0),
    (208, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 209 (TotalAmount 850,000, ShippingFee 20,000, PromotionID 3, Target 830,000)
    (209, 3, 1, 'L', N'Đế dày', 180000, 8, 20000),
    (209, 4, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (209, 34, 1, NULL, NULL, 80000, NULL, 0),
    (209, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 210 (TotalAmount 670,000, ShippingFee 15,000, PromotionID NULL, Target 655,000)
    (210, 5, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (210, 35, 1, NULL, NULL, 90000, NULL, 0),
    (210, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 211 (TotalAmount 670,000, ShippingFee 15,000, PromotionID 1, Target 655,000)
    (211, 6, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (211, 7, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (211, 36, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 212 (TotalAmount 620,000, ShippingFee 20,000, PromotionID NULL, Target 600,000)
    (212, 8, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (212, 37, 1, NULL, NULL, 90000, NULL, 0),
    (212, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 213 (TotalAmount 860,000, ShippingFee 15,000, PromotionID 2, Target 845,000)
    (213, 9, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (213, 10, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (213, 38, 1, NULL, NULL, 90000, NULL, 0),
    (213, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 214 (TotalAmount 560,000, ShippingFee 0, PromotionID 3, Target 560,000)
    (214, 11, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (214, 39, 1, NULL, NULL, 90000, NULL, 0),
    (214, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 215 (TotalAmount 780,000, ShippingFee 20,000, PromotionID 1, Target 760,000)
    (215, 12, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (215, 13, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (215, 40, 1, NULL, NULL, 90000, NULL, 0),
    (215, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 216 (TotalAmount 670,000, ShippingFee 15,000, PromotionID NULL, Target 655,000)
    (216, 14, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (216, 41, 1, NULL, NULL, 90000, NULL, 0),
    (216, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 217 (TotalAmount 730,000, ShippingFee 20,000, PromotionID 2, Target 710,000)
    (217, 15, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (217, 16, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (217, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 218 (TotalAmount 630,000, ShippingFee 0, PromotionID 3, Target 630,000)
    (218, 17, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (218, 29, 1, NULL, NULL, 80000, NULL, 0),
    (218, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 219 (TotalAmount 870,000, ShippingFee 15,000, PromotionID 1, Target 855,000)
    (219, 18, 1, 'L', N'Đế dày', 180000, 7, 15000),
    (219, 19, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (219, 30, 1, NULL, NULL, 80000, NULL, 0),
    (219, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 220 (TotalAmount 690,000, ShippingFee 20,000, PromotionID NULL, Target 670,000)
    (220, 20, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (220, 31, 1, NULL, NULL, 80000, NULL, 0),
    (220, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 221 (TotalAmount 690,000, ShippingFee 20,000, PromotionID 2, Target 670,000)
    (221, 21, 1, 'L', N'Đế dày', 180000, 10, 15000),
    (221, 22, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (221, 32, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 222 (TotalAmount 640,000, ShippingFee 15,000, PromotionID NULL, Target 625,000)
    (222, 23, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (222, 33, 1, NULL, NULL, 80000, NULL, 0),
    (222, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 223 (TotalAmount 880,000, ShippingFee 20,000, PromotionID 3, Target 860,000)
    (223, 24, 1, 'L', N'Đế dày', 180000, 13, 20000),
    (223, 25, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (223, 34, 1, NULL, NULL, 80000, NULL, 0),
    (223, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 224 (TotalAmount 580,000, ShippingFee 0, PromotionID 1, Target 580,000)
    (224, 26, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (224, 35, 1, NULL, NULL, 90000, NULL, 0),
    (224, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 225 (TotalAmount 800,000, ShippingFee 15,000, PromotionID 2, Target 785,000)
    (225, 27, 1, 'L', N'Đế dày', 180000, 16, 20000),
    (225, 1, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (225, 36, 1, NULL, NULL, 90000, NULL, 0),
    (225, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 226 (TotalAmount 690,000, ShippingFee 20,000, PromotionID NULL, Target 670,000)
    (226, 2, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (226, 37, 1, NULL, NULL, 90000, NULL, 0),
    (226, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 227 (TotalAmount 750,000, ShippingFee 15,000, PromotionID 3, Target 735,000)
    (227, 3, 1, 'L', N'Đế dày', 180000, 3, 25000),
    (227, 4, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (227, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 228 (TotalAmount 650,000, ShippingFee 0, PromotionID 1, Target 650,000)
    (228, 5, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (228, 39, 1, NULL, NULL, 90000, NULL, 0),
    (228, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 229 (TotalAmount 890,000, ShippingFee 20,000, PromotionID 2, Target 870,000)
    (229, 6, 1, 'L', N'Đế dày', 180000, 6, 25000),
    (229, 7, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (229, 40, 1, NULL, NULL, 90000, NULL, 0),
    (229, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 230 (TotalAmount 710,000, ShippingFee 15,000, PromotionID NULL, Target 695,000)
    (230, 8, 1, 'L', N'Đế mỏng', 180000, 8, 20000),
    (230, 41, 1, NULL, NULL, 90000, NULL, 0),
    (230, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 231 (TotalAmount 710,000, ShippingFee 15,000, PromotionID 3, Target 695,000)
    (231, 9, 1, 'L', N'Đế dày', 180000, 9, 15000),
    (231, 10, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (231, 28, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 232 (TotalAmount 660,000, ShippingFee 20,000, PromotionID NULL, Target 640,000)
    (232, 11, 1, 'L', N'Đế mỏng', 180000, 11, 10000),
    (232, 29, 1, NULL, NULL, 80000, NULL, 0),
    (232, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 233 (TotalAmount 900,000, ShippingFee 15,000, PromotionID 1, Target 885,000)
    (233, 12, 1, 'L', N'Đế dày', 180000, 12, 10000),
    (233, 13, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (233, 30, 1, NULL, NULL, 80000, NULL, 0),
    (233, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 234 (TotalAmount 600,000, ShippingFee 0, PromotionID 2, Target 600,000)
    (234, 14, 1, 'L', N'Đế mỏng', 180000, 14, 20000),
    (234, 31, 1, NULL, NULL, 80000, NULL, 0),
    (234, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 235 (TotalAmount 820,000, ShippingFee 20,000, PromotionID 3, Target 800,000)
    (235, 15, 1, 'L', N'Đế dày', 180000, 15, 20000),
    (235, 16, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (235, 32, 1, NULL, NULL, 80000, NULL, 0),
    (235, 52, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 236 (TotalAmount 710,000, ShippingFee 15,000, PromotionID NULL, Target 695,000)
    (236, 17, 1, 'L', N'Đế mỏng', 180000, 1, 20000),
    (236, 33, 1, NULL, NULL, 80000, NULL, 0),
    (236, 53, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 237 (TotalAmount 770,000, ShippingFee 20,000, PromotionID 1, Target 750,000)
    (237, 18, 1, 'L', N'Đế dày', 180000, 2, 30000),
    (237, 19, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (237, 34, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 238 (TotalAmount 670,000, ShippingFee 0, PromotionID 2, Target 670,000)
    (238, 20, 1, 'L', N'Đế mỏng', 180000, 4, 25000),
    (238, 35, 1, NULL, NULL, 90000, NULL, 0),
    (238, 54, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 239 (TotalAmount 910,000, ShippingFee 15,000, PromotionID 3, Target 895,000)
    (239, 21, 1, 'L', N'Đế dày', 180000, 5, 20000),
    (239, 22, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (239, 36, 1, NULL, NULL, 90000, NULL, 0),
    (239, 55, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 240 (TotalAmount 730,000, ShippingFee 20,000, PromotionID NULL, Target 710,000)
    (240, 23, 1, 'L', N'Đế mỏng', 180000, 7, 15000),
    (240, 37, 1, NULL, NULL, 90000, NULL, 0),
    (240, 56, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 241 (TotalAmount 730,000, ShippingFee 20,000, PromotionID 1, Target 710,000)
    (241, 24, 1, 'L', N'Đế dày', 180000, 8, 20000),
    (241, 25, 1, 'L', N'Đế mỏng', 180000, 9, 15000),
    (241, 38, 1, NULL, NULL, 90000, NULL, 0),
    -- OrderID 242 (TotalAmount 680,000, ShippingFee 15,000, PromotionID NULL, Target 665,000)
    (242, 26, 1, 'L', N'Đế mỏng', 180000, 10, 15000),
    (242, 39, 1, NULL, NULL, 90000, NULL, 0),
    (242, 57, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 243 (TotalAmount 920,000, ShippingFee 20,000, PromotionID 2, Target 900,000)
    (243, 27, 1, 'L', N'Đế dày', 180000, 11, 10000),
    (243, 1, 1, 'L', N'Đế mỏng', 180000, 12, 10000),
    (243, 40, 1, NULL, NULL, 90000, NULL, 0),
    (243, 58, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 244 (TotalAmount 620,000, ShippingFee 0, PromotionID 3, Target 620,000)
    (244, 2, 1, 'L', N'Đế mỏng', 180000, 13, 20000),
    (244, 41, 1, NULL, NULL, 90000, NULL, 0),
    (244, 59, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 245 (TotalAmount 840,000, ShippingFee 15,000, PromotionID 1, Target 825,000)
    (245, 3, 1, 'L', N'Đế dày', 180000, 14, 20000),
    (245, 4, 1, 'L', N'Đế mỏng', 180000, 15, 20000),
    (245, 28, 1, NULL, NULL, 80000, NULL, 0),
    (245, 60, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 246 (TotalAmount 730,000, ShippingFee 20,000, PromotionID NULL, Target 710,000)
    (246, 5, 1, 'L', N'Đế mỏng', 180000, 16, 20000),
    (246, 29, 1, NULL, NULL, 80000, NULL, 0),
    (246, 61, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 247 (TotalAmount 790,000, ShippingFee 15,000, PromotionID 2, Target 775,000)
    (247, 6, 1, 'L', N'Đế dày', 180000, 1, 20000),
    (247, 7, 1, 'L', N'Đế mỏng', 180000, 2, 30000),
    (247, 30, 1, NULL, NULL, 80000, NULL, 0),
    -- OrderID 248 (TotalAmount 690,000, ShippingFee 0, PromotionID 3, Target 690,000)
    (248, 8, 1, 'L', N'Đế mỏng', 180000, 3, 25000),
    (248, 31, 1, NULL, NULL, 80000, NULL, 0),
    (248, 62, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 249 (TotalAmount 930,000, ShippingFee 20,000, PromotionID 1, Target 910,000)
    (249, 9, 1, 'L', N'Đế dày', 180000, 4, 25000),
    (249, 10, 1, 'L', N'Đế mỏng', 180000, 5, 20000),
    (249, 32, 1, NULL, NULL, 80000, NULL, 0),
    (249, 63, 1, NULL, NULL, 30000, NULL, 0),
    -- OrderID 250 (TotalAmount 710,000, ShippingFee 15,000, PromotionID NULL, Target 695,000)
    (250, 11, 1, 'L', N'Đế mỏng', 180000, 6, 25000),
    (250, 33, 1, NULL, NULL, 80000, NULL, 0),
    (250, 52, 1, NULL, NULL, 30000, NULL, 0);
-- 9.11 Feedbacks
INSERT INTO Feedbacks (OrderID, UserID, CrustRating, SauceRating, CheeseRating, ToppingRating, OverallTasteRating, PresentationRating, ServiceRating, Comment, CreatedDate) VALUES
    -- User 1: Orders 1-10 (6 positive, 4 negative)
    (1, 1, 5, 4, 5, 4, 5, 5, 4, N'Pizza ngon, giao nhanh.', '2025-04-02 09:00:00'),
    (2, 1, 4, 5, 4, 5, 5, 4, 5, N'Đế giòn, topping tươi ngon.', '2025-04-02 10:30:00'),
    (3, 1, 3, 4, 3, 4, 3, 4, 2, N'Giao hàng chậm, đế hơi mềm.', '2025-04-02 12:00:00'),
    (4, 1, 2, 3, 4, 3, 3, 3, 4, N'Sốt nhạt, topping ít.', '2025-04-02 13:30:00'),
    (5, 1, 5, 4, 4, 5, 5, 5, 4, N'Topping đa dạng, đáng thử.', '2025-04-02 15:00:00'),
    (6, 1, 4, 5, 5, 4, 4, 4, 5, N'Sốt đậm đà, đế mỏng vừa ý.', '2025-04-02 16:30:00'),
    (7, 1, 3, 3, 4, 3, 3, 4, 3, N'Pizza nguội, giao hàng lâu.', '2025-04-02 18:00:00'),
    (8, 1, 4, 4, 5, 4, 4, 5, 5, N'Hương vị ổn, đóng gói đẹp.', '2025-04-02 19:30:00'),
    (9, 1, 5, 5, 5, 5, 5, 4, 4, N'Tất cả đều hoàn hảo!', '2025-04-02 21:00:00'),
    (10, 1, 3, 4, 3, 3, 3, 3, 2, N'Đế cháy, giao hàng trễ.', '2025-04-02 22:30:00'),
    -- User 2: Orders 11-20 (6 positive, 4 negative)
    (11, 2, 5, 4, 5, 5, 5, 4, 4, N'Pizza ngon, rất đáng tiền.', '2025-04-03 09:00:00'),
    (12, 2, 4, 5, 4, 4, 5, 5, 5, N'Sốt pizza đậm đà, thích lắm.', '2025-04-03 10:30:00'),
    (13, 2, 3, 3, 4, 3, 3, 4, 3, N'Topping ít, sốt quá mặn.', '2025-04-03 12:00:00'),
    (14, 2, 4, 4, 5, 5, 5, 5, 4, N'Topping tươi, đế giòn rụm.', '2025-04-03 13:30:00'),
    (15, 2, 2, 3, 3, 4, 3, 3, 2, N'Pizza nguội, giao chậm.', '2025-04-03 15:00:00'),
    (16, 2, 4, 5, 5, 5, 4, 5, 4, N'Hài lòng, sẽ gọi lại.', '2025-04-03 16:30:00'),
    (17, 2, 5, 4, 4, 5, 5, 5, 5, N'Đế dày mềm, topping ngon.', '2025-04-03 18:00:00'),
    (18, 2, 3, 4, 3, 3, 3, 4, 3, N'Hương vị bình thường, đế mềm.', '2025-04-03 19:30:00'),
    (19, 2, 5, 5, 4, 5, 5, 5, 4, N'Tuyệt vời, rất đáng thử.', '2025-04-03 21:00:00'),
    (20, 2, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, pizza nhạt.', '2025-04-03 22:30:00'),
    -- User 3: Orders 21-30 (6 positive, 4 negative)
    (21, 3, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-04 09:00:00'),
    (22, 3, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-04 10:30:00'),
    (23, 3, 3, 3, 4, 3, 3, 4, 3, N'Topping ít, giao hàng chậm.', '2025-04-04 12:00:00'),
    (24, 3, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-04 13:30:00'),
    (25, 3, 2, 3, 3, 4, 3, 3, 2, N'Sốt nhạt, đế không giòn.', '2025-04-04 15:00:00'),
    (26, 3, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-04 16:30:00'),
    (27, 3, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-04 18:00:00'),
    (28, 3, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-04 19:30:00'),
    (29, 3, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-04 21:00:00'),
    (30, 3, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-04 22:30:00'),
    -- User 4: Orders 31-40 (6 positive, 4 negative)
    (31, 4, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-05 09:00:00'),
    (32, 4, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-05 10:30:00'),
    (33, 4, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá ngọt.', '2025-04-05 12:00:00'),
    (34, 4, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-05 13:30:00'),
    (35, 4, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-05 15:00:00'),
    (36, 4, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-05 16:30:00'),
    (37, 4, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-05 18:00:00'),
    (38, 4, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-05 19:30:00'),
    (39, 4, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-05 21:00:00'),
    (40, 4, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-05 22:30:00'),
    -- User 5: Orders 41-50 (6 positive, 4 negative)
    (41, 5, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-06 09:00:00'),
    (42, 5, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-06 10:30:00'),
    (43, 5, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-06 12:00:00'),
    (44, 5, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-06 13:30:00'),
    (45, 5, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-06 15:00:00'),
    (46, 5, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-06 16:30:00'),
    (47, 5, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-06 18:00:00'),
    (48, 5, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-06 19:30:00'),
    (49, 5, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-06 21:00:00'),
    (50, 5, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-06 22:30:00'),
    -- User 6: Orders 51-60 (6 positive, 4 negative)
    (51, 6, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-07 09:00:00'),
    (52, 6, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-07 10:30:00'),
    (53, 6, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-07 12:00:00'),
    (54, 6, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-07 13:30:00'),
    (55, 6, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-07 15:00:00'),
    (56, 6, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-07 16:30:00'),
    (57, 6, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-07 18:00:00'),
    (58, 6, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-07 19:30:00'),
    (59, 6, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-07 21:00:00'),
    (60, 6, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-07 22:30:00'),
    -- User 7: Orders 61-70 (6 positive, 4 negative)
    (61, 7, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-08 09:00:00'),
    (62, 7, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-08 10:30:00'),
    (63, 7, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-08 12:00:00'),
    (64, 7, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-08 13:30:00'),
    (65, 7, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-08 15:00:00'),
    (66, 7, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-08 16:30:00'),
    (67, 7, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-08 18:00:00'),
    (68, 7, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-08 19:30:00'),
    (69, 7, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-08 21:00:00'),
    (70, 7, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-08 22:30:00'),
    -- User 8: Orders 71-80 (6 positive, 4 negative)
    (71, 8, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-09 09:00:00'),
    (72, 8, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-09 10:30:00'),
    (73, 8, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-09 12:00:00'),
    (74, 8, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-09 13:30:00'),
    (75, 8, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-09 15:00:00'),
    (76, 8, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-09 16:30:00'),
    (77, 8, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-09 18:00:00'),
    (78, 8, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-09 19:30:00'),
    (79, 8, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-09 21:00:00'),
    (80, 8, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-09 22:30:00'),
    -- User 9: Orders 81-90 (6 positive, 4 negative)
    (81, 9, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-10 09:00:00'),
    (82, 9, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-10 10:30:00'),
    (83, 9, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-10 12:00:00'),
    (84, 9, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-10 13:30:00'),
    (85, 9, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-10 15:00:00'),
    (86, 9, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-10 16:30:00'),
    (87, 9, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-10 18:00:00'),
    (88, 9, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-10 19:30:00'),
    (89, 9, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-10 21:00:00'),
    (90, 9, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-10 22:30:00'),
    -- User 10: Orders 91-100 (6 positive, 4 negative)
    (91, 10, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-11 09:00:00'),
    (92, 10, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-11 10:30:00'),
    (93, 10, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-11 12:00:00'),
    (94, 10, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-11 13:30:00'),
    (95, 10, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-11 15:00:00'),
    (96, 10, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-11 16:30:00'),
    (97, 10, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-11 18:00:00'),
    (98, 10, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-11 19:30:00'),
    (99, 10, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-11 21:00:00'),
    (100, 10, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-11 22:30:00'),
    -- User 11: Orders 101-110 (6 positive, 4 negative)
    (101, 11, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-12 09:00:00'),
    (102, 11, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-12 10:30:00'),
    (103, 11, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-12 12:00:00'),
    (104, 11, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-12 13:30:00'),
    (105, 11, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-12 15:00:00'),
    (106, 11, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-12 16:30:00'),
    (107, 11, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-12 18:00:00'),
    (108, 11, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-12 19:30:00'),
    (109, 11, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-12 21:00:00'),
    (110, 11, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-12 22:30:00'),
    -- User 12: Orders 111-120 (6 positive, 4 negative)
    (111, 12, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-13 09:00:00'),
    (112, 12, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-13 10:30:00'),
    (113, 12, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-13 12:00:00'),
    (114, 12, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-13 13:30:00'),
    (115, 12, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-13 15:00:00'),
    (116, 12, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-13 16:30:00'),
    (117, 12, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-13 18:00:00'),
    (118, 12, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-13 19:30:00'),
    (119, 12, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-13 21:00:00'),
    (120, 12, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-13 22:30:00'),
    -- User 13: Orders 121-130 (6 positive, 4 negative)
    (121, 13, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-14 09:00:00'),
    (122, 13, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-14 10:30:00'),
    (123, 13, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-14 12:00:00'),
    (124, 13, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-14 13:30:00'),
    (125, 13, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-14 15:00:00'),
    (126, 13, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-14 16:30:00'),
    (127, 13, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-14 18:00'),
    (128, 13, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-14 19:30:00'),
    (129, 13, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-14 21:00:00'),
    (130, 13, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-14 22:30:00'),
    -- User 14: Orders 131-140 (6 positive, 4 negative)
    (131, 14, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-15 09:00:00'),
    (132, 14, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-15 10:30:00'),
    (133, 14, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-15 12:00:00'),
    (134, 14, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-15 13:30:00'),
    (135, 14, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-15 15:00:00'),
    (136, 14, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-15 16:30:00'),
    (137, 14, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-15 18:00:00'),
    (138, 14, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-15 19:30:00'),
    (139, 14, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-15 21:00:00'),
    (140, 14, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-15 22:30:00'),
    -- User 15: Orders 141-150 (6 positive, 4 negative)
    (141, 15, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-16 09:00:00'),
    (142, 15, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-16 10:30:00'),
    (143, 15, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-16 12:00:00'),
    (144, 15, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-16 13:30:00'),
    (145, 15, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-16 15:00:00'),
    (146, 15, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-16 16:30:00'),
    (147, 15, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-16 18:00:00'),
    (148, 15, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-16 19:30:00'),
    (149, 15, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-16 21:00:00'),
    (150, 15, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-16 22:30:00'),
    -- User 16: Orders 151-160 (6 positive, 4 negative)
    (151, 16, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-17 09:00:00'),
    (152, 16, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-17 10:30:00'),
    (153, 16, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-17 12:00:00'),
    (154, 16, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-17 13:30:00'),
    (155, 16, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-17 15:00:00'),
    (156, 16, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-17 16:30:00'),
    (157, 16, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-17 18:00:00'),
    (158, 16, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-17 19:30:00'),
    (159, 16, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-17 21:00:00'),
    (160, 16, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-17 22:30:00'),
    -- User 17: Orders 161-170 (6 positive, 4 negative)
    (161, 17, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-18 09:00:00'),
    (162, 17, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-18 10:30:00'),
    (163, 17, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-18 12:00:00'),
    (164, 17, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-18 13:30:00'),
    (165, 17, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-18 15:00:00'),
    (166, 17, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-18 16:30:00'),
    (167, 17, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-18 18:00:00'),
    (168, 17, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-18 19:30:00'),
    (169, 17, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-18 21:00:00'),
    (170, 17, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-18 22:30:00'),
    -- User 18: Orders 171-180 (6 positive, 4 negative)
    (171, 18, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-19 09:00:00'),
    (172, 18, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-19 10:30:00'),
    (173, 18, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-19 12:00:00'),
    (174, 18, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-19 13:30:00'),
    (175, 18, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-19 15:00:00'),
    (176, 18, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-19 16:30:00'),
    (177, 18, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-19 18:00:00'),
    (178, 18, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-19 19:30:00'),
    (179, 18, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-19 21:00:00'),
    (180, 18, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-19 22:30:00'),
    -- User 19: Orders 181-190 (6 positive, 4 negative)
    (181, 19, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-20 09:00:00'),
    (182, 19, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-20 10:30:00'),
    (183, 19, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-20 12:00:00'),
    (184, 19, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-20 13:30:00'),
    (185, 19, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-20 15:00:00'),
    (186, 19, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-20 16:30:00'),
    (187, 19, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-20 18:00:00'),
    (188, 19, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-20 19:30:00'),
    (189, 19, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-20 21:00:00'),
    (190, 19, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-20 22:30:00'),
    -- User 20: Orders 191-200 (6 positive, 4 negative)
    (191, 20, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-21 09:00:00'),
    (192, 20, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-21 10:30:00'),
    (193, 20, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-21 12:00:00'),
    (194, 20, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-21 13:30:00'),
    (195, 20, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-21 15:00:00'),
    (196, 20, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-21 16:30:00'),
    (197, 20, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-21 18:00:00'),
    (198, 20, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-21 19:30:00'),
    (199, 20, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-21 21:00:00'),
    (200, 20, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-21 22:30:00'),
    -- User 21: Orders 201-210 (6 positive, 4 negative)
    (201, 21, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-22 09:00:00'),
    (202, 21, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-22 10:30:00'),
    (203, 21, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-22 12:00:00'),
    (204, 21, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-22 13:30:00'),
    (205, 21, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-22 15:00:00'),
    (206, 21, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-22 16:30:00'),
    (207, 21, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-22 18:00:00'),
    (208, 21, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-22 19:30:00'),
    (209, 21, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-22 21:00:00'),
    (210, 21, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-22 22:30:00'),
    -- User 22: Orders 211-220 (6 positive, 4 negative)
    (211, 22, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-23 09:00:00'),
    (212, 22, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-23 10:30:00'),
    (213, 22, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-23 12:00:00'),
    (214, 22, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-23 13:30:00'),
    (215, 22, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-23 15:00:00'),
    (216, 22, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-23 16:30:00'),
    (217, 22, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-23 18:00:00'),
    (218, 22, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-23 19:30:00'),
    (219, 22, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-23 21:00:00'),
    (220, 22, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-23 22:30:00'),
    -- User 23: Orders 221-230 (6 positive, 4 negative)
    (221, 23, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-24 09:00:00'),
    (222, 23, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-24 10:30:00'),
    (223, 23, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-24 12:00:00'),
    (224, 23, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-24 13:30:00'),
    (225, 23, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-24 15:00:00'),
    (226, 23, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-24 16:30:00'),
    (227, 23, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-24 18:00:00'),
    (228, 23, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-24 19:30:00'),
    (229, 23, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-24 21:00:00'),
    (230, 23, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-24 22:30:00'),
    -- User 24: Orders 231-240 (6 positive, 4 negative)
    (231, 24, 5, 4, 5, 4, 5, 4, 5, N'Pizza ngon, giao hàng nhanh.', '2025-04-25 09:00:00'),
    (232, 24, 4, 5, 4, 5, 4, 5, 4, N'Sốt đậm đà, topping tươi.', '2025-04-25 10:30:00'),
    (233, 24, 3, 3, 4, 3, 3, 4, 3, N'Đế mềm, sốt quá mặn.', '2025-04-25 12:00:00'),
    (234, 24, 4, 4, 5, 5, 4, 4, 5, N'Pizza ngon, dịch vụ tốt.', '2025-04-25 13:30:00'),
    (235, 24, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, pizza nguội.', '2025-04-25 15:00:00'),
    (236, 24, 4, 5, 5, 5, 4, 4, 5, N'Đế giòn, sốt ngon.', '2025-04-25 16:30:00'),
    (237, 24, 5, 4, 4, 5, 5, 5, 4, N'Pizza ngon, giao hàng tốt.', '2025-04-25 18:00:00'),
    (238, 24, 3, 4, 3, 3, 3, 4, 3, N'Topping ít, đế không giòn.', '2025-04-25 19:30:00'),
    (239, 24, 5, 5, 4, 5, 5, 4, 4, N'Tuyệt vời, rất đáng tiền.', '2025-04-25 21:00:00'),
    (240, 24, 3, 3, 4, 3, 3, 3, 2, N'Pizza nhạt, giao hàng trễ.', '2025-04-25 22:30:00'),
    -- User 25: Orders 241-250 (6 positive, 4 negative)
    (241, 25, 5, 5, 5, 4, 5, 5, 4, N'Pizza ngon, topping đa dạng.', '2025-04-26 09:00:00'),
    (242, 25, 4, 4, 5, 5, 4, 4, 5, N'Đế mỏng giòn, sốt vừa miệng.', '2025-04-26 10:30:00'),
    (243, 25, 3, 3, 4, 3, 3, 4, 3, N'Sốt nhạt, topping không tươi.', '2025-04-26 12:00:00'),
    (244, 25, 4, 5, 5, 5, 4, 5, 5, N'Pizza ngon, đóng gói cẩn thận.', '2025-04-26 13:30:00'),
    (245, 25, 2, 3, 3, 4, 3, 3, 2, N'Giao hàng chậm, đế mềm.', '2025-04-26 15:00:00'),
    (246, 25, 4, 5, 5, 4, 5, 5, 5, N'Topping tươi, dịch vụ nhanh.', '2025-04-26 16:30:00'),
    (247, 25, 5, 5, 4, 5, 4, 4, 5, N'Pizza ngon, rất hài lòng.', '2025-04-26 18:00:00'),
    (248, 25, 3, 4, 3, 3, 3, 4, 3, N'Pizza nguội, đóng gói kém.', '2025-04-26 19:30:00'),
    (249, 25, 5, 5, 5, 5, 5, 4, 5, N'Tất cả đều tuyệt vời!', '2025-04-26 21:00:00'),
    (250, 25, 3, 3, 4, 3, 3, 3, 2, N'Giao hàng trễ, hương vị kém.', '2025-04-26 22:30:00');
GO

-- 9.12 Suggestions
INSERT INTO Suggestions (ProductID, SuggestedProductID, Confidence, CreatedDate) VALUES
  (1,	2,	75.00,	'2025-04-01'),
  (1,	55, 60.00,	'2025-04-01'),
  (2,	3,	65.00,	'2025-04-01'),
  (37,	1,	50.00,	'2025-04-02');
GO

-- 9.13 Rankings - Danh Sách Top Của Tuần
INSERT INTO Rankings (ProductID, AverageRating, RankPosition, Period, CreatedDate) VALUES
  (1,	4.80,	1,	N'Weekly',	'2025-04-07'),
  (2,	4.60,	2,	N'Weekly',	'2025-04-07'),
  (1,	4.75,	1,	N'Monthly',	'2025-04-01'),
  (2,	4.55,	2,	N'Monthly',	'2025-04-01');
GO

-- 1. Select toàn bộ dữ liệu từ bảng Categories
SELECT * FROM Categories;
GO

-- 2. Select toàn bộ dữ liệu từ bảng SubCategories
SELECT * FROM SubCategories;
GO

-- 3. Select toàn bộ dữ liệu từ bảng Users
SELECT * FROM Users;
GO

-- 4. Select toàn bộ dữ liệu từ bảng Addresses
SELECT * FROM Addresses;
GO

-- 5. Select toàn bộ dữ liệu từ bảng Products
SELECT * FROM Products;
GO

-- 6. Select toàn bộ dữ liệu từ bảng Toppings
SELECT * FROM Toppings;
GO

-- 7. Select toàn bộ dữ liệu từ bảng Promotions
SELECT * FROM Promotions;
GO

-- 8. Select toàn bộ dữ liệu từ bảng PromotionProducts
SELECT * FROM PromotionProducts;
GO

-- 9. Select toàn bộ dữ liệu từ bảng Orders
SELECT * FROM Orders;
GO

-- 10. Select toàn bộ dữ liệu từ bảng OrderDetails
SELECT * FROM OrderDetails;
GO

-- 11. Select toàn bộ dữ liệu từ bảng Feedbacks
SELECT * FROM Feedbacks;
GO

-- 12. Select toàn bộ dữ liệu từ bảng Suggestions
SELECT * FROM Suggestions;
GO

-- 13. Select toàn bộ dữ liệu từ bảng Rankings
SELECT * FROM Rankings;
GO
