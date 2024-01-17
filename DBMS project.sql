create database dbms;
use dbms;
show databases;

create table backend_staff(
staff_id varchar(7) primary key,
start_date date not null,
salary numeric(10) not null,
dept varchar(15) not null,
phone numeric(10) not null,
email varchar(50) not null,
staff_name varchar(50) not null
);
desc backend_staff;

create table phone_num (
phone_num numeric (10) primary key,
staff_id varchar(7),
foreign key (staff_id) references backend_staff (staff_id)
);
desc phone_num;

create table programs(
month1 varchar(3) not null,
month2 varchar(3) not null,
month3 varchar(3) not null,
program_cost numeric(10) not null,
install1 numeric(5) not null,
install2 numeric(5),
program_code varchar(7) primary key
);
desc programs;

CREATE TABLE Patient(
patient_id NUMERIC PRIMARY KEY,
patient_name VARCHAR(35) NOT NULL,
dob DATE NOT NULL,
sex VARCHAR(20) NOT NULL,
address VARCHAR(100) NOT NULL,
doc_referral VARCHAR(35),
patient_status VARCHAR(35) NOT NULL,
total_duration NUMERIC(3) NOT NULL,
program_code varchar(7),
FOREIGN KEY(program_code) REFERENCES Programs(program_code)
); 
desc patient;

CREATE TABLE PARENTS(
parent_id NUMERIC not null,
patient_id NUMERIC NOT NULL,
FOREIGN KEY(patient_id) REFERENCES Patient(patient_id),
parent_name VARCHAR(35) NOT NULL,
parent_phone_no NUMERIC(9) NOT NULL,
email VARCHAR(35) NOT NULL,
staff_id varchar(7) NOT NULL, 
FOREIGN KEY(staff_id) REFERENCES backend_staff(staff_id),
payment NUMERIC(6) NOT NULL,
primary key(parent_id,patient_id)
);
desc parents;

create table Branches(
branch_name varchar(10) primary key,
target_no_of_patient numeric,
max_patient numeric,
address varchar(50) not null);
desc branches;

create table Tests(
test_id numeric(10) not null primary key,
test_name varchar(15) not null,
diagnosis_type varchar(10),
cost numeric(10) not null);
desc Tests;

create table takes(
test_id numeric(10) not null,
FOREIGN KEY(test_id) REFERENCES Tests(test_id),
patient_id NUMERIC NOT NULL,
FOREIGN KEY(patient_id) REFERENCES Patient(patient_id),
date_of_test date not null,
no_of_tests numeric(2)  not null,
primary key(test_id,patient_id)
);
desc takes;

CREATE TABLE doctors (
doc_id varchar(4) primary key,
qualification varchar(20) not null,
yoe numeric (2) not null,
salary_amount numeric (6) not null,
contact_no numeric (10),
staff_id varchar(7) NOT NULL, 
doc_email varchar(20),
FOREIGN KEY(staff_id) REFERENCES backend_staff(staff_id),
INDEX idx_doc_id (doc_id),
INDEX idx_qualification (qualification),
INDEX idx_doc_email (doc_email),
INDEX idx_yoe (yoe),
INDEX idx_salary_amount (salary_amount),
INDEX idx_contact_no (contact_no)
);
desc doctors;

create table senior_doctor (
doc_id varchar(4) primary key,
foreign key(doc_id) references doctors(doc_id),
cost numeric (6) not null,
qualification varchar(20) not null,
foreign key(qualification) references doctors(qualification),
yoe numeric (2) not null,
foreign key(yoe) references doctors(yoe),
doc_email varchar(20),
foreign key(doc_email) references doctors(doc_email),
salary_amount numeric (6) not null,
foreign key(salary_amount) references doctors(salary_amount),
contact_no numeric (10),
foreign key(contact_no) references doctors(contact_no)
);
desc senior_doctor;

create table junior_doctor(
doc_id varchar(4) primary key,
foreign key(doc_id) references doctors(doc_id),
target numeric(5) not null,
cost_per_session numeric (6) not null,
department varchar(35) not null,
qualification varchar(20) not null,
foreign key(qualification) references doctors(qualification),
yoe numeric (2) not null,
foreign key(yoe) references doctors(yoe),
doc_email varchar(20),
foreign key(doc_email) references doctors(doc_email),
contact_no numeric (10),
foreign key(contact_no) references doctors(contact_no)
);
desc junior_doctor;

create table Consults(
patient_id NUMERIC NOT NULL,
FOREIGN KEY(patient_id) REFERENCES Patient(patient_id),
doc_id varchar(4) not null,
FOREIGN KEY(doc_id) REFERENCES doctors(doc_id),
type_of_treatment varchar(50) not null,
no_of_sessions numeric(2)  not null,
primary key(patient_id,doc_id));
desc Consults;

create table visits(
doc_id varchar(4) not null,
branch_name varchar(10) not null,
no_of_patients numeric (3) not null,
foreign key (doc_id) references doctors (doc_id),
foreign key (branch_name) references Branches (branch_name),  
primary key( doc_id, branch_name)
);
desc visits;
