/*
========================================================
Create Silver Layer Tables
========================================================
Script Purpose:
	This script creates the table structure for the Silver
	layer of the data warehouse. Existing Silver tables are
	dropped and recreated to ensure a consistent schema before
	data transformation and cleansing processes are executed.

	The Silver layer serves as the intermediate storage layer
	where data from the Bronze layer is cleaned, standardized,
	validated, and prepared for business consumption.

	Tables created:
	- silver.crm_cust_info
	- silver.crm_prod_info
	- silver.crm_sales_details
	- silver.erp_cust_az12
	- silver.erp_loc_az12
	- silver.erp_px_cat_g1v2

	Table Categories:
	- CRM Customer Data
	- CRM Product Data
	- CRM Sales Data
	- ERP Customer Data
	- ERP Location Data
	- ERP Product Category Data

WARNING:
	Running this script will drop and recreate all specified
	Silver-layer tables. Any existing data stored in these
	tables will be permanently deleted.

	Ensure that any required data transformations, backups,
	or downstream dependencies are accounted for before
	executing this script.
*/


IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
	cst_id				INT, 
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR(50),
	cst_lastname		NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr			NVARCHAR(50),
	cst_create_date		DATE,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_prod_info','U') IS NOT NULL
	DROP TABLE silver.crm_prod_info;
CREATE TABLE silver.crm_prod_info (
	prd_id			INT,
	cat_id			NVARCHAR(50),
	prd_key			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		INT,
	prd_line		NVARCHAR(50),
	prd_start_dt	DATE,
	prd_end_dt		DATE,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	DATE,
	sls_ship_dt		DATE,
	sls_due_dt		DATE,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_cust_az12','U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	cid			NVARCHAR(50),
	bdate		DATE,
	gen			NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_loc_az12','U') IS NOT NULL
	DROP TABLE silver.erp_loc_az12;
CREATE TABLE silver.erp_loc_az12 (
	cid			NVARCHAR(50),
	cntry		NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
	id			NVARCHAR(50),
	cat			NVARCHAR(50),
	subcat		NVARCHAR(50),
	mainenance	NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
)
