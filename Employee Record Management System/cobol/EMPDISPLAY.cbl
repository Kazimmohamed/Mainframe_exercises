      *===============================================================*
      * PROJECT    : Employee Management System                       *
      * PROGRAM    : EMPDISPLAY                                       *
      * PURPOSE    : Display ALL employees from the EMPLOYEE DB2 table*
      * LANGUAGE   : IBM Enterprise COBOL with Embedded SQL           *
      * DATABASE   : IBM DB2 for z/OS                                 *
      *                                                               *
      * HOW IT WORKS (CURSOR LOGIC):                                  *
      *   When a SELECT can return MORE THAN ONE row, you must use    *
      *   a DB2 CURSOR. A cursor is like a pointer that moves through *
      *   the result set one row at a time.                           *
      *                                                               *
      *   The 4 cursor steps are:                                     *
      *   1. DECLARE CURSOR : Defines the SQL query (no execution).   *
      *   2. OPEN CURSOR    : Executes the query, creates result set. *
      *   3. FETCH CURSOR   : Retrieves one row at a time.            *
      *   4. CLOSE CURSOR   : Releases the cursor resources.          *
      *                                                               *
      *   The program loops (PERFORM UNTIL) calling FETCH repeatedly  *
      *   until SQLCODE = +100 (no more rows).                        *
      *===============================================================*

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    EMPDISPLAY.
       AUTHOR.        MAINFRAME-STUDENT.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

      *---------------------------------------------------------------*
      * SQLCA - Standard DB2 communication area.                      *
      *---------------------------------------------------------------*
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      *---------------------------------------------------------------*
      * HOST VARIABLES - Receive column values from each FETCH.       *
      *---------------------------------------------------------------*
       01  WS-HOST-VARIABLES.
           05  WS-EMP-ID         PIC S9(9)       COMP.
           05  WS-EMP-NAME       PIC X(30).
           05  WS-DEPARTMENT     PIC X(20).
           05  WS-SALARY         PIC S9(8)V9(2)  COMP-3.

      *---------------------------------------------------------------*
      * DISPLAY AND COUNTER FIELDS                                     *
      *---------------------------------------------------------------*
       01  WS-DISPLAY-SALARY     PIC ZZZ,ZZZ,ZZ9.99.
       01  WS-ROW-COUNT          PIC 9(4)        VALUE ZERO.

      *---------------------------------------------------------------*
      * END-OF-FETCH FLAG - Used to control the FETCH loop.           *
      *   'N' means more rows to fetch, 'Y' means no more rows.       *
      *---------------------------------------------------------------*
       01  WS-EOF-FLAG           PIC X(1)        VALUE 'N'.
           88  WS-EOF                             VALUE 'Y'.

      *---------------------------------------------------------------*
      * DECLARE CURSOR SECTION                                         *
      *   DECLARE must appear in WORKING-STORAGE or at the top of     *
      *   PROCEDURE DIVISION. It only DEFINES the query - no data     *
      *   is retrieved yet. ORDER BY EMP_ID sorts the output.         *
      *---------------------------------------------------------------*
           EXEC SQL
               DECLARE EMP-CURSOR CURSOR FOR
                   SELECT EMP_ID,
                          EMP_NAME,
                          DEPARTMENT,
                          SALARY
                     FROM YOUR-SCHEMA.EMPLOYEE
                    ORDER BY EMP_ID
           END-EXEC.

       PROCEDURE DIVISION.

      *---------------------------------------------------------------*
      * MAIN-LOGIC: Controls the full cursor lifecycle.               *
      *---------------------------------------------------------------*
       MAIN-LOGIC.
           DISPLAY '================================='
           DISPLAY ' DISPLAY ALL EMPLOYEES PROGRAM   '
           DISPLAY '================================='
           DISPLAY ' ID    NAME                      '
           DISPLAY '       DEPARTMENT    SALARY       '
           DISPLAY '---------------------------------'

      *--- Step 1: OPEN the cursor to execute the SELECT query ---*
           EXEC SQL
               OPEN EMP-CURSOR
           END-EXEC

           IF SQLCODE NOT EQUAL 0
               DISPLAY 'ERROR OPENING CURSOR. SQLCODE: ' SQLCODE
               STOP RUN
           END-IF

      *--- Step 2: Loop fetching one row at a time ---*
           PERFORM FETCH-AND-DISPLAY
               UNTIL WS-EOF

      *--- Step 3: CLOSE the cursor to free DB2 resources ---*
           EXEC SQL
               CLOSE EMP-CURSOR
           END-EXEC

           DISPLAY '---------------------------------'
           DISPLAY 'TOTAL EMPLOYEES: ' WS-ROW-COUNT
           DISPLAY '================================='
           STOP RUN.

      *---------------------------------------------------------------*
      * FETCH-AND-DISPLAY: Fetches one row and displays it.           *
      *   FETCH moves the cursor to the next row and copies column    *
      *   values into the host variables listed after INTO.           *
      *   When SQLCODE = +100, there are no more rows to fetch.       *
      *---------------------------------------------------------------*
       FETCH-AND-DISPLAY.
           EXEC SQL
               FETCH EMP-CURSOR
                 INTO :WS-EMP-ID,
                      :WS-EMP-NAME,
                      :WS-DEPARTMENT,
                      :WS-SALARY
           END-EXEC

           EVALUATE SQLCODE
               WHEN 0
      *--- Row found: display it and increment counter ---*
                   ADD 1 TO WS-ROW-COUNT
                   MOVE WS-SALARY TO WS-DISPLAY-SALARY
                   DISPLAY ' ID: ' WS-EMP-ID
                       '  ' WS-EMP-NAME
                   DISPLAY '       ' WS-DEPARTMENT
                       '  ' WS-DISPLAY-SALARY
               WHEN +100
      *--- No more rows: set the EOF flag to exit the loop ---*
                   MOVE 'Y' TO WS-EOF-FLAG
               WHEN OTHER
      *--- Unexpected DB2 error: display and stop ---*
                   DISPLAY 'FETCH ERROR. SQLCODE: ' SQLCODE
                   MOVE 'Y' TO WS-EOF-FLAG
           END-EVALUATE.
