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
│   └── COMPILE.jcl
└── README.md
```

## Concepts covered
- COBOL program structure
- Working-Storage variables
- ACCEPT and DISPLAY
- IF / EVALUATE
- PERFORM loops and paragraphs
- Basic employee data management using in-memory tables

## Execution
1. Upload `src/EMPLOYEE.cbl` to your mainframe source library.
2. Edit `jcl/COMPILE.jcl` and replace the example dataset names with your own COBOL source, load, and job libraries.
3. Submit the JCL to compile and link-edit the program.
4. Run the load module using an execution JCL appropriate for your site's COBOL compiler and runtime libraries.

> This starter version stores employee records in memory only. Records are not retained after the program ends. Persistent storage can be added later using sequential files or VSAM.
