# 🏥 Healthcare Database Normalization & Reporting (PostgreSQL)

## 🏆 SQL Hackathon – Winning Solution

This project presents a complete **end-to-end PostgreSQL solution** for a healthcare dataset, focusing on **database normalization (up to 3NF)** and **analytical reporting queries**.

---

## 📌 Problem Statement

A hospital provided a large, denormalized healthcare dataset containing patient, doctor, and department information.
The objective was to:

1. Normalize the dataset into **Third Normal Form (3NF)**
2. Design relational tables with **Primary Keys (PK)** and **Foreign Keys (FK)**
3. Load and transform data into the normalized schema
4. Generate **insightful analytical reports** for hospital management

---

## 🛠️ Tools & Technologies Used

* **PostgreSQL**
* **pgAdmin 4**
* **SQL (DDL, DML, Joins, Aggregates)**
* CSV Data Import using `\COPY`

---

## 📂 Database Design (3NF)

### 1️⃣ Source Table (Raw Data)

* `hospital_data` (denormalized staging table)

### 2️⃣ Normalized Tables

#### 🔹 Patients

* `patient_id` (PK)
* patient_name
* gender
* date of birth
* address, city, state, zip
* phone number

#### 🔹 Departments

* `department_id` (PK)
* department_name

#### 🔹 Doctors

* `doctor_id` (PK)
* doctor_first_name
* doctor_last_name
* specialty
* `doctor_department_id` (FK → departments)

#### 🔹 Visits

* `visit_id` (PK)
* `patient_id` (FK → patients)
* `doctor_id` (FK → doctors)
* `department_id` (FK → departments)

✔️ The schema eliminates redundancy and satisfies **3NF rules**.

---

## 🔄 Data Transformation & Loading

* Raw CSV data imported into `hospital_data`
* Cleaned and transformed using:

  * `DISTINCT`
  * `JOIN`
  * `TO_DATE()` for date conversion
* Data inserted into normalized tables while maintaining referential integrity

---

## 📊 Reporting & Analytical Queries

### 🔹 Scenario 1: Most Active Departments

* Identifies:

  * Patient with highest number of visits
  * Doctor handling maximum visits
* Uses:

  * `COUNT()`
  * `GROUP BY`
  * `ORDER BY`
  * `UNION ALL`

### 🔹 Scenario 2: Department Activity Analysis

* Finds:

  * Most active department
  * Least active department
* Helps management understand patient flow and workload distribution

---

## ▶️ How to Run This Project

1. Create a PostgreSQL database
2. Execute the SQL script in the following order:

   * Create tables
   * Import CSV data
   * Insert data into normalized tables
   * Run reporting queries
3. View results in pgAdmin Query Tool

---

## 🎯 Key Highlights

* Proper **3NF normalization**
* Clean **relational design**
* Real-world **healthcare analytics use case**
* Interview & resume ready project
* Hackathon **winning solution**

---

## 👤 Author

**Najith Kamal A**
SQL & PostgreSQL Enthusiast

---

## ⭐ Use Case

This project is ideal for:

* SQL Interviews
* Data Analyst portfolios
* Database normalization demonstrations
* Healthcare analytics case studies
