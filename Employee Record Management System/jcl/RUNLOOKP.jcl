//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : RUNLOOKP.jcl
//* PURPOSE  : Execute EMPLOOKUP - Search for an employee by ID
//*
//* PREREQUISITES:
//*   1. EMPLOYEE table must exist and have data inserted.
//*   2. EMPLOOKUP must be compiled and bound (run COMPILE.jcl with
//*      EMPLOOKUP substituted in - change EMPINSERT to EMPLOOKUP,
//*      EMPINSPLAN to EMPLOKPLAN in COMPILE.jcl).
//***********************************************************************

//RUNLOOKP JOB CLASS=A,
//             MSGCLASS=X,
//             NOTIFY=&SYSUID,
//             MSGLEVEL=(1,1)

//STEP010  EXEC PGM=IKJEFT01,DYNAMNBR=20

//STEPLIB  DD DSN=YOUR.LOAD.LIBRARY,DISP=SHR
//DBRMLIB  DD DSN=YOUR.DBRMLIB.DATA,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//SYSTSIN  DD *
  DSN SYSTEM(DB2P)
  RUN PROGRAM(EMPLOOKUP) PLAN(EMPLOKPLAN) -
      LIB('YOUR.RUNLIB.LOAD')
  END
/*
