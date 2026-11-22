# Employee Management System
### IBM Mainframe Project — COBOL + DB2 + JCL

---

## Table of Contents

1. [Project Introduction](#1-project-introduction)
2. [Project Objectives](#2-project-objectives)
3. [Technologies Used](#3-technologies-used)
4. [Project Structure](#4-project-structure)
5. [Database Table Structure](#5-database-table-structure)
6. [How COBOL Communicates with DB2](#6-how-cobol-communicates-with-db2)
7. [How Embedded SQL Works](#7-how-embedded-sql-works)
8. [The 4-Step Build Process](#8-the-4-step-build-process)
9. [How to Submit JCL Jobs](#9-how-to-submit-jcl-jobs)
10. [How to Check Output Using SDSF](#10-how-to-check-output-using-sdsf)
11. [How to Test Each Functionality](#11-how-to-test-each-functionality)
12. [Quick Reference — Placeholder Values](#12-quick-reference--placeholder-values)
13. [SQLCODE Reference](#13-sqlcode-reference)

---

## 1. Project Introduction

The **Employee Management System** is a beginner-friendly IBM Mainframe project that demonstrates
how to build a real batch data management application using the core mainframe technologies:

- **COBOL** for program logic
- **IBM DB2** as the relational database
- **Embedded SQL** to communicate between COBOL and DB2
- **JCL** to submit and execute programs on z/OS

This project creates and manages employee records stored in a DB2 table. All five fundamental
database operations — **Insert, Select, Display All, Update, and Delete** — are implemented as
separate COBOL programs that run as batch jobs on z/OS.

> **Who is this for?**
> This project is designed for students and developers who are brand-new to mainframe development.
> Every file is heavily commented so you understand *why* each line exists, not just *what* it does.

---

## 2. Project Objectives

| # | Objective |
|---|-----------|
| 1 | Understand the IBM z/OS batch programming model |
| 2 | Learn how to write COBOL programs with embedded DB2 SQL |
| 3 | Understand the SQLCA structure and SQLCODE error handling |
| 4 | Learn the 4-step build process: Precompile to Compile to Link-Edit to Bind |
| 5 | Write and submit JCL jobs on z/OS |
| 6 | Use SDSF to monitor and view job output |
| 7 | Perform all five SQL operations from COBOL programs |

---

## 3. Technologies Used

### COBOL — COmmon Business-Oriented Language
- The programming language used for all business logic.
- IBM Enterprise COBOL for z/OS is used here.
- SQL statements are **embedded directly** inside COBOL code.

### IBM DB2 for z/OS
- IBM's enterprise relational database management system (RDBMS).
- Runs as a subsystem on z/OS.
- All employee data is stored and managed here.

### SQL — Structured Query Language
- Used inside COBOL programs via `EXEC SQL ... END-EXEC` blocks.
- SQL operations used: CREATE TABLE, INSERT, SELECT, UPDATE, DELETE.

### JCL — Job Control Language
- Tells z/OS *what* to run, *where* the data is, and *how* to run it.
- Every batch program on z/OS is submitted through a JCL job.

---

## 4. Project Structure

```
Employee Record Management System/
|
+-- cobol/
|   +-- EMPINSERT.cbl      <- Insert a new employee
|   +-- EMPLOOKUP.cbl      <- Search employee by ID
|   +-- EMPDISPLAY.cbl     <- Display all employees (uses CURSOR)
|   +-- EMPUPDATE.cbl      <- Update employee salary
|   +-- EMPDELETE.cbl      <- Delete an employee
|
+-- sql/
|   +-- CREATE_TABLE.sql   <- DB2 DDL to create the EMPLOYEE table
|   +-- INSERT_DATA.sql    <- Insert 5 sample employee records
|
+-- jcl/
|   +-- CRTABLE.jcl        <- Run SQL to create the table
|   +-- COMPILE.jcl        <- 4-step build: precompile/compile/link/bind
|   +-- RUNINSRT.jcl       <- Run EMPINSERT program
|   +-- RUNLOOKP.jcl       <- Run EMPLOOKUP program
|   +-- RUNDSPLY.jcl       <- Run EMPDISPLAY program
|   +-- RUNUPDAT.jcl       <- Run EMPUPDATE program
|   +-- RUNDELET.jcl       <- Run EMPDELETE program
|
+-- docs/
+-- README.md
```

---

## 5. Database Table Structure

### Table Name: EMPLOYEE

| Column     | DB2 Type       | COBOL Host Variable   | Description             |
|------------|----------------|-----------------------|-------------------------|
| EMP_ID     | INTEGER        | PIC S9(9) COMP        | Unique employee ID (PK) |
| EMP_NAME   | VARCHAR(30)    | PIC X(30)             | Full name               |
| DEPARTMENT | VARCHAR(20)    | PIC X(20)             | Department name         |
| SALARY     | DECIMAL(10, 2) | PIC S9(8)V9(2) COMP-3 | Monthly salary          |

### COBOL Type Mapping Explained

| DB2 Type       | COBOL Type            | Why                                              |
|----------------|-----------------------|--------------------------------------------------|
| INTEGER        | PIC S9(9) COMP        | 4-byte binary integer (COMP = binary storage)    |
| VARCHAR(n)     | PIC X(n)              | Fixed alphanumeric; unused bytes padded          |
| DECIMAL(10, 2) | PIC S9(8)V9(2) COMP-3 | Packed decimal; V = implied decimal point        |

The V in PIC S9(8)V9(2) means the decimal point is implied (not stored as a character).
COMP-3 means packed decimal — the most efficient numeric storage format in COBOL.

### Sample Employee Data

| EMP_ID | EMP_NAME        | DEPARTMENT      | SALARY    |
|--------|-----------------|-----------------|-----------|
| 1001   | ALICE JOHNSON   | FINANCE         | 75,000.00 |
| 1002   | BOB SMITH       | IT              | 82,000.00 |
| 1003   | CAROL WILLIAMS  | HUMAN RESOURCES | 68,000.00 |
| 1004   | DAVID BROWN     | OPERATIONS      | 71,000.00 |
| 1005   | EVA MARTINEZ    | IT              | 90,000.00 |

---

## 6. How COBOL Communicates with DB2

COBOL and DB2 communicate through three key mechanisms:

### A) SQLCA — SQL Communication Area

Every COBOL-DB2 program includes:

```cobol
EXEC SQL
    INCLUDE SQLCA
END-EXEC.
```

The DB2 precompiler inserts a standard block of COBOL variables that DB2 fills in after
every SQL statement. The most important field is SQLCODE:

- 0    = SQL statement succeeded
- +100 = Row not found (SELECT returned no rows)
- Negative = DB2 error (e.g., -803 = duplicate primary key)

### B) Host Variables

COBOL variables used inside SQL are called host variables.
They must be prefixed with a colon when used in EXEC SQL blocks:

```cobol
*-- COBOL variable definition:
05  WS-EMP-ID  PIC S9(9) COMP.

*-- Usage inside SQL (the colon is mandatory):
EXEC SQL
    SELECT EMP_NAME FROM EMPLOYEE
     WHERE EMP_ID = :WS-EMP-ID
END-EXEC.
```

### C) EXEC SQL / END-EXEC

Every SQL statement inside COBOL is wrapped in:

```cobol
EXEC SQL
    ... SQL statement here ...
END-EXEC.
```

The DB2 precompiler reads these blocks and processes them before the COBOL compiler runs.

---

## 7. How Embedded SQL Works

### Single-Row SELECT — used in EMPLOOKUP

When you know a SELECT returns exactly one row, use SELECT INTO:

```cobol
EXEC SQL
    SELECT EMP_NAME, SALARY
      INTO :WS-EMP-NAME, :WS-SALARY
      FROM EMPLOYEE
     WHERE EMP_ID = :WS-SEARCH-ID
END-EXEC.
```

SQLCODE = 0 means found. SQLCODE = +100 means no matching row.

### Multi-Row SELECT with CURSOR — used in EMPDISPLAY

When SELECT can return more than one row, you must use a DB2 CURSOR:

```
Step 1 - DECLARE CURSOR: Define the SQL query (not executed yet)
Step 2 - OPEN CURSOR:    Execute the query; DB2 creates result set
Step 3 - FETCH CURSOR:   Retrieve one row at a time
Step 4 - CLOSE CURSOR:   Release resources when done
```

Loop on FETCH until SQLCODE = +100 (no more rows).

### INSERT

```cobol
EXEC SQL
    INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, DEPARTMENT, SALARY)
    VALUES (:WS-EMP-ID, :WS-EMP-NAME, :WS-DEPARTMENT, :WS-SALARY)
END-EXEC.
```

### UPDATE

```cobol
EXEC SQL
    UPDATE EMPLOYEE
       SET SALARY = :WS-NEW-SALARY
     WHERE EMP_ID = :WS-SEARCH-ID
END-EXEC.
```

Check SQLERRD(3) in SQLCA to verify how many rows were updated.

### DELETE

```cobol
EXEC SQL
    DELETE FROM EMPLOYEE
     WHERE EMP_ID = :WS-SEARCH-ID
END-EXEC.
```

Check SQLERRD(3) to confirm a row was deleted.

---

## 8. The 4-Step Build Process

Before running any COBOL-DB2 program, it must be built in 4 steps (all in COMPILE.jcl):

```
Your COBOL Source (.cbl)
        |
        v
+--------------------------------------+
|  STEP 1: DB2 PRECOMPILE  (DSNHPC)   |
|  - Reads EXEC SQL...END-EXEC blocks  |
|  - Replaces them with COBOL CALLs   |
|  - Outputs modified COBOL source    |
|  - Creates DBRM file                |
+----------+---------------------------+
           |                     |
  Modified COBOL             DBRM file
           |                     |
           v                     v
+---------------------+   +----------------------+
|  STEP 2: COBOL      |   |  STEP 4: DB2 BIND    |
|  COMPILE (IGYCRCTL) |   |  (DSN BIND command)  |
|  - Compiles COBOL   |   |  - Reads DBRM        |
|  - Creates Object   |   |  - Creates App Plan  |
|    Module (.OBJ)    |   |    in DB2 catalog    |
+----------+----------+   +----------------------+
           |
           v
+----------------------------------+
|  STEP 3: LINK-EDIT (IEWBLINK)   |
|  - Links Object Module with     |
|    DB2 runtime libraries        |
|  - Creates Load Module          |
|    (executable program)         |
+----------------------------------+
```

### Why is the BIND step needed?

The BIND step tells DB2 how to execute your SQL at runtime. It validates the SQL against
the DB2 catalog and creates an optimized Application Plan stored in the DB2 catalog.
Without a bound plan, the program cannot access DB2 and will fail with an SQL error.

### Program and Plan Name Reference

| Program    | Program Name | Plan Name  |
|------------|-------------|------------|
| EMPINSERT  | EMPINSERT   | EMPINSPLAN |
| EMPLOOKUP  | EMPLOOKUP   | EMPLOKPLAN |
| EMPDISPLAY | EMPDISPLAY  | EMPDSPLN   |
| EMPUPDATE  | EMPUPDATE   | EMPUDPLN   |
| EMPDELETE  | EMPDELETE   | EMPDELPN   |

---

## 9. How to Submit JCL Jobs

### Step 1 — Log In to z/OS via ISPF

Connect using a 3270 terminal emulator such as:
- IBM Personal Communications
- Attachmate Extra!
- Mocha TN3270

### Step 2 — Upload Files to z/OS

| Local Folder | z/OS PDS              | Record Format |
|-------------|------------------------|---------------|
| cobol/      | YOUR.COBOL.SOURCE     | FB, LRECL=80  |
| jcl/        | YOUR.JCL.LIB          | FB, LRECL=80  |
| sql/        | YOUR.SQL.INPUT        | FB, LRECL=80  |

Use your site's FTP or ISPF 3.3 (Move/Copy) to transfer files.

### Step 3 — Edit JCL Placeholders

In ISPF, open each JCL member and replace all YOUR- placeholders with your site values.
See Section 12 for the complete list of placeholders.

### Step 4 — Submit

1. Open the JCL member in the ISPF editor.
2. Type SUB on the command line and press Enter.
3. z/OS responds: JOB JOBNAME(JOBxxxxx) SUBMITTED
4. Note the job number to find the job in SDSF.

---

## 10. How to Check Output Using SDSF

SDSF (System Display and Search Facility) is the z/OS tool for viewing job output.

### Navigate to SDSF

From the ISPF Primary Menu, type =SD and press Enter.

### View Job Status

1. Type ST on the SDSF command line and press Enter.
2. Find your job by name. Status: AC=active, CC=completed, ABEND=failed.

### View Output

1. Type S next to your job name and press Enter.
2. Type S next to SYSPRINT or SYSTSPRT to view COBOL DISPLAY output.
3. Use FIND to search for specific text in the output.

### Common SDSF Commands

| Command     | Description                     |
|-------------|---------------------------------|
| ST          | Show recently completed jobs    |
| I           | Show active/running jobs        |
| H           | Show jobs on hold               |
| S           | Select a job/sysout to view     |
| P           | Purge a job's output            |
| FIND text   | Search within the output        |
| =           | Return to previous panel        |

---

## 11. How to Test Each Functionality

### Phase 1: Database Setup

#### Test 1A — Create the EMPLOYEE Table
1. Edit CREATE_TABLE.sql — replace YOUR-SCHEMA with your DB2 schema.
2. Upload to YOUR.SQL.INPUT(CRTABLE) on z/OS.
3. Submit CRTABLE.jcl.
4. In SDSF, look for DSNT408I SQLCODE = 0 (success).

#### Test 1B — Insert Sample Data
1. Edit INSERT_DATA.sql — replace YOUR-SCHEMA.
2. Upload to YOUR.SQL.INPUT(INSDATA).
3. Copy CRTABLE.jcl, change SYSIN to point to INSDATA, and submit.
4. Look for 5 SQLCODE = 0 messages in SDSF (one per INSERT).

---

### Phase 2: Compile All Programs

Repeat for each of the 5 programs:
1. Upload COBOL source to YOUR.COBOL.SOURCE(programname).
2. Edit COMPILE.jcl with the correct program and plan names (Section 8).
3. Submit COMPILE.jcl.
4. In SDSF, verify all 4 steps show CC 0000.

#### Condition Code Meanings

| Code    | Meaning                               |
|---------|---------------------------------------|
| CC 0000 | Complete success                      |
| CC 0004 | Warnings — usually safe to run        |
| CC 0008 | Errors — fix before running           |
| ABEND   | Abnormal end — serious problem        |

---

### Phase 3: Run Each Program

#### Test 3A — EMPINSERT (Insert Employee)

Submit RUNINSRT.jcl.

Expected SYSPRINT output:
```
=================================
 EMPLOYEE INSERT PROGRAM
=================================
 EMP ID     :       1006
 EMP NAME   : FRANK MILLER
 DEPARTMENT : FINANCE
 SALARY     :      65,000.00
---------------------------------
INSERT SUCCESSFUL - EMPLOYEE RECORD ADDED.
```

Run again with same ID. Expected: ERROR: EMPLOYEE ID ALREADY EXISTS.

---

#### Test 3B — EMPLOOKUP (Search Employee)

The program searches for EMP_ID 1003 by default.
Submit RUNLOOKP.jcl.

Expected SYSPRINT output:
```
=================================
 EMPLOYEE LOOKUP PROGRAM
=================================
 SEARCHING FOR EMP ID:        1003
---------------------------------
EMPLOYEE FOUND:
  EMP ID     :        1003
  EMP NAME   : CAROL WILLIAMS
  DEPARTMENT : HUMAN RESOURCES
  SALARY     :      68,000.00
```

Change WS-SEARCH-ID to 9999, recompile, rerun.
Expected: NO EMPLOYEE FOUND WITH ID: 9999

---

#### Test 3C — EMPDISPLAY (Display All)

Submit RUNDSPLY.jcl.
Expected output: all 5 employees listed in EMP_ID order.
Final line: TOTAL EMPLOYEES:    5

---

#### Test 3D — EMPUPDATE (Update Salary)

The program updates EMP_ID 1002 to salary 88000.00.
Submit RUNUPDAT.jcl.

Expected SYSPRINT output:
```
=================================
 EMPLOYEE SALARY UPDATE PROGRAM
=================================
 UPDATING EMP ID  :        1002
 NEW SALARY       :      88,000.00
---------------------------------
SALARY UPDATED SUCCESSFULLY.
ROWS AFFECTED:          1
```

Run EMPDISPLAY after to confirm BOB SMITH's salary is 88,000.00.

---

#### Test 3E — EMPDELETE (Delete Employee)

The program deletes EMP_ID 1006.
Submit RUNDELET.jcl.

Expected SYSPRINT output:
```
=================================
 EMPLOYEE DELETE PROGRAM
=================================
 DELETING EMP ID:        1006
---------------------------------
EMPLOYEE DELETED SUCCESSFULLY.
EMP ID       1006 HAS BEEN REMOVED.
ROWS DELETED:          1
```

Run EMPDISPLAY to confirm EMP_ID 1006 is no longer listed.

---

## 12. Quick Reference — Placeholder Values

Replace every YOUR- value in JCL and SQL files with your site-specific values.
Ask your systems programmer or instructor for these values.

| Placeholder          | Description                                   | Example               |
|----------------------|-----------------------------------------------|-----------------------|
| YOUR-SCHEMA          | DB2 schema (usually your TSO userid)          | KAZIM                 |
| YOUR-USERID          | Your TSO/RACF userid for GRANT statement      | KAZIM01               |
| DB2P                 | Your DB2 subsystem name                       | DB2P or DSN1          |
| YOUR.COBOL.SOURCE    | PDS holding COBOL source members              | KAZIM.COBOL.SRC       |
| YOUR.DBRMLIB.DATA    | PDS for DBRM members (from precompile)        | KAZIM.DBRMLIB         |
| YOUR.LOAD.LIBRARY    | PDS for load modules (from link-edit)         | KAZIM.LOADLIB         |
| YOUR.RUNLIB.LOAD     | DB2 runtime load library                      | DSN.V13.RUNLIB.LOAD   |
| YOUR.DB2.SDSNMACS    | DB2 macro library                             | DSN.V13.SDSNMACS      |
| YOUR.DB2.SDSNLOAD    | DB2 load library for linking                  | DSN.V13.SDSNLOAD      |
| YOUR.COBOL.COPYLIB   | COBOL copy library for COPY members           | KAZIM.COPYLIB         |
| YOUR.SQL.INPUT       | PDS holding SQL scripts                       | KAZIM.SQL.LIB         |
| CLASS=A              | JCL job class (ask your DBA)                  | A, B, or C            |

---

## 13. SQLCODE Reference

| SQLCODE | Meaning                                 | Action                         |
|---------|-----------------------------------------|--------------------------------|
| 0       | SQL executed successfully               | Continue normally              |
| +100    | Row not found (no rows matched WHERE)   | Handle not-found condition     |
| -103    | Invalid literal value in SQL            | Check data types               |
| -117    | Wrong number of VALUES in INSERT        | Match column count to VALUES   |
| -204    | Table not found in DB2 catalog          | Check schema and table name    |
| -305    | NULL returned to NOT NULL host variable | Add null indicators            |
| -407    | Cannot INSERT NULL into NOT NULL column | Ensure all fields are set      |
| -803    | Duplicate primary key on INSERT         | EMP_ID already exists          |
| -904    | Resource unavailable                    | Contact your DBA               |
| -911    | Deadlock or timeout; rollback occurred  | Retry the transaction          |

---

*End of README*
*Employee Management System — IBM Mainframe Project*
*COBOL + DB2 + SQL + JCL | Beginner Level*
