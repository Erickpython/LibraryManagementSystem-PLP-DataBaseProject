# 📘 Library Database Management System

## 📌 Project Overview

This project is a **Relational Database Management System (RDBMS)** built using **MySQL**.
The system models a **Library Management System** with the ability to track:

* Books
* Borrowers (Students and Teachers)
* Library Staff
* Borrow Records
* Fines for late returns

The goal of this project is to demonstrate understanding of:

* Database design principles
* Relationships (One-to-One, One-to-Many, Many-to-Many)
* Use of constraints (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`)

---

## 🎯 Objectives

* Design and implement a normalized relational database.
* Apply database constraints to ensure data integrity.
* Demonstrate relationships between entities in a real-world scenario.
* Provide practice data for testing queries.

---

## 🏗️ Database Schema

### Entities and Relationships

* **Books** → can be borrowed by many members.
* **Students & Teachers** → separate tables for different borrower categories.
* **Staff** → responsible for handling borrow and return transactions.
* **BorrowRecords** → junction table linking Books, Borrowers, and Staff.
* **Fines** → linked to BorrowRecords to track penalties for late returns.

### Relationships

* `Books (1) ↔ (M) BorrowRecords`
* `Students (1) ↔ (M) BorrowRecords`
* `Teachers (1) ↔ (M) BorrowRecords`
* `Staff (1) ↔ (M) BorrowRecords`
* `BorrowRecords (1) ↔ (1) Fines`

---

## 🔗 Entity Relationship Diagram (ERD)

```
+-----------------+       +------------------+       +------------------+
|     Students    |       |     Teachers     |       |      Staff       |
|-----------------|       |------------------|       |------------------|
| student_id (PK) |       | teacher_id (PK)  |       | staff_id (PK)    |
| name            |       | name             |       | name             |
| email (U)       |       | email (U)        |       | email (U)        |
| phone           |       | phone            |       | role             |
| grade_level     |       | department       |                          |
+-----------------+       +------------------+       +------------------+
         \                        /                          |
          \                      /                           |
           \                    /                            |
            \                  /                             |
             \                /                              |
              \              /                               |
               \            /                                |
                \          /                                 |
                 v        v                                  v
                 +-----------------------------------------------+
                 |                BorrowRecords                  |
                 |-----------------------------------------------|
                 | borrow_id (PK)                                |
                 | book_id (FK → Books.book_id)                  |
                 | borrower_type ('Student' / 'Teacher')         |
                 | borrower_id (FK → Students/Teachers)          |
                 | staff_id (FK → Staff.staff_id)                |
                 | borrow_date                                   |
                 | return_date                                   |
                 +-----------------------------------------------+
                                  |
                                  |
                                  v
                          +---------------+
                          |     Fines     |
                          |---------------|
                          | fine_id (PK)  |
                          | borrow_id (FK)|
                          | amount        |
                          | paid (BOOL)   |
                          +---------------+

+------------------+
|      Books       |
|------------------|
| book_id (PK)     |
| title            |
| author           |
| isbn (U)         |
| published_year   |
| category         |
+------------------+
```

---

## 🗂️ Database Structure

### Tables

1. **Books** – stores book details.
2. **Students** – student borrowers.
3. **Teachers** – teacher borrowers.
4. **Staff** – library staff members.
5. **BorrowRecords** – transaction history of borrowed books.
6. **Fines** – penalties for late returns.

---

## 💻 Installation & Setup

### 1. Create Database

```sql
CREATE DATABASE LibraryDB;
USE LibraryDB;
```

### 2. Run the Schema

Execute the `library_db.sql` file in MySQL:

```bash
mysql -u root -p LibraryDB < library_db.sql
```

### 3. Insert Practice Data

Run the provided `INSERT` statements to populate sample records.

---

## 📊 Sample Queries

### 1. List all borrowed books with borrower details

```sql
SELECT b.title, br.borrow_date, br.return_date, br.borrower_type, 
       CASE 
         WHEN br.borrower_type = 'Student' THEN (SELECT name FROM Students WHERE student_id = br.borrower_id)
         WHEN br.borrower_type = 'Teacher' THEN (SELECT name FROM Teachers WHERE teacher_id = br.borrower_id)
       END AS borrower_name,
       s.name AS staff_name
FROM BorrowRecords br
JOIN Books b ON br.book_id = b.book_id
JOIN Staff s ON br.staff_id = s.staff_id;
```

### 2. List all fines with borrower details

```sql
SELECT f.fine_id, f.amount, f.paid, 
       br.borrower_type, br.borrow_id, b.title
FROM Fines f
JOIN BorrowRecords br ON f.borrow_id = br.borrow_id
JOIN Books b ON br.book_id = b.book_id;
```

---

## 📂 Deliverables

* `library_db.sql` → Contains database schema and constraints.
* `README.md` → Documentation for setup and usage.

---

## ✅ Key Features

* Separate borrower categories (Students and Teachers).
* Staff involvement in transaction handling.
* Fine management for overdue books.
* Sample data for testing and demonstration.
* ERD diagram for clear visualization.

---

## 👨‍💻 Author

**Erick Wambugu**
Teach for Kenya Fellow | Meteorology Graduate | AI For Software Developer

---
