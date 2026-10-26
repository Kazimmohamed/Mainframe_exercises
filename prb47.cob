
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANKSUMMARY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 N PIC 9(5).
       01 I PIC 9(5).

       01 BRANCH-ID PIC X(3).
       01 TRANS-TYPE PIC X.
       01 AMOUNT PIC 9(8)V99.

       01 DEPOSITS PIC 9(10)V99 VALUE 0.
       01 WITHDRAWALS PIC 9(10)V99 VALUE 0.
       01 NET-AMOUNT PIC S9(10)V99.

       PROCEDURE DIVISION.

           ACCEPT N

           PERFORM VARYING I FROM 1 BY 1
               UNTIL I > N

               ACCEPT BRANCH-ID
               ACCEPT TRANS-TYPE
               ACCEPT AMOUNT

               IF TRANS-TYPE = 'D'
                   ADD AMOUNT TO DEPOSITS
               ELSE
                   ADD AMOUNT TO WITHDRAWALS
               END-IF

           END-PERFORM

           COMPUTE NET-AMOUNT = DEPOSITS
                              - WITHDRAWALS

           DISPLAY "Deposits: " DEPOSITS
           DISPLAY "Withdrawals: " WITHDRAWALS
           DISPLAY "Net: " NET-AMOUNT

           STOP RUN.
