CREATE SCHEMA SupermarketSales;
USE SupermarketSales;

CREATE TABLE Branch (
    IdBranch INT AUTO_INCREMENT PRIMARY KEY,
    Branch VARCHAR(30) NOT NULL
);

CREATE TABLE City (
    IdCity INT AUTO_INCREMENT PRIMARY KEY,
    City VARCHAR(30) NOT NULL 
);

CREATE TABLE Customer_type (
    IdCustomerType INT AUTO_INCREMENT PRIMARY KEY,
    Customer_type VARCHAR(30) NOT NULL
);

CREATE TABLE Gender (
    IdGender INT AUTO_INCREMENT PRIMARY KEY,
    Gender VARCHAR(30) NOT NULL
);

CREATE TABLE Product_line (
    IdProductLine INT AUTO_INCREMENT PRIMARY KEY,
    Product_line VARCHAR(30) NOT NULL
);

CREATE TABLE Payment (
    IdPayment INT AUTO_INCREMENT PRIMARY KEY,
    Payment VARCHAR(30) NOT NULL
);

CREATE TABLE Sales (
    IdInvoice INT AUTO_INCREMENT PRIMARY KEY,
    IdBranch INT NOT NULL,
    IdCity INT NOT NULL,
    IdCustomerType INT NOT NULL,
    IdGender INT NOT NULL,
    IdPayment INT NOT NULL,
    IdProductLine INT NOT NULL,
    Unit_price DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,
    Tax_5 DECIMAL(10,3) NOT NULL,
    Total DECIMAL(10,3) NOT NULL,
    COGS DECIMAL(10,2) NOT NULL,
    Gross_margin_percentage DECIMAL(10,9) NOT NULL,
    Gross_income DECIMAL(10,3) NOT NULL,
    Sale_date DATE NOT NULL,
    Sale_time TIME NOT NULL,
    Rating DECIMAL(3,1) NOT NULL,
    FOREIGN KEY (IdBranch) REFERENCES Branch(IdBranch),
    FOREIGN KEY (IdCity) REFERENCES City(IdCity),
    FOREIGN KEY (IdCustomerType) REFERENCES Customer_type(IdCustomerType),
    FOREIGN KEY (IdGender) REFERENCES Gender(IdGender),
    FOREIGN KEY (IdPayment) REFERENCES Payment(IdPayment),
    FOREIGN KEY (IdProductLine) REFERENCES Product_line(IdProductLine)
);
