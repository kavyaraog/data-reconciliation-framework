-- Project: Data Reconciliation Framework
-- Author: Kavya Gangadhara Rao
-- Description: Modular validation logging with automated PASS/FAIL status and audit timestamping

-- Create validation results table
CREATE OR REPLACE TABLE validation_results (
    validation_type STRING,
    validation_value INT,
    status STRING,
    run_timestamp TIMESTAMP
);

-- Insert Row Count Validation
INSERT INTO validation_results
SELECT
    'ROW_COUNT_CHECK' AS validation_type,
    ABS(
        (SELECT COUNT(*) FROM source_orders) -
        (SELECT COUNT(*) FROM target_orders)
    ) AS validation_value,
    
    CASE 
        WHEN 
            (SELECT COUNT(*) FROM source_orders) =
            (SELECT COUNT(*) FROM target_orders)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status,
    
    CURRENT_TIMESTAMP() AS run_timestamp;

-- Insert Missing Record Validation
INSERT INTO validation_results
SELECT
    'MISSING_IN_TARGET' AS validation_type,
    COUNT(*) AS validation_value,
    
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS status,
    
    CURRENT_TIMESTAMP()
FROM source_orders s
LEFT JOIN target_orders t
ON s.order_id = t.order_id
WHERE t.order_id IS NULL;

-- Insert Value Mismatch Validation
INSERT INTO validation_results
SELECT
    'VALUE_MISMATCH' AS validation_type,
    COUNT(*) AS validation_value,
    
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS status,
    
    CURRENT_TIMESTAMP()
FROM source_orders s
JOIN target_orders t
ON s.order_id = t.order_id
WHERE s.amount <> t.amount;

-- Overall Pipeline Status
SELECT
    CASE 
        WHEN SUM(CASE WHEN status = 'FAIL' THEN 1 ELSE 0 END) > 0
        THEN 'OVERALL_FAIL'
        ELSE 'OVERALL_PASS'
    END AS pipeline_status,
    
    COUNT(*) AS total_checks,
    SUM(CASE WHEN status = 'FAIL' THEN 1 ELSE 0 END) AS failed_checks
FROM validation_results;
