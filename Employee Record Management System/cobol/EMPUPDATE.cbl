      *===============================================================*
      * PROJECT    : Employee Management System                       *
      * PROGRAM    : EMPUPDATE                                        *
      * PURPOSE    : Update the SALARY of an existing employee in DB2 *
      * LANGUAGE   : IBM Enterprise COBOL with Embedded SQL           *
      * DATABASE   : IBM DB2 for z/OS                                 *
      *                                                               *
      * HOW IT WORKS:                                                 *
      *   1. Set WS-SEARCH-ID to identify which employee to update.   *
      *   2. Set WS-NEW-SALARY to the new salary value.               *
      *   3. EXEC SQL UPDATE sets the salary WHERE EMP_ID matches.    *
      *   4. SQLERRD(3) holds the number of rows updated:             *
      *      SQLERRD(3) = 1 : Exactly one row updated (correct).      *
      *      SQLERRD(3) = 0 : No row found with that ID.              *
      *   5. SQLCODE = 0 and SQLERRD(3) = 1 means full success.       *
      *===============================================================*

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EMPUPDATE.
       AUTHOR.        MAINFRAME-STUDENT.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

      *---------------------------------------------------------------*
      * SQLCA - Standard DB2 Communication Area.                      *
      * SQLERRD is an array inside SQLCA. SQLERRD(3) = rows affected. *
      *---------------------------------------------------------------*
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      *---------------------------------------------------------------*
      * HOST VARIABLES                                                 *
      *   WS-SEARCH-ID  : The EMP_ID of the employee to update.       *
      *   WS-NEW-SALARY : The new salary value to set.                *
      *---------------------------------------------------------------*
       01  WS-HOST-VARIABLES.
           05  WS-SEARCH-ID      PIC S9(9)       COMP.
           05  WS-NEW-SALARY     PIC S9(8)V9(2)  COMP-3.

      *---------------------------------------------------------------*
      * DISPLAY FIELDS                                                 *
      *---------------------------------------------------------------*
       01  WS-DISPLAY-SALARY     PIC ZZZ,ZZZ,ZZ9.99.

       PROCEDURE DIVISION.

      *---------------------------------------------------------------*
      * MAIN-LOGIC: Set the target employee ID and new salary.        *
      *   Change WS-SEARCH-ID and WS-NEW-SALARY to update a different *
      *   employee or set a different salary.                          *
      *---------------------------------------------------------------*
       MAIN-LOGIC.
           MOVE 1002         TO WS-SEARCH-ID
           MOVE 88000.00     TO WS-NEW-SALARY

           DISPLAY '================================='
           DISPLAY ' EMPLOYEE SALARY UPDATE PROGRAM  '
           DISPLAY '================================='
           DISPLAY ' UPDATING EMP ID  : ' WS-SEARCH-ID
           MOVE WS-NEW-SALARY TO WS-DISPLAY-SALARY
           DISPLAY ' NEW SALARY       : ' WS-DISPLAY-SALARY
           DISPLAY '---------------------------------'

      *--- Execute the SQL UPDATE statement ---*
      * SET SALARY = :WS-NEW-SALARY  updates only the SALARY column.  *
      * WHERE EMP_ID = :WS-SEARCH-ID limits the update to one row.    *
           EXEC SQL
               UPDATE YOUR-SCHEMA.EMPLOYEE
                  SET SALARY = :WS-NEW-SALARY
                WHERE EMP_ID = :WS-SEARCH-ID
           END-EXEC

      *--- Check SQLCODE and rows affected ---*
           PERFORM CHECK-SQLCODE

           STOP RUN.

      *---------------------------------------------------------------*
      * CHECK-SQLCODE: Evaluate the result of the UPDATE.             *
      *   SQLCODE = 0 means DB2 executed without error, but we also   *
      *   check SQLERRD(3) to know if any row was actually changed.   *
      *---------------------------------------------------------------*
       CHECK-SQLCODE.
           EVALUATE SQLCODE
               WHEN 0
                   IF SQLERRD(3) = 1
                       DISPLAY 'SALARY UPDATED SUCCESSFULLY.'
                       DISPLAY 'ROWS AFFECTED: ' SQLERRD(3)
                   ELSE
                       DISPLAY 'WARNING: NO EMPLOYEE FOUND'
                           ' WITH ID ' WS-SEARCH-ID
                       DISPLAY 'NO ROWS WERE UPDATED.'
                   END-IF
               WHEN OTHER
                   DISPLAY 'DB2 ERROR DURING UPDATE.'
                   DISPLAY 'SQLCODE: ' SQLCODE
           END-EVALUATE.
