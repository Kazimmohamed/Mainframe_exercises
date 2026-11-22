      *===============================================================*
      * PROJECT    : Employee Management System                       *
      * PROGRAM    : EMPDELETE                                        *
      * PURPOSE    : Delete an employee record from the EMPLOYEE table*
      * LANGUAGE   : IBM Enterprise COBOL with Embedded SQL           *
      * DATABASE   : IBM DB2 for z/OS                                 *
      *                                                               *
      * HOW IT WORKS:                                                 *
      *   1. Set WS-SEARCH-ID to the EMP_ID of the employee to delete.*
      *   2. EXEC SQL DELETE ... WHERE EMP_ID = :WS-SEARCH-ID removes *
      *      the matching row from the EMPLOYEE table.                *
      *   3. SQLCODE = 0 and SQLERRD(3) = 1 means one row was deleted.*
      *   4. SQLERRD(3) = 0 means no row matched that ID.             *
      *                                                               *
      * CAUTION: DB2 DELETE is permanent. There is no undo unless     *
      *   you are inside an explicit COMMIT/ROLLBACK transaction block.*
      *   In batch COBOL, DB2 commits when the program ends normally. *
      *===============================================================*

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EMPDELETE.
       AUTHOR.        MAINFRAME-STUDENT.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

      *---------------------------------------------------------------*
      * SQLCA - Standard DB2 Communication Area.                      *
      *---------------------------------------------------------------*
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      *---------------------------------------------------------------*
      * HOST VARIABLE                                                  *
      *   WS-SEARCH-ID : The EMP_ID of the employee to delete.        *
      *---------------------------------------------------------------*
       01  WS-HOST-VARIABLES.
           05  WS-SEARCH-ID      PIC S9(9)       COMP.

       PROCEDURE DIVISION.

      *---------------------------------------------------------------*
      * MAIN-LOGIC: Set the EMP_ID to delete and perform the DELETE.  *
      *   Change WS-SEARCH-ID to target a different employee.         *
      *---------------------------------------------------------------*
       MAIN-LOGIC.
           MOVE 1006 TO WS-SEARCH-ID

           DISPLAY '================================='
           DISPLAY ' EMPLOYEE DELETE PROGRAM         '
           DISPLAY '================================='
           DISPLAY ' DELETING EMP ID: ' WS-SEARCH-ID
           DISPLAY '---------------------------------'

      *--- Execute the SQL DELETE statement ---*
      * WHERE EMP_ID = :WS-SEARCH-ID ensures only one row is deleted. *
      * Without a WHERE clause, ALL rows would be deleted!            *
           EXEC SQL
               DELETE FROM YOUR-SCHEMA.EMPLOYEE
                WHERE EMP_ID = :WS-SEARCH-ID
           END-EXEC

      *--- Check SQLCODE and display outcome ---*
           PERFORM CHECK-SQLCODE

           STOP RUN.

      *---------------------------------------------------------------*
      * CHECK-SQLCODE: Evaluate the result of the DELETE.             *
      *   SQLCODE = 0 means DB2 executed OK.                          *
      *   SQLERRD(3) tells us how many rows were actually deleted.    *
      *---------------------------------------------------------------*
       CHECK-SQLCODE.
           EVALUATE SQLCODE
               WHEN 0
                   IF SQLERRD(3) = 1
                       DISPLAY 'EMPLOYEE DELETED SUCCESSFULLY.'
                       DISPLAY 'EMP ID ' WS-SEARCH-ID
                           ' HAS BEEN REMOVED.'
                       DISPLAY 'ROWS DELETED: ' SQLERRD(3)
                   ELSE
                       DISPLAY 'WARNING: NO EMPLOYEE FOUND'
                           ' WITH ID ' WS-SEARCH-ID
                       DISPLAY 'NO ROWS WERE DELETED.'
                   END-IF
               WHEN OTHER
                   DISPLAY 'DB2 ERROR DURING DELETE.'
                   DISPLAY 'SQLCODE: ' SQLCODE
           END-EVALUATE.
