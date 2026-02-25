-- Project: Data Reconciliation Framework
-- Author: Kavya Gangadhara Rao
-- Description: Basic validation checks between source and target tables

-- Row Count Check
SELECT 
  (SELECT COUNT(*) FROM source_orders) AS source_count,
  (SELECT COUNT(*) FROM target_orders) AS target_count;

-- Missing Records in Target
SELECT s.*
FROM source_orders s
LEFT JOIN target_orders t
ON s.order_id = t.order_id
WHERE t.order_id IS NULL;

-- Extra Records in Target
SELECT t.*
FROM target_orders t
LEFT JOIN source_orders s
ON t.order_id = s.order_id
WHERE s.order_id IS NULL;

-- Value Mismatch Detection
SELECT 
    s.order_id,
    s.amount AS source_amount,
    t.amount AS target_amount
FROM source_orders s
JOIN target_orders t
ON s.order_id = t.order_id
WHERE s.amount <> t.amount;
