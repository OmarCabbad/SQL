CREATE SCHEMA SupermarketSales;
USE SupermarketSales;

CREATE TABLE Branch (
    IdBranch INT PRIMARY KEY,
    Branch VARCHAR(30) NOT NULL
);

CREATE TABLE City (
    IdCity INT PRIMARY KEY,
    City VARCHAR(30) NOT NULL 
);

CREATE TABLE Customer_type (
    IdCustomerType INT PRIMARY KEY,
    Customer_type VARCHAR(30) NOT NULL
);

CREATE TABLE Gender (
    IdGender INT PRIMARY KEY,
    Gender VARCHAR(30) NOT NULL
);

CREATE TABLE Product_line (
    IdProductLine INT PRIMARY KEY,
    Product_line VARCHAR(30) NOT NULL
);

CREATE TABLE Payment (
    IdPayment INT PRIMARY KEY,
    Payment VARCHAR(30) NOT NULL
);

CREATE TABLE Sales (
    IdInvoice VARCHAR(30) PRIMARY KEY,
    IdBranch INT NOT NULL,
    IdCity INT NOT NULL,
    IdCustomerType INT NOT NULL,
    IdGender INT NOT NULL,
    IdPayment INT NOT NULL,
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
    FOREIGN KEY (IdPayment) REFERENCES Payment(IdPayment)
);

CREATE TABLE Sales_Detail (
    IdInvoice VARCHAR(30) NOT NULL, 
    IdProductline INT NOT NULL,
    Unit_price DECIMAL (10,2) NOT NULL,
    Quantity INT NOT NULL,
    Tax_5 DECIMAL (10,3) NOT NULL,
    Total DECIMAL (10,3) NOT NULL,
    PRIMARY KEY(IdInvoice, IdProductline),
    FOREIGN KEY (IdInvoice) REFERENCES Sales(IdInvoice),
    FOREIGN KEY (IdProductline) REFERENCES Product_line(IdProductline)
);


USE SupermarketSales;


-- VISTAS --
-- 1 -- Cual es el desempeño de la ventas en las distintas ciudades? --

CREATE OR REPLACE VIEW vw_desempeño_ciudades AS 
SELECT 
c.City,
SUM(s.Total) AS Total_vendido
From Sales s JOIN City c ON s.IdCity = c.IdCity
Group by c.City, c.IdCity;

SELECT * FROM vw_desempeño_ciudades;

-- El  mayor desempeño representa a Naypyitaw con 110568.748, seguido por Yangon con 106200.409 y por ultimo Mandalay con 106197.709 -- 

-- 2 -- Cuanto se facturo en el primer mes de 2019 en la ciudad de Mandalay?

CREATE OR REPLACE VIEW Facturacion_Enero_Mandalay AS
Select
c.city,
SUM(s.total) AS Total_Enero_Mandalay
FROM Sales s 
JOIN City c on c.IdCity= s.IdCity
WHERE c.City = 'Mandalay' and MONTH(s.Sale_date)=1 
Group by c.City, c.IdCity;

SELECT * FROM Facturacion_Enero_Mandalay;

-- El total de facturacion en enero en la sucursal que se encuentra en Mandalay es de 37176.068

-- 3 -- Que Linea de producto con mayor margen de ganancia a la empresa(Gross income)?

CREATE OR REPLACE VIEW Mayor_MargenGanancia_LineaProducto AS
SELECT
p.Product_line,
SUM(s.Gross_income) AS Total_MargenGanancia 
FROM Sales s
JOIN Sales_Detail sd ON s.IdInvoice = sd.IdInvoice 
JOIN Product_line p ON sd.IdProductLine = p.IdProductLine 
GROUP BY p.Product_line
ORDER BY Total_MargenGanancia DESC;

SELECT * FROM Mayor_MargenGanancia_LineaProducto;

-- Salud y belleza es el tipo de producto que genera mayor margen de ganancia con 8313.705 -- 

-- 4 -- ¿Cuántas ventas se realizaron por cada género, incluyendo aquellos que no compraron nada?

CREATE OR REPLACE VIEW Ventas_Por_Genero AS
SELECT 
g.Gender,
COUNT(s.IdInvoice) AS Cantidad_Ventas
FROM Gender g
LEFT JOIN Sales s ON g.IdGender = s.IdGender
GROUP BY g.Gender;


SELECT * FROM Ventas_Por_Genero;

-- Las ventas de mujeres representan 501 mientras que los hombres 499 --

-- 5 ¿Cuál es el metodo de pago que mas ha recaudado? ¿cual fue el de mayor uso? --

CREATE OR REPLACE VIEW Resumen_Metodos_Pago AS
SELECT 
    p.Payment AS Metodo_Pago,
    COUNT(s.IdInvoice) AS Cantidad_Operaciones,
    SUM(s.Total) AS Total_Vendido
FROM Sales s
JOIN Payment p ON s.IdPayment = p.IdPayment
GROUP BY p.Payment;

SELECT * FROM Resumen_Metodos_Pago;

-- El metodo mas utilizado fue la billeta electronica con 345 operaciones. Sin Embargo, el que mas recaudo fue el efectivo con 112206.610 


-- FUNCIONES -- 

-- 1) ¿Cuantas unidades de producto se adquirieron segun el tipo de factura?

DELIMITER //
CREATE FUNCTION Unidades_por_Factura (Id_Invoice_buscado VARCHAR(30))
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE resultado INT;
	SELECT SUM(Quantity)
	INTO resultado    
	FROM Sales_Detail
	WHERE IdInvoice=Id_Invoice_buscado;
	IF resultado IS NULL THEN
		SET resultado = 0; 
	END IF;
	RETURN resultado;
END //

DELIMITER ;

SELECT Unidades_por_Factura('744-09-5786') AS Total_Productos;

-- 2) ¿Cual es el promedio de facturacion total segun el tipo de producto?

DELIMITER // 
CREATE FUNCTION Facturacion_Linea_producto (Product_line_buscado Varchar(30))
RETURNS DECIMAL (10,2)
READS SQL DATA
BEGIN
	DECLARE resultado DECIMAL (10,2);
	SELECT AVG(Total)
	INTO resultado
	FROM sales_detail sd
    JOIN Product_line pl on sd.Idproductline= pl.Idproductline
	WHERE Product_line = Product_line_buscado;
IF resultado IS NULL THEN
	SET resultado =0;
	END IF;
	RETURN resultado;
END //

DELIMITER ;
 
SELECT Facturacion_Linea_producto('Health and beauty') AS Promedio_Salud_y_Belleza; 

-- Stored Procedure -- 
-- Se genera un reporte de ventas flexible que permite al usuario decidir el orden de los datos en tiempo real, utilizando un Stored Procedure con SQL dinámico --

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `ordenar_ventas_supermercado`(
IN sp_columna_orden ENUM("total","sale_date"),
IN sp_orden ENUM("ASC","DESC"))

BEGIN
SET @orden_final = CONCAT(" ORDER BY ",sp_columna_orden," ",sp_orden);

SET @sentencia = CONCAT("SELECT * FROM Sales", @orden_final);

-- Preparamos, ejecutamos y limpiamos
PREPARE runSQL FROM @sentencia;
EXECUTE runSQL;
DEALLOCATE PREPARE runSQL;

END //

DELIMITER ;

CALL ordenar_ventas_supermercado('total', 'DESC');



-- Se genera un reporte de ventas filtrado por categoría, donde se utiliza un Stored Procedure para aplicar un filtro WHERE
-- Una cláusula ORDER BY dinámica permitiendo un análisis detallado de cada segmento del supermercado sin escribir consultas manuales --

DELIMITER //
 
CREATE DEFINER=`root`@`localhost` PROCEDURE `ordenar_por_categoria`(
IN sp_columna_orden VARCHAR (50),
IN sp_orden VARCHAR (10)) 
BEGIN 
IF sp_columna_orden <> "" THEN 
	SET @orden_final = CONCAT ( " ORDER BY ", sp_columna_orden, " ", sp_orden);
ELSE
  SET @orden_final= "";
END IF;
SET @sentencia = CONCAT("SELECT * FROM Sales", @orden_final);

PREPARE runSQL FROM @sentencia;
EXECUTE runSQL;
DEALLOCATE PREPARE runSQL;

END //

DELIMITER ;
 
CALL ordenar_por_categoria('Total', 'DESC'); 

SELECT * FROM Branch  ;