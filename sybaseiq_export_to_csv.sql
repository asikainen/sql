/*
* 2015-10-31
* Joonas Asikainen
* Sybase IQ CSV export
*/
SELECT * FROM [theschema].[thetable];
OUTPUT TO "C:\path\to\file.csv" DELIMITED BY ',' FORMAT TEXT WITH COLUMN NAMES; 

