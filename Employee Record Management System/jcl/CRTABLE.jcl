//***********************************************************************
//* PROJECT  : Employee Management System
//* JCL      : CRTABLE.jcl
//* PURPOSE  : Run SQL to create the EMPLOYEE table using SPUFI (batch)
//*
//* WHAT IS JCL?
//*   JCL (Job Control Language) tells z/OS how to run a program.
//*   Every JCL job has three types of statements:
//*     JOB   : Identifies the job and billing information.
//*     EXEC  : Names the program or cataloged procedure to run.
//*     DD    : Defines datasets (files) used by the program.
//*
//* HOW TO SUBMIT:
//*   1. Upload this JCL to a PDS member on z/OS.
//*   2. Edit all placeholders marked with YOUR- to your site values.
//*   3. Place the SQL from CREATE_TABLE.sql into YOUR.SQL.INPUT dataset.
//*   4. Place this JCL in your ISPF editor and type SUB on the command.
//***********************************************************************

//***********************************************************************
//* JOB STATEMENT
//*   CRTABLE  = Job name (max 8 characters, no spaces).
//*   CLASS=A  = Job class (ask your systems programmer for the right
//*              class at your installation).
//*   MSGCLASS = Where to send job messages (usually A or X).
//*   NOTIFY   = Your TSO userid to receive job completion notifications.
//***********************************************************************
//CRTABLE  JOB CLASS=A,
//             MSGCLASS=X,
//             NOTIFY=&SYSUID,
//             MSGLEVEL=(1,1)

//***********************************************************************
//* EXEC STATEMENT - Runs the IKJEFT01 TSO batch program.
//*   IKJEFT01 is IBM's TSO-in-batch program used to run SPUFI SQL.
//*   PARM='DSN' invokes the DB2 Interactive (DSN) command processor.
//***********************************************************************
//STEP010  EXEC PGM=IKJEFT01,DYNAMNBR=20

//***********************************************************************
//* DD STATEMENTS
//*
//* DBRMLIB  : Library where compiled DBRM (Database Request Module)
//*            members are stored. Required for DB2 batch jobs.
//*
//* SYSTSPRT : Output dataset for TSO messages.
//*
//* SYSPRINT : Output for SQL results and messages.
//*
//* SYSTSIN  : Inline TSO/DB2 commands.
//*   DSN SYSTEM(DB2P) - Connect to DB2 subsystem named DB2P.
//*                      Replace DB2P with your actual DB2 subsystem.
//*   RUN PROGRAM(DSNTIA12) - Runs the IBM SQL batch utility.
//*   END - Terminates the DSN session.
//***********************************************************************
//DBRMLIB  DD DSN=YOUR.DBRMLIB.DATA,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*

//SYSTSIN  DD *
  DSN SYSTEM(DB2P)
  RUN PROGRAM(DSNTIA12) PLAN(DSNTIA12) -
      LIB('YOUR.RUNLIB.LOAD')
  END
/*

//***********************************************************************
//* SYSIN: The SQL statements to execute.
//*   Point this DD to the dataset containing your CREATE TABLE SQL,
//*   OR paste the SQL inline between /* and */ markers.
//*   Replace YOUR.SQL.INPUT with your actual dataset name.
//***********************************************************************
//SYSIN    DD DSN=YOUR.SQL.INPUT(CRTABLE),DISP=SHR
