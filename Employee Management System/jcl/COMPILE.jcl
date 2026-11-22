//EMPCOMP  JOB (ACCT),'EMP COMPILE',CLASS=A,MSGCLASS=X,
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID
//* --------------------------------------------------
//* Replace the example dataset names with your own.
//* --------------------------------------------------
//COBOL    EXEC IGYCRCTL
//SYSIN    DD DSN=YOUR.SOURCE(EMPLOYEE),DISP=SHR
//SYSLIN   DD DSN=YOUR.OBJ(EMPLOYEE),DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//* Link-edit step depends on your site's procedures
//* and compiler/runtime configuration.
