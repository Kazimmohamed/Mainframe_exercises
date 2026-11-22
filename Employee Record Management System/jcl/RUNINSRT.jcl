//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : RUNINSRT.jcl
//* PURPOSE  : Execute EMPINSERT - Insert a new employee into DB2
//*
//* PREREQUISITES:
//*   1. EMPLOYEE table must already be created (run CRTABLE.jcl).
//*   2. EMPINSERT program must be compiled and bound (run COMPILE.jcl
//*      with EMPINSERT substituted in).
//*
//* HOW TO USE:
//*   1. Upload this JCL to a PDS member on z/OS.
//*   2. Edit all YOUR- placeholders with your site-specific values.
//*   3. In ISPF editor, type SUB on the command line and press Enter.
//*   4. Note the job number (e.g., JOB12345) shown after submission.
//*   5. Check output in SDSF: type =SD.ST in ISPF, find your job,
//*      press S to select it and F to view SYSOUT.
//***********************************************************************

//RUNINSRT JOB CLASS=A,
//             MSGCLASS=X,
//             NOTIFY=&SYSUID,
//             MSGLEVEL=(1,1)

//***********************************************************************
//* EXEC STATEMENT
//*   PGM=IKJEFT01   : TSO batch program (required to invoke DB2 programs)
//*   DYNAMNBR=20    : Number of dynamic allocations allowed
//***********************************************************************
//STEP010  EXEC PGM=IKJEFT01,DYNAMNBR=20

//***********************************************************************
//* DD STATEMENTS
//*
//* STEPLIB : Tells z/OS where to find the EMPINSERT load module.
//*           Must point to your load library (output of link-edit).
//*
//* DBRMLIB : Library containing the DBRM for EMPINSERT.
//*           Must match what you used during BIND.
//*
//* SYSPRINT: Where DB2 runtime messages are written.
//*
//* SYSTSPRT: Where TSO messages are written.
//*
//* SYSUDUMP: Where system dump goes if the program abends.
//*
//* SYSTSIN : Inline TSO commands:
//*   DSN SYSTEM(DB2P)             - Start DB2 session for subsystem DB2P
//*   RUN PROGRAM(EMPINSERT)       - Run the EMPINSERT load module
//*   PLAN(EMPINSPLAN)             - Use the bound plan EMPINSPLAN
//*   LIB('YOUR.RUNLIB.LOAD')      - Runtime load library location
//*   END                          - End the DSN session
//***********************************************************************
//STEPLIB  DD DSN=YOUR.LOAD.LIBRARY,DISP=SHR
//DBRMLIB  DD DSN=YOUR.DBRMLIB.DATA,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//SYSTSIN  DD *
  DSN SYSTEM(DB2P)
  RUN PROGRAM(EMPINSERT) PLAN(EMPINSPLAN) -
      LIB('YOUR.RUNLIB.LOAD')
  END
/*
