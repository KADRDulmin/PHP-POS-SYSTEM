DROP PROCEDURE IF EXISTS CalculateCustomerStats;

CREATE PROCEDURE CalculateCustomerStats(IN customer_id INT)
INSERT INTO RegularCustomer (CustomerID, AverageSpending, VisitFrequency)
SELECT 
  customer_id,
  COALESCE(AVG(TotalAmount), 0),
  CASE
    WHEN COUNT(*) = 0 THEN 'New Customer'
    WHEN DATEDIFF(MAX(SaleDate), MIN(SaleDate)) = 0 THEN 'First Visit'
    WHEN (COUNT(*) / GREATEST(DATEDIFF(MAX(SaleDate), MIN(SaleDate)), 1)) >= 0.14 THEN 'Daily'
    WHEN (COUNT(*) / GREATEST(DATEDIFF(MAX(SaleDate), MIN(SaleDate)), 1)) >= 0.07 THEN 'Weekly'
    WHEN (COUNT(*) / GREATEST(DATEDIFF(MAX(SaleDate), MIN(SaleDate)), 1)) >= 0.03 THEN 'Monthly'
    ELSE 'Quarterly'
  END
FROM Sale
WHERE CustomerID = customer_id
ON DUPLICATE KEY UPDATE
  AverageSpending = VALUES(AverageSpending),
  VisitFrequency = VALUES(VisitFrequency);
