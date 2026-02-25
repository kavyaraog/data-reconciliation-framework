-- Project: Data Reconciliation Framework
-- Author: Kavya Gangadhara Rao
-- Environment: Databricks SQL Warehouse
-- Description: Setup source and target tables for reconciliation

CREATE OR REPLACE TABLE source_orders (
  order_id INT,
  customer_id INT,
  amount DOUBLE,
  order_date DATE
);

INSERT INTO source_orders VALUES
(1, 101, 250.00, '2024-01-01'),
(2, 102, 300.00, '2024-01-02'),
(3, 103, 150.00, '2024-01-03'),
(4, 104, 500.00, '2024-01-04');

CREATE OR REPLACE TABLE target_orders (
  order_id INT,
  customer_id INT,
  amount DOUBLE,
  order_date DATE
);

INSERT INTO target_orders VALUES
(1, 101, 250.00, '2024-01-01'),
(2, 102, 300.00, '2024-01-02'),
(3, 103, 150.00, '2024-01-03'),
(5, 105, 600.00, '2024-01-05');
