      *===============================================================*
      * PROJECT    : Employee Management System                       *
      * PROGRAM    : EMPLOOKUP                                        *
      * PURPOSE    : Search for an employee by EMP_ID in DB2         *
      * LANGUAGE   : IBM Enterprise COBOL with Embedded SQL           *
      * DATABASE   : IBM DB2 for z/OS                                 *
      *                                                               *
      * HOW IT WORKS:                                                 *
      *   1. The program sets the employee ID to search for.          *
      *   2. EXEC SQL SELECT ... INTO ... END-EXEC fetches exactly    *
      *      one row (single-row SELECT) from DB2 into host variables.*
      *   3. SQLCODE is checked:                                      *
      *      SQLCODE = 0   : Employee found, display the record.      *
      *      SQLCODE = +100: No row found with that EMP_ID.           *
      *      SQLCODE < 0   : DB2 error occurred.                      *
      *                                                               *
      * NOTE: SELECT...INTO is used for single-row retrieval.         *
      *   For multiple rows, a CURSOR must be used (see EMPDISPLAY).  *
      *===============================================================*

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EMPLOOKUP.
       AUTHOR.        MAINFRAME-STUDENT.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

      *---------------------------------------------------------------*
      * SQLCA - SQL Communication Area (standard DB2 structure).      *
      * Always INCLUDE SQLCA in every COBOL-DB2 program.              *
      *---------------------------------------------------------------*
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      *---------------------------------------------------------------*
      * HOST VARIABLES - Must match DB2 column data types exactly.    *
      * WS-SEARCH-ID is used in the WHERE clause to identify the row. *
      * The other variables receive the retrieved column values.       *
      *---------------------------------------------------------------*
       01  WS-HOST-VARIABLES.
           05  WS-SEARCH-ID      PIC S9(9)       COMP.
           05  WS-EMP-ID         PIC S9(9)       COMP.
           05  WS-EMP-NAME       PIC X(30).
           05  WS-DEPARTMENT     PIC X(20).
           05  WS-SALARY         PIC S9(8)V9(2)  COMP-3.

      *---------------------------------------------------------------*
      * DISPLAY FIELD - Formats salary for human-readable display.    *
      *---------------------------------------------------------------*
       01  WS-DISPLAY-SALARY     PIC ZZZ,ZZZ,ZZ9.99.

       PROCEDURE DIVISION.

      *---------------------------------------------------------------*
      * MAIN-LOGIC: Set the employee ID to search and run the lookup. *
      *   Change WS-SEARCH-ID value to look up a different employee.  *
      *---------------------------------------------------------------*
       MAIN-LOGIC.
           MOVE 1003 TO WS-SEARCH-ID

           DISPLAY '================================='
           DISPLAY ' EMPLOYEE LOOKUP PROGRAM         '
           DISPLAY '================================='
           DISPLAY ' SEARCHING FOR EMP ID: ' WS-SEARCH-ID
           DISPLAY '---------------------------------'

      *--- Execute a single-row SELECT from DB2 ---*
      * SELECT ... INTO fetches one row's columns into host variables. *
      * The WHERE clause uses :WS-SEARCH-ID (the colon is required).  *
           EXEC SQL
               SELECT EMP_ID,
                      EMP_NAME,
                      DEPARTMENT,
                      SALARY
                 INTO :WS-EMP-ID,
                      :WS-EMP-NAME,
                      :WS-DEPARTMENT,
                      :WS-SALARY
                 FROM YOUR-SCHEMA.EMPLOYEE
                WHERE EMP_ID = :WS-SEARCH-ID
           END-EXEC

      *--- Check SQLCODE and display result ---*
           PERFORM CHECK-SQLCODE

           STOP RUN.

      *---------------------------------------------------------------*
      * CHECK-SQLCODE: Determine whether the SELECT worked.           *
      *   SQLCODE = 0   : Row found - display employee details.       *
      *   SQLCODE = +100: No employee with that ID in the table.      *
      *   SQLCODE < 0   : DB2 encountered an error.                   *
      *---------------------------------------------------------------*
       CHECK-SQLCODE.
           EVALUATE SQLCODE
               WHEN 0
                   DISPLAY 'EMPLOYEE FOUND:'
                   DISPLAY '  EMP ID     : ' WS-EMP-ID
                   DISPLAY '  EMP NAME   : ' WS-EMP-NAME
                   DISPLAY '  DEPARTMENT : ' WS-DEPARTMENT
                   MOVE WS-SALARY TO WS-DISPLAY-SALARY
                   DISPLAY '  SALARY     : ' WS-DISPLAY-SALARY
               WHEN +100
                   DISPLAY 'NO EMPLOYEE FOUND WITH ID: '
                       WS-SEARCH-ID
               WHEN OTHER
                   DISPLAY 'DB2 ERROR DURING SELECT.'
                   DISPLAY 'SQLCODE: ' SQLCODE
           END-EVALUATE.
