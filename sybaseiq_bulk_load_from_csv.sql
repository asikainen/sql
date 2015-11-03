/*
* 2015-10-31
* Joonas Asikainen
* Sybase IQ CSV import using bulk load:
* 1. Generator script to generate bulk load commands.
* 2. Sample executable script.
*/
--
/*
SELECT STRING(
    CASE 
            WHEN rnk1 = 1 then STRING('TRUNCATE TABLE [thescema].', table_name, ';\n', 'LOAD TABLE [theschema].', table_name, ' ( ')
            ELSE ''
    END, 
    STRING(char(9), column_name, CASE WHEN RNK2 = 1 THEN ' ''\\n'' ' ELSE ' '','', ' END ), 
    CASE 
            WHEN rnk2 = 1 THEN STRING(' ) \nFROM ''/path/to/bulkloadmountpoint/', table_name, '.csv'' WITH CHECKPOINT ON  BLOCK SIZE 50000  NOTIFY 1000 ESCAPES OFF QUOTES ON HEADER SKIP 1 ON FILE ERROR ROLLBACK;\nGO\n')
            ELSE ''
    END
    ) stmt
FROM (
SELECT row_number() OVER (PARTITION BY obj.name ORDER BY col.colid) RNK1,
    row_number() OVER (PARTITION BY obj.name ORDER BY col.colid DESC) RNK2,
    obj.name table_name,
    col.name column_name,
    col.colid
FROM dbo.sysobjects obj
JOIN dbo.syscolumns col
ON obj.id=col.id
JOIN dbo.sysusers usr
ON obj.uid=usr.uid
JOIN dbo.systypes typ
ON col.type      = typ.type
AND col.usertype = typ.usertype
WHERE usr.name   ='TFW'
AND obj.type = 'U'
AND obj.name IN ('<N/A>'
    ,'TheTable'
)
ORDER BY obj.name,
    col.colid 
) Q
;
GO
--*/

TRUNCATE TABLE TheSchema.TestRun;
LOAD TABLE TFW.TestRun ( 	TestRun_ID ',', 
	RunDate ',', 
	SnapshotDate ',', 
	RunType ',', 
	Description ',', 
	Username ',', 
	NumTests ',', 
	NumHardFails ',', 
	Duration_ms '\n'  ) 
FROM '/path/to/bulkloadmountpoint/TestRun.csv' WITH CHECKPOINT ON  BLOCK SIZE 50000  NOTIFY 1000 ESCAPES OFF QUOTES ON HEADER SKIP 1 ON FILE ERROR ROLLBACK;
GO
