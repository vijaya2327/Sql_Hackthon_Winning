--Phase 1: Database Design & Normalization
--Problem:Normalize the data into 3NF and create separate tables with proper Primary Keys (PKs) and Foreign Keys (FKs).


CREATE TABLE hospital_data (
    patient_name VARCHAR(200),
    patient_gender VARCHAR(50),
    patient_dob VARCHAR(20),
    patient_address VARCHAR(255),
    patient_city VARCHAR(100),
    patient_state VARCHAR(50),
    patient_zip_code VARCHAR(20),
    patient_phone_number VARCHAR(30),
    doctor_first_name VARCHAR(100),
    doctor_last_name VARCHAR(100),
    doctor_specialty VARCHAR(200),
    doctor_department VARCHAR(20),
    department_name VARCHAR(100)
);


ALTER DATABASE postgres SET datestyle = 'ISO, MDY';

show datestyle;

--IMPORTING DATA HOSPITAL_DATA
\COPY public.hospital_data (patient_name,patient_gender,patient_dob,patient_address,patient_city,patient_state,
patient_zip_code,patient_phone_number,doctor_first_name,doctor_last_name,doctor_specialty,doctor_department,
department_name) FROM 'C:\\Users\\91955\\OneDrive\\Desktop\\srinu\\projects\\large_healthcare_dataset.csv' DELIMITER ','
CSV HEADER  ENCODING 'UTF8' QUOTE '"' ESCAPE '''';


select *from public.hospital_data;
SELECT COUNT(*) FROM public.hospital_data;

--Problem:Now that data insertion
--Task:Write INSERT scripts to transfer data from hospital_data into the normalized tables.


--TABLE IN 3NF
create table patients(
 patient_id SERIAL PRIMARY KEY,
 patient_name  VARCHAR(50) NOT NULL,
 patient_gender  VARCHAR(50) NOT NULL,
 patient_dob DATE,
 patient_address  VARCHAR(100) NOT NULL,
 patient_state VARCHAR(50) NOT NULL,
 patient_city VARCHAR(50) NOT NULL,
 patient_zip_code  VARCHAR(50) NOT NULL,
 patient_phone_number VARCHAR(50) NOT NULL
);

select *from public.patients;
SELECT COUNT(*) FROM public.patients;


--IMPORTING DATA INTO PATINENT TABLE
INSERT INTO patients(patient_name,patient_gender,patient_dob,patient_address,patient_city,patient_state,patient_zip_code,
patient_phone_number) SELECT DISTINCT patient_name,patient_gender,TO_DATE(patient_dob, 'DD-MM-YYYY'),patient_address,
patient_city,patient_state,patient_zip_code,patient_phone_number FROM hospital_data;


--TBALE IN 3NF
create table departments(
    department_id  SERIAL PRIMARY KEY,
	department_name VARCHAR(50) NOT NULL
);

select *from public.departments;
SELECT COUNT(*) FROM public.departments;


--IMPORTING DATA INTO DEPARTMENT TABLE
INSERT INTO departments(department_name) SELECT DISTINCT  department_name FROM hospital_data;

--TABLE IN 3NF
create table Doctors(
   doctor_id SERIAL PRIMARY KEY,
   doctor_first_name VARCHAR(50) NOT NULL,
   doctor_last_name VARCHAR(50) NOT NULL,
   doctor_specialty VARCHAR(50) NOT NULL,
   doctor_department_id INT,
   FOREIGN KEY (doctor_department_id) REFERENCES departments(department_id)
);

select *from public.doctors;
SELECT COUNT(*) FROM public.doctors;


--IMPORTING DATA INTO DOCTORS TABLE
INSERT INTO doctors(doctor_first_name,doctor_last_name,doctor_specialty,doctor_department_id)
SELECT DISTINCT h.doctor_first_name,h.doctor_last_name, h.doctor_specialty,d.department_id
FROM hospital_data h
JOIN departments d
    ON d.department_name = h.department_name;

	
--TABLE IN 3NF 
create table Visits(
 visit_id SERIAL PRIMARY KEY,
 patient_id INT,
 FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
 doctor_id  INT,
 FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
 department_id INT,
 FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

select *from public.Visits;
SELECT COUNT(*) FROM public.Visits;


--IMPORTING DATA INTO VISITS TABLE
INSERT INTO visits (patient_id, doctor_id, department_id) SELECT p.patient_id, d.doctor_id,
dp.department_id
FROM hospital_data h
JOIN patients p
    ON p.patient_name = h.patient_name
JOIN doctors d
    ON d.doctor_first_name = h.doctor_first_name
   AND d.doctor_last_name  = h.doctor_last_name
JOIN departments dp
    ON dp.department_name = h.department_name;


--Phase 3: Reporting / Query Scenarios
--Scenario 1: Most Active Departments by Patient Visits
--Problem:The hospital management wants to know which departments receive the highest number of patient visits, ranked by activity level.
--Task:Find the total number of unique patients per department and rank departments by the number of visits.


(
SELECT 
    p.patient_name,NULL AS doctor_name,
    COUNT(v.visit_id) AS total_visits
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
GROUP BY p.patient_name
ORDER BY total_visits DESC
LIMIT 1
)
UNION ALL
(
SELECT
      d.doctor_first_name || ' ' ||d.doctor_last_name As doctor_name,
	  NULL AS patient_name,
    COUNT(v.Visit_id) AS total_visits
FROM visits v
JOIN doctors d ON v.doctor_id = d.doctor_id
GROUP BY doctor_first_name,doctor_last_name
ORDER BY total_visits DESC
LIMIT 1
);


--Scenario 2: Doctors Handling Above-Average Patients
--Problem:Find doctors who treat more patients than the average doctor in their department.
--Task:Compare each doctor’s patient count with the department’s average.

(
    SELECT 
        dp.department_name AS most_active_department,
        NULL AS least_active_department,
        COUNT(v.visit_id) AS total_visits
    FROM visits v
    JOIN departments dp ON v.department_id = dp.department_id
    GROUP BY dp.department_name
    ORDER BY total_visits DESC
    LIMIT 1
)
UNION ALL
(
    SELECT 
        NULL AS most_active_department,
        dp.department_name AS least_active_department,
        COUNT(v.visit_id) AS total_visits
    FROM visits v
    JOIN departments dp ON v.department_id = dp.department_id
    GROUP BY dp.department_name
    ORDER BY total_visits ASC
    LIMIT 1
);






