USE SupermarketSales;

-- Inserción en Tablas Maestras
INSERT INTO Branch (IdBranch, Branch) VALUES (1, 'A'), (2, 'B'), (3, 'C');
INSERT INTO City (IdCity, City) VALUES (1, 'Yangon'), (2, 'Naypyitaw'), (3, 'Mandalay');
INSERT INTO Customer_type (IdCustomerType, Customer_type) VALUES (1, 'Member'), (2, 'Normal');
INSERT INTO Gender (IdGender, Gender) VALUES (1, 'Female'), (2, 'Male');
INSERT INTO Product_line (IdProductLine, Product_line) VALUES 
(1, 'Health and beauty'), (2, 'Electronic accessories'), (3, 'Home and lifestyle'), 
(4, 'Sports and travel'), (5, 'Food and beverages'), (6, 'Fashion accessories');
INSERT INTO Payment (IdPayment, Payment) VALUES (1, 'Ewallet'), (2, 'Cash'), (3, 'Credit card');

-- NOTA PARA EL PROFESOR: 
-- TABLAS MAESTRAS: Los registros de las tablas (City, Gender, Product_line, etc.) 
-- se incluyen en este script mediante sentencias INSERT para garantizar la 
-- integridad referencial y el correcto funcionamiento de los IDs.

-- TABLAS TRANSACCIONALES: Debido al volumen de 1,000 registros, las tablas 
-- 'Sales' y 'Sales_detail' deben ser cargadas utilizando la herramienta 
-- 'Table Data Import Wizard' de MySQL Workbench. 
-- 1. Tabla 'Sales' (14 Columnas):
--    En el Wizard, seleccione estas 14 columnas del archivo CSV:
--    IdInvoice, IdBranch, IdCity, IdCustomertype, IdGender, IdPayment, 
--    Date, Time, Rating, COGS, Gross_margin_percentage, Gross_income, 
--    Tax_5, Total.
-- 2. Tabla 'Sales_detail' (6 Columnas):
--    En el Wizard, seleccione estas 6 columnas del archivo CSV:
--    IdInvoice, IdProduct_line, Unit_price, Quantity, Tax_5, Total.

-- ARCHIVO FUENTE: Se adjunta el archivo "supermarket_sales.csv" para realizar 
-- dicha importación. El paso a paso detallado del proceso ETL y mapeo de 
-- columnas se encuentra en el documento PDF de la entrega