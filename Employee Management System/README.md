# Employee Management System (COBOL)

A beginner-friendly, menu-driven Employee Management System written in COBOL.

## Features
- Add an employee
- Display all employees
- Search for an employee by ID
- Exit the application

## Project structure
```text
Employee Management System/
├── src/
│   └── EMPLOYEE.cbl
├── jcl/
│   ├── COMPILE.jcl
│   └── RUN.jcl
└── README.md
```

## Concepts covered
- COBOL program structure
- Working-Storage variables and tables
- ACCEPT and DISPLAY
- IF / EVALUATE
- PERFORM loops and paragraphs
- Basic employee data management using an in-memory table

## Build and execution
1. Upload `src/EMPLOYEE.cbl` to your mainframe COBOL source library as member `EMPLOYEE`.
2. Edit `jcl/COMPILE.jcl`. Replace `YOUR.COMPILER.LOADLIB`, `YOUR.SOURCE`, and `YOUR.LOADLIB` with dataset names from your mainframe environment.
3. Submit `COMPILE.jcl`. Check the job output and confirm the compile and link-edit steps complete successfully.
4. Edit `jcl/RUN.jcl` with your load library name and submit it to run the program.

> JCL dataset names, compiler load libraries, and runtime library requirements vary by mainframe installation. The supplied JCL is a template and may need site-specific adjustments.

## Current limitation
Employee records are kept only in an in-memory table of up to 50 entries. They are lost when the program ends. Persistent storage can be added later using sequential files or VSAM.
