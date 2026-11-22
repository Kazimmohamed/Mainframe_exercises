       IDENTIFICATION DIVISION.
       PROGRAM-ID. EMPLOYEE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-CHOICE        PIC 9 VALUE 0.
       01  WS-COUNT         PIC 99 VALUE 0.
       01  WS-I             PIC 99.
       01  WS-SEARCH-ID     PIC 9(5).
       01  WS-FOUND         PIC X VALUE 'N'.

       01  WS-EMPLOYEE-TABLE.
           05 WS-EMPLOYEE OCCURS 50 TIMES.
              10 WS-EMP-ID   PIC 9(5).
              10 WS-EMP-NAME PIC X(25).
              10 WS-EMP-DEPT PIC X(20).
              10 WS-EMP-SAL  PIC 9(7).

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM UNTIL WS-CHOICE = 4
               DISPLAY " "
               DISPLAY "===== EMPLOYEE MANAGEMENT ====="
               DISPLAY "1. Add Employee"
               DISPLAY "2. Display Employees"
               DISPLAY "3. Search Employee"
               DISPLAY "4. Exit"
               DISPLAY "Enter choice: "
               ACCEPT WS-CHOICE

               EVALUATE WS-CHOICE
                   WHEN 1
                       PERFORM ADD-EMPLOYEE
                   WHEN 2
                       PERFORM DISPLAY-EMPLOYEES
                   WHEN 3
                       PERFORM SEARCH-EMPLOYEE
                   WHEN 4
                       DISPLAY "Exiting Employee Management."
                   WHEN OTHER
                       DISPLAY "Invalid choice. Try again."
               END-EVALUATE
           END-PERFORM

           STOP RUN.

       ADD-EMPLOYEE.
           IF WS-COUNT >= 50
               DISPLAY "Employee limit reached."
           ELSE
               ADD 1 TO WS-COUNT
               DISPLAY "Enter Employee ID: "
               ACCEPT WS-EMP-ID(WS-COUNT)
               DISPLAY "Enter Employee Name: "
               ACCEPT WS-EMP-NAME(WS-COUNT)
               DISPLAY "Enter Department: "
               ACCEPT WS-EMP-DEPT(WS-COUNT)
               DISPLAY "Enter Salary (whole amount): "
               ACCEPT WS-EMP-SAL(WS-COUNT)
               DISPLAY "Employee added successfully."
           END-IF.

       DISPLAY-EMPLOYEES.
           IF WS-COUNT = 0
               DISPLAY "No employee records found."
           ELSE
               PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > WS-COUNT
                   DISPLAY "-----------------------------"
                   DISPLAY "ID: " WS-EMP-ID(WS-I)
                   DISPLAY "NAME: " WS-EMP-NAME(WS-I)
                   DISPLAY "DEPARTMENT: " WS-EMP-DEPT(WS-I)
                   DISPLAY "SALARY: " WS-EMP-SAL(WS-I)
               END-PERFORM
           END-IF.

       SEARCH-EMPLOYEE.
           DISPLAY "Enter Employee ID to search: "
           ACCEPT WS-SEARCH-ID
           MOVE 'N' TO WS-FOUND

           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-COUNT
               IF WS-EMP-ID(WS-I) = WS-SEARCH-ID
                   MOVE 'Y' TO WS-FOUND
                   DISPLAY "Employee found:"
                   DISPLAY "ID: " WS-EMP-ID(WS-I)
                   DISPLAY "NAME: " WS-EMP-NAME(WS-I)
                   DISPLAY "DEPARTMENT: " WS-EMP-DEPT(WS-I)
                   DISPLAY "SALARY: " WS-EMP-SAL(WS-I)
               END-IF
           END-PERFORM

           IF WS-FOUND = 'N'
               DISPLAY "Employee not found."
           END-IF.
