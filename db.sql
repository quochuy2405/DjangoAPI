CREATE TABLE `Discount` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(150) NOT NULL,
    `Value` int NOT NULL DEFAULT 0,
    `Quantity` int NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
);

CREATE TABLE `ProductType` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(150) NOT NULL,
    `Description` text NULL,
    PRIMARY KEY (`Id`)
);

CREATE TABLE `Account` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Username` varchar(100) NOT NULL,
    `Password` varchar(100) NOT NULL,
    `RoleId` int NOT NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Account_Role_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `Role` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Role` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `RoleName` varchar(100) NOT NULL,
    `Description` text NULL,
    PRIMARY KEY (`Id`)
);
CREATE TABLE `Product` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(150) NOT NULL,
    `Description` text NULL,
    `Price` int NOT NULL DEFAULT 0,
    `CreatedDate` date NOT NULL,
    `Photo` text NULL,
    `Size` int NOT NULL DEFAULT 0,
    `ProductTypeId` int NOT NULL,
    `SupplierId` int NOT NULL,
    PRIMARY KEY (`Id`),
);

CREATE TABLE `Employee` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(150) NOT NULL,
    `Age` int NOT NULL,
    `Gender` bit NOT NULL,
    `Email` varchar(100) NOT NULL,
    `Phone` varchar(11) NOT NULL,
    `Address` varchar(500) NOT NULL,
    `City` varchar(100) NOT NULL,
    `Country` varchar(100) NOT NULL,
    `Salary` bigint NOT NULL DEFAULT 0,
    `Status` varchar(100) NULL DEFAULT 'Hoạt động',
    `StoreId` int NOT NULL,
    PRIMARY KEY (`Id`),
);

CREATE TABLE `ShoppingCart_Product` (
    `ShoppingCartId` int NOT NULL,
    `ProductId` int NOT NULL,
    PRIMARY KEY (`ShoppingCartId`, `ProductId`),
    CONSTRAINT `FK_ShoppingCart_Product_Product_ProductId` FOREIGN KEY (`ProductId`) REFERENCES `Product` (`Id`) ON DELETE CASCADE,
    CONSTRAINT `FK_ShoppingCart_Product_ShoppingCart_ShoppingCartId` FOREIGN KEY (`ShoppingCartId`) REFERENCES `ShoppingCart` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `ShoppingCart` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `UserId` int NOT NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_ShoppingCart_User_UserId` FOREIGN KEY (`UserId`) REFERENCES `User` (`Id`) ON DELETE CASCADE
);

CREATE TABLE `Bill` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `UserId` int NOT NULL,
    `Validated` int NOT NULL DEFAULT 0,
    `Status` varchar(100) NULL DEFAULT 'Đang chờ thanh toán',
    `TotalPrice` bigint NOT NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `FK_Bill_User_UserId` FOREIGN KEY (`UserId`) REFERENCES `User` (`Id`) ON DELETE CASCADE
);
CREATE TABLE `User` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Username` varchar(100) NOT NULL,
    `Password` varchar(100) NOT NULL,
    `Email` varchar(100) NOT NULL,
    `Phone` varchar(11) NOT NULL,
    `Name` varchar(100) NOT NULL,
    `Avata` varchar(255) NULL,
    `Address` text NULL,
    `City` varchar(100) NULL,
    `Country` varchar(100) NULL,
    `Gender` bit NOT NULL,
    `Balance` number NULL,
    PRIMARY KEY (`Id`)
);