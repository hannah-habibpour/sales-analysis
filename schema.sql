-- Create schema
CREATE schema IF NOT EXISTS northwind
SET search_path TO northwind

-- Load Northwind schema

-- Add cost table 
CREATE TABLE product_costs (
  product_id int PRIMARY KEY,
  standard_cost numeric(10,2) NOT NULL
);
