DROP SCHEMA IF EXISTS employees CASCADE;
CREATE SCHEMA employees;

CREATE TYPE employees.gender AS ENUM ('M', 'F');

CREATE TABLE employees.employees (
  emp_no int PRIMARY KEY ,
  birth_date date NOT NULL,
  first_name varchar(14) NOT NULL,
  last_name varchar(16) NOT NULL,
  gender employees.gender NOT NULL,
  hire_date date NOT NULL
);

CREATE TABLE employees.departments (
  dept_no char(4) PRIMARY KEY,
  dept_name varchar(40) UNIQUE NOT NULL
);

CREATE TABLE employees.salaries (
  emp_no int NOT NULL,
  salary int NOT NULL,
  from_date date NOT NULL,
  to_date date NOT NULL,
  PRIMARY KEY (emp_no, from_date),
  FOREIGN KEY (emp_no) REFERENCES employees.employees (emp_no) ON DELETE CASCADE
);

CREATE TABLE employees.titles (
  emp_no int NOT NULL,
  title varchar(50) NOT NULL,
  from_date date NOT NULL,
  to_date date DEFAULT NULL,
  PRIMARY KEY (emp_no, title, from_date),
  FOREIGN KEY (emp_no) REFERENCES employees.employees (emp_no) ON DELETE CASCADE
);

CREATE TABLE employees.dept_manager (
  emp_no int NOT NULL,
  dept_no char(4) NOT NULL,
  from_date date NOT NULL,
  to_date date NOT NULL,
  PRIMARY KEY (emp_no, dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees.employees (emp_no) ON DELETE CASCADE,
  FOREIGN KEY (dept_no) REFERENCES employees.departments (dept_no) ON DELETE CASCADE
);

CREATE TABLE employees.dept_emp (
  emp_no int NOT NULL,
  dept_no char(4) NOT NULL,
  from_date date NOT NULL,
  to_date date NOT NULL,
  PRIMARY KEY (emp_no, dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees.employees (emp_no) ON DELETE CASCADE,
  FOREIGN KEY (dept_no) REFERENCES employees.departments (dept_no) ON DELETE CASCADE
);

CREATE VIEW employees.dept_emp_latest_date AS SELECT
  employees.dept_emp.emp_no AS emp_no,
  max(employees.dept_emp.from_date) AS from_date,
  max(employees.dept_emp.to_date) AS to_date
FROM employees.dept_emp GROUP BY employees.dept_emp.emp_no;

CREATE VIEW employees.current_dept_emp AS SELECT
 l.emp_no AS emp_no,
 d.dept_no AS dept_no,
 l.from_date AS from_date,
 l.to_date AS to_date from (
    employees.dept_emp d join employees.dept_emp_latest_date l on(
        d.emp_no = l.emp_no and
        d.from_date = l.from_date and
        l.to_date = d.to_date
    )
);


--- fill data ---

\copy employees.employees    FROM './.data/employees.csv'     WITH CSV
\copy employees.departments  FROM './.data/departments.csv'   WITH CSV
\copy employees.salaries     FROM './.data/salaries.csv'      WITH CSV
\copy employees.titles       FROM './.data/titles.csv'        WITH CSV
\copy employees.dept_manager FROM './.data/dept_manager.csv'  WITH CSV
\copy employees.dept_emp     FROM './.data/dept_emp.csv'      WITH CSV
