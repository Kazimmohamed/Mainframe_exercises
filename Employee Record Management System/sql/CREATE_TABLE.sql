--***********************************************************************
-- PROJECT  : Employee Management System
-- FILE     : CREATE_TABLE.sql
-- PURPOSE  : Create the EMPLOYEE table in IBM DB2
-- DATABASE : IBM DB2 for z/OS
--
-- INSTRUCTIONS:
--   1. Connect to your DB2 subsystem using SPUFI or a DB2 batch job.
--   2. Replace YOUR-SCHEMA with your actual DB2 schema/collection name
--      (e.g., your TSO userid or the DBA-assigned schema).
--   3. Run this script ONCE to create the table.
--***********************************************************************

--***********************************************************************
-- STEP 1: Create the EMPLOYEE table
--
-- EMP_ID     : Unique employee ID (Primary Key)
-- EMP_NAME   : Employee full name  (up to 30 characters)
-- DEPARTMENT : Department name     (up to 20 characters)
-- SALARY     : Monthly salary      (up to 10 digits, 2 decimal places)
--***********************************************************************

CREATE TABLE YOUR-SCHEMA.EMPLOYEE
  (
    EMP_ID      INTEGER         NOT NULL,
    EMP_NAME    VARCHAR(30)     NOT NULL,
    DEPARTMENT  VARCHAR(20)     NOT NULL,
    SALARY      DECIMAL(10, 2)  NOT NULL,
    CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMP_ID)
  );

--***********************************************************************
-- STEP 2: Grant SELECT/INSERT/UPDATE/DELETE to your TSO userid
--         Replace YOUR-USERID with your actual TSO userid.
--***********************************************************************

GRANT SELECT, INSERT, UPDATE, DELETE
  ON TABLE YOUR-SCHEMA.EMPLOYEE
  TO YOUR-USERID;
