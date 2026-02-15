USE SupermarketSales;

-- 1. INSERCIÓN EN TABLAS MAESTRAS

INSERT INTO Branch (IdBranch, Branch) VALUES (1, 'A'), (2, 'B'), (3, 'C');
INSERT INTO City (IdCity, City) VALUES (1, 'Yangon'), (2, 'Naypyitaw'), (3, 'Mandalay');
INSERT INTO Customer_type (IdCustomerType, Customer_type) VALUES (1, 'Member'), (2, 'Normal');
INSERT INTO Gender (IdGender, Gender) VALUES (1, 'Female'), (2, 'Male');

INSERT INTO Product_line (IdProductLine, Product_line) VALUES 
(1, 'Health and beauty'), (2, 'Electronic accessories'), (3, 'Home and lifestyle'), 
(4, 'Sports and travel'), (5, 'Food and beverages'), (6, 'Fashion accessories');

INSERT INTO Payment (IdPayment, Payment) VALUES (1, 'Cash'), (2, 'Credit card'), (3, 'Ewallet');

-- NOTA PARA EL PROFESOR: INSTRUCCIONES DE CARGA

-- TABLAS MAESTRAS: Los registros de las tablas maestras se incluyen arriba 
-- mediante sentencias INSERT para asegurar la integridad referencial.

-- TABLAS TRANSACCIONALES: Debido al volumen (1,000 registros), la carga se 
-- realiza mediante 'Table Data Import Wizard' con el archivo adjunto "supermarket_sales.csv".

-- 1. Tabla 'Sales' (14 Columnas):
--    Mapear en el Wizard: IdInvoice, IdBranch, IdCity, IdCustomerType, 
--    IdGender, IdPayment, Tax_5, Total, COGS, Gross_margin_percentage, 
--    Gross_income, Sale_date, Sale_time, Rating.

-- 2. Tabla 'Sales_Detail' (6 Columnas):
--    Mapear en el Wizard: IdInvoice, IdProductline, Unit_price, 
--    Quantity, Tax_5, Total.

-- ARCHIVO FUENTE: Se adjunta "supermarket_sales.csv". El detalle del proceso 
-- ETL se encuentra en el documento PDF de la entrega.