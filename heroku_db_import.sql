-- First drop tables in correct order
SET FOREIGN_KEY_CHECKS = 0;

-- First tier (no dependencies)
DROP TABLE IF EXISTS StockSaleReport;
DROP TABLE IF EXISTS LoyaltyCustomer;
DROP TABLE IF EXISTS RegularCustomer;
DROP TABLE IF EXISTS Loyalty;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Cashier;
DROP TABLE IF EXISTS StockProduct;
DROP TABLE IF EXISTS Report;
DROP TABLE IF EXISTS SaleDetail;
DROP TABLE IF EXISTS ProductSale;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Discount;

-- Second tier
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS Sale;
DROP TABLE IF EXISTS Product;

-- Third tier
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Employee;

SET FOREIGN_KEY_CHECKS = 1;

-- Create Tables with IF NOT EXISTS
CREATE TABLE IF NOT EXISTS Employee (
    EmployeeId INT AUTO_INCREMENT PRIMARY KEY,
    DOB DATE,
    JoinDate DATE,
    Address VARCHAR(255),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Contact VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Contact VARCHAR(15),
    Address VARCHAR(255),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS Supplier (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Address VARCHAR(255),
    SupplierName VARCHAR(100),
    Contact VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    CostPrice DECIMAL(10, 2),
    SupplierID INT,
    CategoryID INT,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE IF NOT EXISTS Sale (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    TotalAmount DECIMAL(10, 2),
    SaleDate DATE,
    CustomerID INT,
    EmployeeID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeId)
);

CREATE TABLE IF NOT EXISTS SaleDetail (
    SaleID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    PRIMARY KEY (SaleID, ProductID),
    FOREIGN KEY (SaleID) REFERENCES Sale(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE IF NOT EXISTS ProductSale (
    SaleID INT,
    ProductID INT,
    PRIMARY KEY (SaleID, ProductID),
    FOREIGN KEY (SaleID) REFERENCES Sale(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE IF NOT EXISTS Discount (
    ProductID INT PRIMARY KEY,
    DiscountName VARCHAR(100),
    DiscountPercentage DECIMAL(5, 2),
    ValidFrom DATE,
    ValidTo DATE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE IF NOT EXISTS Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    PaymentType VARCHAR(50),
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    SaleID INT,
    FOREIGN KEY (SaleID) REFERENCES Sale(SaleID)
);

CREATE TABLE IF NOT EXISTS Stock (
    StockID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    Quantity INT,
    EmployeeID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeId)
);

CREATE TABLE IF NOT EXISTS StockProduct (
    StockID INT,
    ProductID INT,
    Quantity INT NOT NULL DEFAULT 0,
    PRIMARY KEY (StockID, ProductID),
    FOREIGN KEY (StockID) REFERENCES Stock(StockID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE IF NOT EXISTS Report (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReportType VARCHAR(50),
    Recipient VARCHAR(100),
    Date DATE,
    Content TEXT,
    EmployeeID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeId)
);

CREATE TABLE IF NOT EXISTS StockSaleReport (
    StockID INT,
    ReportID INT,
    SaleID INT,
    PRIMARY KEY (StockID, ReportID, SaleID),
    FOREIGN KEY (StockID) REFERENCES Stock(StockID),
    FOREIGN KEY (ReportID) REFERENCES Report(ReportID),
    FOREIGN KEY (SaleID) REFERENCES Sale(SaleID)
);

CREATE TABLE IF NOT EXISTS Cashier (
    POS INT,
    EmployeeID INT,
    PRIMARY KEY (POS, EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeId)
);

CREATE TABLE IF NOT EXISTS Manager (
    Privileges TEXT,
    EmployeeID INT PRIMARY KEY,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeId)
);

CREATE TABLE IF NOT EXISTS RegularCustomer (
    AverageSpending DECIMAL(10, 2),
    VisitFrequency VARCHAR(50),
    CustomerID INT PRIMARY KEY,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE IF NOT EXISTS LoyaltyCustomer (
    LoyaltyCardNo INT,
    PointsEarned INT,
    CustomerID INT PRIMARY KEY,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE IF NOT EXISTS Loyalty (
    LoyaltyPoints INT,
    CustomerID INT PRIMARY KEY,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Create indexes (removed IF NOT EXISTS as it's not supported)
CREATE INDEX idx_product_supplier ON Product(SupplierID);
CREATE INDEX idx_product_category ON Product(CategoryID);
CREATE INDEX idx_sale_customer ON Sale(CustomerID);
CREATE INDEX idx_sale_employee ON Sale(EmployeeID);

-- Add initial data
INSERT IGNORE INTO Category (Name) VALUES ('General');
INSERT IGNORE INTO Employee (FirstName, LastName, Email) 
VALUES ('Admin', 'User', 'admin@example.com');
