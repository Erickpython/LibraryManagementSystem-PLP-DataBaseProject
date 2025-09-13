-- Create the database
CREATE DATABASE LibraryDB;

-- Use the database
USE LibraryDB;

-- =======================
-- BOOKS TABLE
-- =======================
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100),
    isbn VARCHAR(20) UNIQUE,
    published_year YEAR,
    category VARCHAR(50)
);

-- =======================
-- STUDENTS TABLE
-- =======================
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    grade_level VARCHAR(20)  -- e.g., Grade 7, Grade 8, etc.
);

-- =======================
-- TEACHERS TABLE
-- =======================
CREATE TABLE Teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    department VARCHAR(50)  -- e.g., English, Science, Math
);

-- =======================
-- STAFF TABLE
-- =======================
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(50)  -- e.g., Librarian, Assistant
);

-- =======================
-- BORROW RECORDS TABLE
-- =======================
CREATE TABLE BorrowRecords (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    borrower_type ENUM('Student', 'Teacher') NOT NULL,
    borrower_id INT NOT NULL,
    staff_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
    -- borrower_id will reference either Students OR Teachers depending on borrower_type
);

-- =======================
-- FINES TABLE
-- =======================
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    borrow_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (borrow_id) REFERENCES BorrowRecords(borrow_id)
);



--  INSERT SAMPLE DATA INTO BOOKS TABLE
INSERT INTO Books (title, author, isbn, published_year, category) VALUES
('Introduction to Python', 'Guido van Rossum', '978-1-23456-789-0', 2010, 'Programming'),
('Meteorology Basics', 'John Smith', '978-1-23456-789-1', 2015, 'Science'),
('Modern Teaching Methods', 'Jane Doe', '978-1-23456-789-2', 2018, 'Education'),
('Data Structures in C', 'Dennis Ritchie', '978-1-23456-789-3', 2008, 'Programming'),
('African Literature', 'Ngugi wa Thiong’o', '978-1-23456-789-4', 2002, 'Literature');


-- INSERT SAMPLE DATA INTO STUDENTS TABLE
INSERT INTO Students (name, email, phone, grade_level) VALUES
('Alice Mwangi', 'alice.mwangi@example.com', '0712345678', 'Grade 7'),
('Brian Otieno', 'brian.otieno@example.com', '0723456789', 'Grade 8'),
('Cynthia Wairimu', 'cynthia.wairimu@example.com', '0734567890', 'Grade 9');


-- INSERT SAMPLE DATA INTO TEACHERS TABLE
INSERT INTO Teachers (name, email, phone, department) VALUES
('Mr Kamau', 'kamau@example.com', '0745678901', 'Mathematics'),
('Ms Achieng', 'achieng@example.com', '0756789012', 'English'),
('Mr Hassan', 'hassan@example.com', '0767890123', 'Science');


-- INSERT SAMPLE DATA INTO STAFF TABLE
INSERT INTO Staff (name, email, role) VALUES
('Grace Wanjiku', 'grace.wanjiku@example.com', 'Librarian'),
('Peter Kariuki', 'peter.kariuki@example.com', 'Assistant Librarian');


-- INSERT SAMPLE DATA INTO BORROW RECORDS TABLE

-- Student Alice borrows "Introduction to Python" handled by Staff Grace
INSERT INTO BorrowRecords (book_id, borrower_type, borrower_id, staff_id, borrow_date, return_date) 
VALUES (1, 'Student', 1, 1, '2025-09-01', '2025-09-10');

-- Teacher Mr. Kamau borrows "Meteorology Basics" handled by Staff Peter
INSERT INTO BorrowRecords (book_id, borrower_type, borrower_id, staff_id, borrow_date, return_date) 
VALUES (2, 'Teacher', 1, 2, '2025-09-02', NULL);

-- Student Brian borrows "African Literature" handled by Grace
INSERT INTO BorrowRecords (book_id, borrower_type, borrower_id, staff_id, borrow_date, return_date) 
VALUES (5, 'Student', 2, 1, '2025-09-05', NULL);


-- INSERT SAMPLE DATA INTO FINES TABLE
-- Fine for Alice (BorrowRecord 1) - book returned late
INSERT INTO Fines (borrow_id, amount, paid) 
VALUES (1, 200.00, FALSE);

-- Fine for Brian (BorrowRecord 3) - still pending return
INSERT INTO Fines (borrow_id, amount, paid) 
VALUES (3, 100.00, FALSE);


--  PRACTISE TIME WITH SOME AWESOME QUERIES

-- List all borrowed books with borrower details
SELECT b.title, br.borrow_date, br.return_date, br.borrower_type, 
       CASE 
         WHEN br.borrower_type = 'Student' THEN (SELECT name FROM Students WHERE student_id = br.borrower_id)
         WHEN br.borrower_type = 'Teacher' THEN (SELECT name FROM Teachers WHERE teacher_id = br.borrower_id)
       END AS borrower_name,
       s.name AS staff_name
FROM BorrowRecords br
JOIN Books b ON br.book_id = b.book_id
JOIN Staff s ON br.staff_id = s.staff_id;

-- List all fines with borrower details
SELECT f.fine_id, f.amount, f.paid, 
       br.borrower_type, br.borrow_id, b.title
FROM Fines f
JOIN BorrowRecords br ON f.borrow_id = br.borrow_id
JOIN Books b ON br.book_id = b.book_id;



