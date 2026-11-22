//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : COMPILE.jcl
//* PURPOSE  : Compile, Link-Edit, and Bind a COBOL-DB2 program
//*
//* THE 4-STEP BUILD PROCESS FOR COBOL-DB2 PROGRAMS:
//*
//* STEP 1 - DB2 PRECOMPILE (DSNHPC):
//*   The DB2 precompiler reads your COBOL source containing EXEC SQL
//*   blocks. It does two things:
//*   a) Replaces every EXEC SQL...END-EXEC block with COBOL CALL
//*      statements that the standard COBOL compiler can understand.
//*   b) Creates a DBRM (Database Request Module) that contains the
//*      extracted SQL statements. The DBRM is used in the BIND step.
//*
//* STEP 2 - COBOL COMPILE (IGYCRCTL):
//*   The IBM Enterprise COBOL compiler compiles the modified source
//*   (output from the precompiler) into an object module (.OBJ).
//*
//* STEP 3 - LINK-EDIT (IEWBLINK):
//*   The linkage editor combines the object module with DB2 runtime
//*   stubs and other required libraries to produce a load module
//*   (executable program) stored in a load library.
//*
//* STEP 4 - DB2 BIND (IKJEFT01 + DSN BIND):
//*   The BIND step takes the DBRM from Step 1 and creates an
//*   Application Plan in DB2. The plan is what DB2 uses at runtime
//*   to know how to execute your SQL. Without a bound plan, the
//*   program cannot access DB2.
//*
//* CHANGE: Replace EMPINSERT below with EMPLOOKUP, EMPDISPLAY,
//*         EMPUPDATE, or EMPDELETE to compile other programs.
//***********************************************************************

//CBLCOMP  JOB CLASS=A,
//             MSGCLASS=X,
//             NOTIFY=&SYSUID,
//             MSGLEVEL=(1,1)

//***********************************************************************
//* STEP 1: DB2 PRECOMPILE
//*   PGM=DSNHPC     : IBM DB2 precompiler program name.
//*   PARM='HOST(COB)': Tells precompiler the source language is COBOL.
//***********************************************************************
//STEP010  EXEC PGM=DSNHPC,
//             PARM='HOST(COB),APOST'

//* DBRMLIB: Where to store the generated DBRM member.
//DBRMLIB  DD DSN=YOUR.DBRMLIB.DATA(EMPINSERT),DISP=SHR

//* SYSCIN : Temporary dataset holding modified COBOL source (output).
//SYSCIN   DD DSN=&&MODSRC,DISP=(NEW,PASS),
//            UNIT=SYSDA,SPACE=(CYL,(1,1))

//* SYSIN  : Your original COBOL source with embedded SQL.
//SYSIN    DD DSN=YOUR.COBOL.SOURCE(EMPINSERT),DISP=SHR

//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//***********************************************************************
//* STEP 2: COBOL COMPILE
//*   PGM=IGYCRCTL  : IBM Enterprise COBOL compiler.
//*   PARM options:
//*     OBJECT   - Generate object module.
//*     NOLIST   - Suppress compiler listing (use LIST for debugging).
//*     RENT     - Generate reentrant code (required for most sites).
//***********************************************************************
//STEP020  EXEC PGM=IGYCRCTL,
//             PARM='OBJECT,NOLIST,RENT',
//             COND=(4,LT,STEP010)

//* SYSLIB : COBOL copy libraries (where COPYBOOKS are searched).
//SYSLIB   DD DSN=YOUR.COBOL.COPYLIB,DISP=SHR
//         DD DSN=YOUR.DB2.SDSNMACS,DISP=SHR

//* SYSIN  : Modified COBOL source passed from precompiler (STEP010).
//SYSIN    DD DSN=&&MODSRC,DISP=(OLD,DELETE)

//* SYSLIN : Object module output (passed to link-edit in STEP030).
//SYSLIN   DD DSN=&&OBJMOD,DISP=(NEW,PASS),
//            UNIT=SYSDA,SPACE=(CYL,(1,1))

//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//***********************************************************************
//* STEP 3: LINK-EDIT
//*   PGM=IEWBLINK : IBM Binder/Linkage editor.
//*   Creates the executable load module in the load library.
//***********************************************************************
//STEP030  EXEC PGM=IEWBLINK,
//             PARM='LIST,LET,XREF',
//             COND=(4,LT,STEP020)

//* SYSLIB : DB2 runtime libraries and system libraries.
//SYSLIB   DD DSN=YOUR.DB2.SDSNLOAD,DISP=SHR
//         DD DSN=SYS1.CSSLIB,DISP=SHR

//* SYSLMOD: Output load library where the executable is stored.
//SYSLMOD  DD DSN=YOUR.LOAD.LIBRARY(EMPINSERT),DISP=SHR

//* SYSLIN : Object module from STEP020.
//SYSLIN   DD DSN=&&OBJMOD,DISP=(OLD,DELETE)
//         DD DDNAME=SYSIN

//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//***********************************************************************
//* STEP 4: DB2 BIND
//*   The BIND command reads the DBRM (from STEP010) and creates or
//*   replaces the Application Plan in the DB2 catalog.
//*
//*   BIND PLAN(EMPINSPLAN) - Creates plan named EMPINSPLAN.
//*   MEMBER(EMPINSERT)     - Uses the DBRM named EMPINSERT.
//*   ACTION(REPLACE)       - Replaces the plan if it already exists.
//*   ISOLATION(CS)         - Cursor Stability concurrency control.
//***********************************************************************
//STEP040  EXEC PGM=IKJEFT01,
//             DYNAMNBR=20,
//             COND=(4,LT,STEP030)

//DBRMLIB  DD DSN=YOUR.DBRMLIB.DATA,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//SYSTSIN  DD *
  DSN SYSTEM(DB2P)
  BIND PLAN(EMPINSPLAN) MEMBER(EMPINSERT) -
       ACTION(REPLACE) ISOLATION(CS) VALIDATE(BIND)
  END
/*
