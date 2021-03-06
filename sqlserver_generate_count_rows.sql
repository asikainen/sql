-- GENERATE
DECLARE @schema VARCHAR(128) = 'dbo'

SELECT CONCAT('SELECT '''
       , TABLE_NAME
       , ''' tbl, COUNT(*) cnt FROM '
       , QUOTENAME(TABLE_SCHEMA)
       , '.'
       , QUOTENAME(TABLE_NAME)
       , CASE WHEN RNK = 1 THEN ' ORDER BY 2' ELSE ' UNION ALL' END
       ) stmt
FROM (
       SELECT TABLE_SCHEMA, TABLE_NAME, ROW_NUMBER() OVER (PARTITION BY TABLE_SCHEMA ORDER BY TABLE_NAME DESC) RNK
       FROM INFORMATION_SCHEMA.TABLES
       WHERE TABLE_SCHEMA = @schema
       AND TABLE_TYPE = 'BASE TABLE'
       AND TABLE_NAME NOT LIKE 'sysdiagrams'
) Q
ORDER BY TABLE_NAME

-- EXECUTE
