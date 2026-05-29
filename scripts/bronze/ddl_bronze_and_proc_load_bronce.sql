/*
========================================================
Load Bronze Layer
========================================================
Script Purpose:
	This script creates or refreshes the stored procedure
	'bronze.load_bronze'. The procedure drops and recreates
	the Bronze-layer tables for CRM and ERP source data, then
	loads each table using BULK INSERT from local CSV files.

	Source tables loaded:
	- bronze.crm_cust_info
	- bronze.crm_prod_info
	- bronze.crm_sales_details
	- bronze.erp_cust_az12
	- bronze.erp_loc_az12
	- bronze.erp_px_cat_g1v2

	The procedure also prints load status messages and timing
	information for each table as well as for the full Bronze
	layer batch.

WARNING:
	This procedure truncates and reloads all Bronze tables each
	time it runs. Any existing data in these tables will be lost.

	The BULK INSERT statements use absolute file paths on the
	local machine. Before running this procedure, ensure the CSV
	files exist at the specified locations and that SQL Server
	has permission to read them.

	If the source files are missing, inaccessible, or formatted
	incorrectly, the load will fail and an error message will be
	printed in the CATCH block.
*/

EXECUTE bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time_bronze_layer DATETIME, @end_time_bronze_layer DATETIME
	DECLARE @start_time DATETIME , @end_time DATETIME
	BEGIN TRY
	
		PRINT '==================================='
		PRINT 'Loading Bronze Layer'
		PRINT '==================================='

		IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
			DROP TABLE bronze.crm_cust_info;
		CREATE TABLE bronze.crm_cust_info (
			cst_id				INT, 
			cst_key				NVARCHAR(50),
			cst_firstname		NVARCHAR(50),
			cst_lastname		NVARCHAR(50),
			cst_material_status NVARCHAR(50),
			cst_gndr			NVARCHAR(50),
			cst_create_date		DATE
		);

		IF OBJECT_ID('bronze.crm_prod_info','U') IS NOT NULL
			DROP TABLE bronze.crm_prod_info;
		CREATE TABLE bronze.crm_prod_info (
			prd_id			INT,
			prd_key			NVARCHAR(50),
			prd_nm			NVARCHAR(50),
			prd_cost		INT,
			prd_line		NVARCHAR(50),
			prd_start_dt	DATETIME,
			prd_end_dt		DATETIME
		)

		IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
			DROP TABLE bronze.crm_sales_details;
		CREATE TABLE bronze.crm_sales_details (
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

		IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
			DROP TABLE bronze.erp_cust_az12;
		CREATE TABLE bronze.erp_cust_az12 (
			cid			NVARCHAR(50),
			bdate		DATE,
			gen			NVARCHAR(50)
		)

		IF OBJECT_ID('bronze.erp_loc_az12','U') IS NOT NULL
			DROP TABLE bronze.erp_loc_az12;
		CREATE TABLE bronze.erp_loc_az12 (
			cid			NVARCHAR(50),
			cntry		NVARCHAR(50)
		)

		IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
			DROP TABLE bronze.erp_px_cat_g1v2;
		CREATE TABLE bronze.erp_px_cat_g1v2 (
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
		SET @start_time_bronze_layer = GETDATE()
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		PRINT '>> Inserting Data Into: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info

		BULK INSERT bronze.crm_cust_info
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
		PRINT '>> Truncating Table: bronze.crm_prod_info'
		PRINT '>> Inserting Data Into: bronze.crm_prod_info'
		TRUNCATE TABLE bronze.crm_prod_info

		BULK INSERT bronze.crm_prod_info
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
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details

		BULK INSERT bronze.crm_sales_details
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
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12

		BULK INSERT bronze.erp_cust_az12
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
		PRINT '>> Truncating Table: bronze.erp_loc_az12'
		PRINT '>> Inserting Data Into: bronze.erp_loc_az12'
		TRUNCATE TABLE bronze.erp_loc_az12

		BULK INSERT bronze.erp_loc_az12
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
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Gabriel Arias\Downloads\data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		SET @end_time_bronze_layer = GETDATE()
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
		PRINT '>>> WHOLE BATCH LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time_bronze_layer, @end_time_bronze_layer) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------------------------'
---------------------------------------------------------------------------------------------------------------------------------------
	END TRY
	BEGIN CATCH
		PRINT '====================================================='
		PRINT 'ERROR OCURRED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE()
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR)
		PRINT '====================================================='
	END CATCH
END
