      *===============================================================*
      * PROJECT    : Employee Management System                       *
      * PROGRAM    : EMPINSERT                                        *
      * PURPOSE    : Insert a new employee into the EMPLOYEE DB2 table*
      * LANGUAGE   : IBM Enterprise COBOL with Embedded SQL           *
      * DATABASE   : IBM DB2 for z/OS                                 *
      *                                                               *
      * HOW IT WORKS:                                                 *
      *   1. The program defines host variables that match the DB2    *
      *      column data types exactly.                               *
      *   2. It moves hard-coded employee data into host variables.   *
      *   3. EXEC SQL INSERT ... END-EXEC sends the INSERT to DB2.    *
      *   4. SQLCODE is checked after the INSERT:                     *
      *      SQLCODE = 0  : Success                                   *
      *      SQLCODE = -803: Duplicate primary key (EMP_ID exists)    *
      *      SQLCODE < 0  : Any other DB2 error                       *
      *                                                               *
      * TO ADD A DIFFERENT EMPLOYEE:                                  *
      *   Change the values in the WORKING-STORAGE section and rerun. *
      *===============================================================*

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EMPINSERT.
       AUTHOR.        MAINFRAME-STUDENT.

      *---------------------------------------------------------------*
      * ENVIRONMENT DIVISION - Describes the computing environment.   *
      * For simple batch DB2 programs, this section is minimal.       *
      *---------------------------------------------------------------*
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

      *---------------------------------------------------------------*
      * DATA DIVISION - Defines all data items used in the program.   *
      *---------------------------------------------------------------*
       DATA DIVISION.

       WORKING-STORAGE SECTION.

      *---------------------------------------------------------------*
      * SQLCA - SQL Communication Area                                *
      *   This is a standard IBM structure that DB2 fills in after    *
      *   EVERY SQL statement. The most important field is SQLCODE:   *
      *     SQLCODE = 0   : SQL statement succeeded                   *
      *     SQLCODE = +100: Row not found (for SELECT)                *
      *     SQLCODE < 0   : SQL error occurred                        *
      *   INCLUDE SQLCA tells the DB2 precompiler to insert the full  *
      *   SQLCA structure definition here automatically.              *
      *---------------------------------------------------------------*
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      *---------------------------------------------------------------*
      * HOST VARIABLES - COBOL variables used inside SQL statements.  *
      *   Each host variable must match the DB2 column type:          *
      *   DB2 INTEGER       <--> COBOL PIC S9(9) COMP                 *
      *   DB2 VARCHAR(30)   <--> COBOL PIC X(30)                      *
      *   DB2 VARCHAR(20)   <--> COBOL PIC X(20)                      *
      *   DB2 DECIMAL(10,2) <--> COBOL PIC S9(8)V9(2) COMP-3         *
      *   Host variables are prefixed with a colon (:) in SQL.        *
      *---------------------------------------------------------------*
       01  WS-HOST-VARIABLES.
           05  WS-EMP-ID         PIC S9(9)       COMP.
           05  WS-EMP-NAME       PIC X(30).
           05  WS-DEPARTMENT     PIC X(20).
           05  WS-SALARY         PIC S9(8)V9(2)  COMP-3.

      *---------------------------------------------------------------*
      * DISPLAY FIELDS - Used to print salary in readable format.     *
      *---------------------------------------------------------------*
       01  WS-DISPLAY-SALARY     PIC ZZZ,ZZZ,ZZ9.99.

      *---------------------------------------------------------------*
      * PROGRAM MESSAGES - Stored here for easy maintenance.          *
      *---------------------------------------------------------------*
       01  WS-MESSAGES.
           05  WS-INSERT-OK   PIC X(50)
               VALUE 'INSERT SUCCESSFUL - EMPLOYEE RECORD ADDED.'.
           05  WS-DUPLICATE   PIC X(50)
               VALUE 'ERROR: EMPLOYEE ID ALREADY EXISTS (DUP KEY).'.
           05  WS-INSERT-ERR  PIC X(50)
               VALUE 'ERROR: INSERT FAILED - CHECK SQLCODE.'.

      *---------------------------------------------------------------*
      * PROCEDURE DIVISION - Contains the actual program logic.       *
      *---------------------------------------------------------------*
       PROCEDURE DIVISION.

      *---------------------------------------------------------------*
      * MAIN-LOGIC: Entry point. Controls program flow.               *
      *---------------------------------------------------------------*
       MAIN-LOGIC.

      *--- Step 1: Move employee data into host variables ---*
      * To insert a different employee, change these values.  *
           MOVE 1006              TO WS-EMP-ID
           MOVE 'FRANK MILLER'    TO WS-EMP-NAME
           MOVE 'FINANCE'         TO WS-DEPARTMENT
           MOVE 65000.00          TO WS-SALARY

           DISPLAY '================================='
           DISPLAY ' EMPLOYEE INSERT PROGRAM         '
           DISPLAY '================================='
           DISPLAY ' EMP ID     : ' WS-EMP-ID
           DISPLAY ' EMP NAME   : ' WS-EMP-NAME
           DISPLAY ' DEPARTMENT : ' WS-DEPARTMENT
           MOVE WS-SALARY TO WS-DISPLAY-SALARY
           DISPLAY ' SALARY     : ' WS-DISPLAY-SALARY
           DISPLAY '---------------------------------'

      *--- Step 2: Execute the SQL INSERT statement ---*
      * :WS-EMP-ID etc. are COBOL host variables.       *
      * The colon (:) prefix tells DB2 these are COBOL  *
      * variables, not SQL column names.                 *
           EXEC SQL
               INSERT INTO YOUR-SCHEMA.EMPLOYEE
                   (EMP_ID,
                    EMP_NAME,
                    DEPARTMENT,
                    SALARY)
               VALUES
                   (:WS-EMP-ID,
                    :WS-EMP-NAME,
                    :WS-DEPARTMENT,
                    :WS-SALARY)
           END-EXEC

      *--- Step 3: Check SQLCODE for success or error ---*
           PERFORM CHECK-SQLCODE

           STOP RUN.

      *---------------------------------------------------------------*
      * CHECK-SQLCODE: Evaluate SQLCODE and display a message.        *
      *   SQLCODE = 0    : Insert was successful.                     *
      *   SQLCODE = -803 : Duplicate primary key error.               *
      *   SQLCODE < 0    : Some other DB2 error.                      *
      *---------------------------------------------------------------*
       CHECK-SQLCODE.
           EVALUATE SQLCODE
               WHEN 0
                   DISPLAY WS-INSERT-OK
               WHEN -803
                   DISPLAY WS-DUPLICATE
                   DISPLAY 'SQLCODE: ' SQLCODE
               WHEN OTHER
                   DISPLAY WS-INSERT-ERR
                   DISPLAY 'SQLCODE: ' SQLCODE
           END-EVALUATE.
