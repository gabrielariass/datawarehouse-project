/*
================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
================================================================================

Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;

================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time_silver_layer DATETIME, @end_time_silver_layer DATETIME
	DECLARE @start_time DATETIME , @end_time DATETIME
	BEGIN TRY
	
		PRINT '==================================='
		PRINT 'Loading silver Layer'
		PRINT '==================================='

		IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
			DROP TABLE silver.crm_cust_info;
		CREATE TABLE silver.crm_cust_info (
			cst_id				INT, 
			cst_key				NVARCHAR(50),
			cst_firstname		NVARCHAR(50),
			cst_lastname		NVARCHAR(50),
			cst_material_status NVARCHAR(50),
			cst_gndr			NVARCHAR(50),
			cst_create_date		DATE
		);

		IF OBJECT_ID('silver.crm_prod_info','U') IS NOT NULL
			DROP TABLE silver.crm_prod_info;
		CREATE TABLE silver.crm_prod_info (
			prd_id			INT,
			prd_key			NVARCHAR(50),
			prd_nm			NVARCHAR(50),
			prd_cost		INT,
			prd_line		NVARCHAR(50),
			prd_start_dt	DATETIME,
			prd_end_dt		DATETIME
		)

		IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL
			DROP TABLE silver.crm_sales_details;
		CREATE TABLE silver.crm_sales_details (
			sls_ord_num		NVARCHAR(50),
			sls_prd_key		NVARCHAR(50),
			sls_cust_id		INT,
			sls_order_dt	INT,
			sls_ship_dt		INT,
			sls_due_dt		INT,
			sls_sales		INT,
			sls_quantity	INT,
			sls_price		INT
		)

		IF OBJECT_ID('silver.erp_cust_az12','U') IS NOT NULL
			DROP TABLE silver.erp_cust_az12;
		CREATE TABLE silver.erp_cust_az12 (
			cid			NVARCHAR(50),
			bdate		DATE,
			gen			NVARCHAR(50)
		)

		IF OBJECT_ID('silver.erp_loc_az12','U') IS NOT NULL
			DROP TABLE silver.erp_loc_az12;
		CREATE TABLE silver.erp_loc_az12 (
			cid			NVARCHAR(50),
			cntry		NVARCHAR(50)
		)

		IF OBJECT_ID('silver.erp_px_cat_g1v2','U') IS NOT NULL
			DROP TABLE silver.erp_px_cat_g1v2;
		CREATE TABLE silver.erp_px_cat_g1v2 (
			id			NVARCHAR(50),
			cat			NVARCHAR(50),
			subcat		NVARCHAR(50),
			mainenance	NVARCHAR(50)
		)

		PRINT '-----------------------------------'
		PRINT 'Loading CRM Tables'
		PRINT '-----------------------------------'

		--Inserting the data into the tables
---------------------------------------------------------------------------------------------------------------------------------------
		SET @start_time_silver_layer = GETDATE()
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.crm_cust_info'
		PRINT '>> Inserting Data Into: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info

		BULK INSERT silver.crm_cust_info
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.crm_prod_info'
		PRINT '>> Inserting Data Into: silver.crm_prod_info'
		TRUNCATE TABLE silver.crm_prod_info

		BULK INSERT silver.crm_prod_info
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.crm_sales_details'
		PRINT '>> Inserting Data Into: silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details

		BULK INSERT silver.crm_sales_details
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
		PRINT '-----------------------------------'
		PRINT 'Loading ERP Tables'
		PRINT '-----------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.erp_cust_az12'
		PRINT '>> Inserting Data Into: silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12

		BULK INSERT silver.erp_cust_az12
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.erp_loc_az12'
		PRINT '>> Inserting Data Into: silver.erp_loc_az12'
		TRUNCATE TABLE silver.erp_loc_az12

		BULK INSERT silver.erp_loc_az12
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2'
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2

		BULK INSERT silver.erp_px_cat_g1v2
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		SET @end_time_silver_layer = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
		PRINT '>>> WHOLE BATCH LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time_silver_layer, @end_time_silver_layer) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
	END TRY
	BEGIN CATCH
		PRINT '====================================================='
		PRINT 'ERROR OCURRED DURING LOADING silver LAYER'
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR)
		PRINT '====================================================='
	END CATCH
END
