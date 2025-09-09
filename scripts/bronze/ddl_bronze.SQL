


EXEC bronze.load_bronze

CREATE
	OR

ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
	DECLARE @start_time DATETIME,
		@end_time DATETIME,
		@batch_start_time datetime,
		@batch_end_time datetime;

	BEGIN TRY
		set @batch_start_time= GETDATE()
		PRINT 'loading bronze layer';

		SET @start_time = GETDATE();

		PRINT 'loading crm tables';

		TRUNCATE TABLE bronze.crm_cust_info

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\NANDANA J SREENIVAS\OneDrive\Desktop\desktop\Chinnu\projects\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + cast(datediff(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_prd_info

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\NANDANA J SREENIVAS\OneDrive\Desktop\desktop\Chinnu\projects\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + cast(datediff(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_sales_details

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\NANDANA J SREENIVAS\OneDrive\Desktop\desktop\Chinnu\projects\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + cast(datediff(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
		PRINT 'loading erp tables';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_cust_az12

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\NANDANA J SREENIVAS\OneDrive\Desktop\desktop\Chinnu\projects\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + cast(datediff(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_loc_a101

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\NANDANA J SREENIVAS\OneDrive\Desktop\desktop\Chinnu\projects\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + cast(datediff(second, @start_time, @end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\NANDANA J SREENIVAS\OneDrive\Desktop\desktop\Chinnu\projects\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv' WITH (
				firstrow = 2,
				fieldterminator = ',',
				TABLOCK
				);

		SET @end_time = GETDATE();

		PRINT '>> Load duration: ' + cast(datediff(second, @start_time, @end_time) AS VARCHAR) + 'seconds';
		
		SET @batch_end_time = GETDATE();

		PRINT '>> Batch load duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) AS VARCHAR) + 'seconds';
	END TRY

	BEGIN CATCH
		PRINT '==============================================='
		PRINT 'error occurred while loading bronze layer'
		PRINT '==============================================='
	END CATCH
END
	--to check and verify whether each row has been fully loaded
	--select * from bronze.crm_cust_info
	--select count(*) from bronze.crm_cust_info
	--select * from bronze.crm_prd_info
	--select count(*) from bronze.crm_prd_info
	--select * from bronze.crm_sales_details
	--select count(*) from bronze.crm_sales_details
	--select * from bronze.erp_cust_az12
	--select count(*) from bronze.erp_cust_az12
	--select * from bronze.erp_loc_a101
	--select count(*) from bronze.erp_loc_a101
	--select * from bronze.erp_px_cat_g1v2
	--select count(*) from bronze.erp_px_cat_g1v2
