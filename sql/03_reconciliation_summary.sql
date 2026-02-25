-- Project: Data Reconciliation Framework
-- Author: Kavya Gangadhara Rao
-- Description: Aggregated reconciliation summary with automated PASS/FAIL logic

CREATE OR REPLACE TABLE reconciliation_summary AS
SELECT
    source_count,
    target_count,
    missing_in_target,
    extra_in_target,
    value_mismatch_count,

    CASE 
        WHEN missing_in_target = 0 
         AND extra_in_target = 0 
         AND value_mismatch_count = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS validation_status

FROM (
    SELECT
        (SELECT COUNT(*) FROM source_orders) AS source_count,
        (SELECT COUNT(*) FROM target_orders) AS target_count,

        (SELECT COUNT(*) 
         FROM source_orders s
         LEFT JOIN target_orders t
         ON s.order_id = t.order_id
         WHERE t.order_id IS NULL) AS missing_in_target,

        (SELECT COUNT(*) 
         FROM target_orders t
         LEFT JOIN source_orders s
         ON t.order_id = s.order_id
         WHERE s.order_id IS NULL) AS extra_in_target,

        (SELECT COUNT(*)
         FROM source_orders s
         JOIN target_orders t
         ON s.order_id = t.order_id
         WHERE s.amount <> t.amount) AS value_mismatch_count
) summary;
