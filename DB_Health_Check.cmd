del /F "C:\Output\DB_Health_Check.txt"

echo ---------------------------Database Health Check Summary--------------------------- >> C:\Output\DB_Health_Check.txt
echo =================================================================================== >> C:\Output\DB_Health_Check.txt

echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo --SQL Server Service Health Check of MSSQLServer,SQLServerAgent,SQLBrowser >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "exec master.dbo.xp_servicecontrol 'QUERYSTATE', 'MSSQLServer';" >> C:\Output\DB_Health_Check.txt -h-1 -s,
SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "exec master.dbo.xp_servicecontrol 'QUERYSTATE', 'SQLServerAgent';" >> C:\Output\DB_Health_Check.txt -h-1 -s,
SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "exec master.dbo.xp_servicecontrol 'QUERYSTATE', 'SQLBrowser';" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo --SQL Server DB Status Check >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "SELECT name,create_date,state_desc FROM sys.databases;" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo --Check for Available Disk Space >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "exec master.dbo.xp_fixeddrives;" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo --Check for free memory available for SQL Server >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "SELECT available_physical_memory_kb/1024 as "Total Memory MB",available_physical_memory_kb/(total_physical_memory_kb*1.0)*100 AS "% Memory Free" FROM sys.dm_os_sys_memory;" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo --Check the size of the transaction log >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "DBCC SQLPERF(LOGSPACE);" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo --Check for Index Fragmentation >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "SELECT OBJECT_NAME(OBJECT_ID), index_id,index_type_desc,index_level,avg_fragmentation_in_percent,avg_page_space_used_in_percent,page_count FROM sys.dm_db_index_physical_stats(DB_ID(N'<YOUR DATABASE>'), NULL, NULL, NULL , 'SAMPLED') where avg_fragmentation_in_percent > 0 ORDER BY avg_fragmentation_in_percent DESC;" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------->> C:\Output\DB_Health_Check.txt
echo --Check the DB Space Utilization >> C:\Output\DB_Health_Check.txt


SQLCMD -S "IN-AIR-GPADM1\SQLEXPRESS" -U "sa" -P "Jan@2016" -W -Q "SELECT DB_NAME(database_id) AS DatabaseName,Name AS Logical_Name,Physical_Name,(size * 8) / 1024 SizeMB FROM sys.master_files;;" >> C:\Output\DB_Health_Check.txt -h-1 -s,


echo ----------------------------------------------------------------------------------- >> C:\Output\DB_Health_Check.txt
echo =================================================================================== >> C:\Output\DB_Health_Check.txt

cd C:\Weblogic_12c

powershell ./DB_Health_Check.ps1








