//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : RUNUPDAT.jcl
//* PURPOSE  : Execute EMPUPDATE - Update an employee salary
//*
//* PREREQUISITES:
//*   1. EMPLOYEE table must exist and have data.
//*   2. EMPUPDATE must be compiled and bound (use plan EMPUDPLN).
//***********************************************************************

//RUNUPDAT JOB CLASS=A,
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
  RUN PROGRAM(EMPUPDATE) PLAN(EMPUDPLN) -
      LIB('YOUR.RUNLIB.LOAD')
  END
/*
