-- database
CREATE DATABASE supply_chain_service_level_analytics_dev;

-- schema
CREATE SCHEMA source_schema_supply_chain_service_level_dev;

--===============================================
-- create table "dim_customers"
CREATE TABLE source_schema_supply_chain_service_level_dev.dim_customers (
    customer_id TEXT PRIMARY KEY,
    customer_name TEXT,
    city TEXT
);

--===============================================
-- create table "dim_date"
CREATE TABLE source_schema_supply_chain_service_level_dev.dim_date (
	date DATE,
	mmm_yy DATE,
	week_no TEXT
);

--===============================================
-- create table "dim_products"
CREATE TABLE source_schema_supply_chain_service_level_dev.dim_products (
	product_id TEXT PRIMARY KEY,
	product_name TEXT,
	category TEXT
);

--===============================================
-- create table "dim_targets_orders"
CREATE TABLE source_schema_supply_chain_service_level_dev.dim_targets_orders (
	customer_id TEXT PRIMARY KEY,
	ontime_target_pct INT,
	infull_target_pct INT,
	otif_target_pct INT
);

--===============================================
-- create table "fact_order_lines"
CREATE TABLE source_schema_supply_chain_service_level_dev.fact_order_lines (
	order_id TEXT,
	order_placement_date TEXT,
	customer_id TEXT,
	product_id TEXT,
	order_qty INT,
	agreed_delivery_date TEXT,
	actual_delivery_date TEXT,
	delivery_qty INT
);
