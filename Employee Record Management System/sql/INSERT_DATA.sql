--***********************************************************************
-- PROJECT  : Employee Management System
-- FILE     : INSERT_DATA.sql
-- PURPOSE  : Insert 5 sample employee records into the EMPLOYEE table
-- DATABASE : IBM DB2 for z/OS
--
-- INSTRUCTIONS:
--   1. Run CREATE_TABLE.sql FIRST before running this script.
--   2. Replace YOUR-SCHEMA with your actual DB2 schema name.
--   3. Run this script using SPUFI or a DB2 batch JCL job.
--***********************************************************************

--***********************************************************************
-- Insert 5 sample employees into the EMPLOYEE table
--***********************************************************************

INSERT INTO YOUR-SCHEMA.EMPLOYEE
  (EMP_ID, EMP_NAME, DEPARTMENT, SALARY)
VALUES
  (1001, 'ALICE JOHNSON',   'FINANCE',       75000.00);

INSERT INTO YOUR-SCHEMA.EMPLOYEE
  (EMP_ID, EMP_NAME, DEPARTMENT, SALARY)
VALUES
  (1002, 'BOB SMITH',       'IT',            82000.00);

INSERT INTO YOUR-SCHEMA.EMPLOYEE
  (EMP_ID, EMP_NAME, DEPARTMENT, SALARY)
VALUES
  (1003, 'CAROL WILLIAMS',  'HUMAN RESOURCES', 68000.00);

INSERT INTO YOUR-SCHEMA.EMPLOYEE
  (EMP_ID, EMP_NAME, DEPARTMENT, SALARY)
VALUES
  (1004, 'DAVID BROWN',     'OPERATIONS',    71000.00);

INSERT INTO YOUR-SCHEMA.EMPLOYEE
  (EMP_ID, EMP_NAME, DEPARTMENT, SALARY)
VALUES
  (1005, 'EVA MARTINEZ',    'IT',            90000.00);

--***********************************************************************
-- Verify the inserts
--***********************************************************************

SELECT EMP_ID,
       EMP_NAME,
       DEPARTMENT,
       SALARY
  FROM YOUR-SCHEMA.EMPLOYEE
  ORDER BY EMP_ID;
