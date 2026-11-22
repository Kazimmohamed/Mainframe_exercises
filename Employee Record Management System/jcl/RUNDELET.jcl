//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : RUNDELET.jcl
//* PURPOSE  : Execute EMPDELETE - Delete an employee record
//*
//* PREREQUISITES:
//*   1. EMPLOYEE table must exist and have data.
//*   2. EMPDELETE must be compiled and bound (use plan EMPDELPN).
//*
//* CAUTION:
//*   Running this job will permanently delete the employee whose
//*   ID is coded in the EMPDELETE COBOL program. Verify the EMP_ID
//*   before submitting, as deleted rows cannot be recovered without
//*   a DB2 point-in-time recovery.
//***********************************************************************

//RUNDELET JOB CLASS=A,
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
  RUN PROGRAM(EMPDELETE) PLAN(EMPDELPN) -
      LIB('YOUR.RUNLIB.LOAD')
  END
/*
