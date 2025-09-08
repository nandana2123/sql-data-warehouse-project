--This script creates a database called "DataWarehouse" with 3 schemas defined as "Bronze", "Silver" and "Gold" respectively.

use master;
--create database
create database DataWarehouse; 
go
  
use DataWarehouse;
go

--create schemas
create schema bronze;
go
  
create schema silver;
go
  
create schema gold;
go
