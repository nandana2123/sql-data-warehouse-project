EXEC silver.load_silver

CREATE
	OR

ALTER PROCEDURE silver.load_silver
AS
BEGIN
	PRINT 'Truncating silver.crm_cust_info'

	TRUNCATE TABLE silver.crm_cust_info

	PRINT 'inserting into table silver.crm_cust_info'

	INSERT INTO silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)
	SELECT cst_id,
		cst_key,
		trim(cst_firstname) AS cst_firstname,
		trim(cst_lastname) AS cst_lastname,
		CASE 
			WHEN trim(upper(cst_gndr)) = 'F'
				THEN 'Female'
			WHEN trim(upper(cst_gndr)) = 'M'
				THEN 'Male'
			ELSE 'n/a'
			END AS cst_gndr,
		CASE 
			WHEN upper(trim(cst_marital_status)) = 'S'
				THEN 'Single'
			WHEN upper(trim(cst_marital_status)) = 'M'
				THEN 'Married'
			ELSE 'n/a'
			END AS cst_marital_status,
		cst_create_date
	FROM bronze.crm_cust_info

	PRINT 'truncating table silver.crm_prd_info'

	TRUNCATE TABLE silver.crm_prd_info

	PRINT '>>inserting data into silver.crm_prd_info'

	INSERT INTO silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
	SELECT prd_id,
		replace(substring(prd_key, 1, 5), '-', '_') AS cat_id,
		SUBSTRING(prd_key, 7, len(prd_key)) AS prd_key,
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost,
		CASE 
			WHEN upper(trim(prd_line)) = 'M'
				THEN 'Mountain'
			WHEN upper(trim(prd_line)) = 'R'
				THEN 'Road'
			WHEN upper(trim(prd_line)) = 'S'
				THEN 'Other Sales'
			WHEN upper(trim(prd_line)) = 'T'
				THEN 'Touring'
			ELSE 'n/a'
			END AS prd_line,
		cast(prd_start_dt AS DATE) AS prd_start_dt,
		cast(lead(prd_start_dt) OVER (
				PARTITION BY prd_key ORDER BY prd_start_dt
				) - 1 AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info

	PRINT 'truncating table silver.crm_sales_details'

	TRUNCATE TABLE silver.crm_sales_details

	PRINT '>>inserting data into silver.crm_sales_details'

	INSERT INTO silver.crm_sales_details (
		sls_order_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
	SELECT sls_order_num,
		sls_prd_key,
		sls_cust_id,
		CASE 
			WHEN sls_order_dt = 0
				OR len(sls_order_dt) != 8
				THEN NULL
			ELSE cast(cast(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
		CASE 
			WHEN sls_ship_dt = 0
				OR len(sls_ship_dt) != 8
				THEN NULL
			ELSE cast(cast(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
		CASE 
			WHEN sls_due_dt = 0
				OR len(sls_due_dt) != 8
				THEN NULL
			ELSE cast(cast(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
		CASE 
			WHEN sls_sales IS NULL
				OR sls_sales <= 0
				OR sls_sales != sls_quantity * abs(sls_price)
				THEN sls_quantity * abs(sls_price)
			ELSE sls_sales
			END AS sls_sales,
		sls_quantity,
		CASE 
			WHEN sls_price <= 0
				OR sls_price IS NULL
				THEN sls_sales / nullif(sls_quantity, 0)
			ELSE sls_price
			END AS sls_price
	FROM bronze.crm_sales_details

	PRINT 'truncating table silver.erp_cust_az12'

	TRUNCATE TABLE silver.erp_cust_az12

	PRINT '>>inserting data into silver.erp_cust_az12'

	INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
		)
	SELECT CASE 
			WHEN cid LIKE 'NAS%'
				THEN SUBSTRING(cid, 4, len(cid))
			ELSE cid
			END AS cid,
		CASE 
			WHEN bdate > GETDATE()
				THEN NULL
			ELSE bdate
			END AS bdate,
		CASE 
			WHEN trim(upper(gen)) IN (
					'F',
					'Female'
					)
				THEN 'Female'
			WHEN trim(upper(gen)) IN (
					'M',
					'Male'
					)
				THEN 'Male'
			ELSE 'n/a'
			END AS gen
	FROM bronze.erp_cust_az12

	PRINT 'truncating table silver.erp_loc_a101'

	TRUNCATE TABLE silver.erp_loc_a101

	PRINT '>>inserting data into silver.erp_loc_a101'

	INSERT INTO silver.erp_loc_a101 (
		cid,
		cntry
		)
	SELECT REPLACE(cid, '-', '') cid,
		CASE 
			WHEN trim(cntry) = 'DE'
				THEN 'Germany'
			WHEN trim(upper(cntry)) IN (
					'US',
					'USA'
					)
				THEN 'United States'
			WHEN trim(cntry) = ''
				OR cntry IS NULL
				THEN 'n/a'
			ELSE trim(cntry)
			END AS cntry
	FROM bronze.erp_loc_a101

	PRINT 'truncating table silver.erp_px_cat_g1v2'

	TRUNCATE TABLE silver.erp_px_cat_g1v2

	PRINT '>>inserting data into silver.erp_px_cat_g1v2'

	INSERT INTO silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
		)
	SELECT id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2
END
