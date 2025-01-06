SET FOREIGN_KEY_CHECKS = 0;

DROP TRIGGER IF EXISTS AfterInsertProductSale;

CREATE TRIGGER AfterInsertProductSale
AFTER INSERT ON ProductSale
FOR EACH ROW
UPDATE Sale s
JOIN SaleDetail sd ON sd.SaleID = NEW.SaleID
                   AND sd.ProductID = NEW.ProductID
JOIN Product p ON p.ProductID = NEW.ProductID
SET
  sd.Subtotal = p.Price * sd.Quantity,
  s.TotalAmount = (
    SELECT COALESCE(SUM(d.Subtotal), 0)
    FROM SaleDetail d
    WHERE d.SaleID = NEW.SaleID
  )
WHERE s.SaleID = NEW.SaleID;

SET FOREIGN_KEY_CHECKS = 1;
