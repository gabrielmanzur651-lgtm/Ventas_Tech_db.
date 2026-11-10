SELECT
 MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_Facturado,
    COUNT(id_venta) AS Cantidad_Pedidos,
    AVG(cantidad * precio_unitario) AS Ticket_Promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

SELECT TOP 5 
    id_producto,
    SUM(cantidad) AS Unidades_Vendidas,
    SUM(cantidad * precio_unitario) AS Total_Generado
FROM ventas
GROUP BY id_producto
ORDER BY Total_Generado DESC;

SELECT 
    id_cliente,
    COUNT(id_venta) AS Cantidad_Pedidos,
    SUM(cantidad * precio_unitario) AS Total_Gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1;

WITH FacturacionPorProducto AS (
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS Total_Producto
    FROM ventas
    GROUP BY id_producto
),
PromedioGeneral AS (
    SELECT AVG(Total_Producto) AS Promedio_Facturacion
    FROM FacturacionPorProducto
)
SELECT 
    f.id_producto,
    f.Total_Producto,
    CASE 
        WHEN f.Total_Producto >= p.Promedio_Facturacion THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Condicion_Promedio
FROM FacturacionPorProducto f
CROSS JOIN PromedioGeneral p;



/* Comentarios finales 

1 . Concentración extrema de ingresos en el Producto 1: 
El producto con ID 1 (Laptop Pro 15) es el verdadero motor del negocio en marzo. Generó $3.600,00 por sí solo, lo que representa más del 58% de la facturación total del mes ($6.144,00). Es un producto crítico que nunca debería quedarse sin stock.

2. Alta fidelidad o recompra en la cartera de clientes: 
Los 5 clientes registrados en la base de datos realizaron exactamentes 2 pedidos. Lo que señala que la campañas de retencion estan funcionando en forma muy pareja

3. Gran disparidad en el rendimiento del catalogo del producto:
Al analizar el promedio de facturacion por producto , observamos que el rendimiento esta muy polarizado. Solo dos productos se posicionaron por encima del promedio  y 4 por debajode los $400.
*/