//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : RUNDSPLY.jcl
//* PURPOSE  : Execute EMPDISPLAY - Display all employees
//*
//* PREREQUISITES:
//*   1. EMPLOYEE table must exist and have sample data inserted.
//*   2. EMPDISPLAY must be compiled and bound (use plan EMPDSPLN).
//***********************************************************************

//RUNDSPLY JOB CLASS=A,
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
  RUN PROGRAM(EMPDISPLAY) PLAN(EMPDSPLN) -
      LIB('YOUR.RUNLIB.LOAD')
  END
/*
