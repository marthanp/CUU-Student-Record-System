-- ==========================================================
-- University Student Records Management System (USRMS)
-- Target Database: MySQL
-- Author: Antigravity (SDLC Phase: Design & Implementation)
-- ==========================================================

-- 1. Create Tables
-- Entity: Users (Handles Authentication and Authorization)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- In production, use bcrypt hashes
    role ENUM('Admin', 'Registry', 'Finance', 'Lecturer', 'Student') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Entity: Students (Profile information)
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reg_number VARCHAR(20) NOT NULL UNIQUE,
    department VARCHAR(100),
    program VARCHAR(100),
    year_of_study INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Entity: Courses
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3
);

-- Entity: Enrollments (Matches students to courses)
CREATE TABLE IF NOT EXISTS enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(10),
    academic_year VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Entity: Fees (Financial Management)
CREATE TABLE IF NOT EXISTS fees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    total_due DECIMAL(10, 2) DEFAULT 0.00,
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    balance DECIMAL(10, 2) GENERATED ALWAYS AS (total_due - paid_amount) STORED,
    status ENUM('Paid', 'Partial', 'Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Entity: Marks (Academic Results)
CREATE TABLE IF NOT EXISTS marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    score DECIMAL(5, 2) DEFAULT 0.00,
    recorded_by INT, -- Lecturer User ID
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES users(id)
);

-- 2. Insert Official Data
-- Roles: Admin, Registry, Finance, Lecturer, Student
INSERT INTO users (username, password, role, full_name, email) VALUES
('cuu_admin', 'admin123', 'Admin', 'CUU System Administrator', 'admin@cavendish.ac.ug'),
('ababiku', 'password123', 'Student', 'Ababiku Brenda', 'ababiku@students.cavendish.ac.ug'),
('alimpa', 'password123', 'Student', 'Alimpa Anne Hillary', 'alimpa@students.cavendish.ac.ug'),
('egabo', 'password123', 'Student', 'Egabo Aaron', 'egabo@students.cavendish.ac.ug'),
('faida', 'password123', 'Student', 'Faida Nancy', 'faida@students.cavendish.ac.ug'),
('kirabo', 'password123', 'Student', 'Kirabo Alice', 'kirabo@students.cavendish.ac.ug'),
('muawia', 'password123', 'Student', 'Muawia Mohamed', 'muawia@students.cavendish.ac.ug'),
('natozo', 'password123', 'Student', 'Natozo Patience Martha', 'natozo@students.cavendish.ac.ug'),
('niwasiima', 'password123', 'Student', 'Niwasiima Ashelycole', 'niwasiima@students.cavendish.ac.ug'),
('onyango', 'password123', 'Student', 'Onyango John Steven', 'onyango@students.cavendish.ac.ug'),
('rwothomio', 'password123', 'Student', 'Rwothomio Evans .E.', 'rwothomio@students.cavendish.ac.ug');


-- Insert Students
INSERT INTO students (user_id, reg_number, department, program, year_of_study) VALUES
(2, '273-318', 'Science & Tech', 'BSc. Software Engineering', 2),
(3, '269-896', 'Science & Tech', 'BSc. Information Technology', 1),
(4, '258-154', 'Science & Tech', 'Bachelor of Computer Science', 3),
(5, '230-500', 'Science & Tech', 'BSc. Software Engineering', 2),
(6, '274-961', 'Science & Tech', 'BSc. Data Science', 1),
(7, '229-449', 'Science & Tech', 'BSc. Cyber Security', 2),
(8, '258-901', 'Science & Tech', 'BSc. Software Engineering', 3),
(9, '275-353', 'Business', 'Bachelor of Business Computing', 1),
(10, '270-472', 'Science & Tech', 'BSc. Information Technology', 2),
(11, '275-372', 'Science & Tech', 'BSc. Software Engineering', 3);

-- Fees Logic (Blocked: Aaron [4], Mohamed [7], John Steven [10])
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(1, 2500000.00, 2500000.00, 'Paid'),
(2, 2500000.00, 2500000.00, 'Paid'),
(3, 2500000.00, 1000000.00, 'Partial'), -- Aaron Blocked
(4, 2500000.00, 2500000.00, 'Paid'),
(5, 2500000.00, 2500000.00, 'Paid'),
(6, 2500000.00, 1000000.00, 'Partial'), -- Mohamed Blocked
(7, 2500000.00, 2500000.00, 'Paid'),
(8, 2500000.00, 2500000.00, 'Paid'),
(9, 2500000.00, 1000000.00, 'Partial'), -- John Steven Blocked
(10, 2500000.00, 2500000.00, 'Paid');

-- Insert Courses
INSERT INTO courses (code, name, credits) VALUES
('COM211', 'Object Oriented Programming', 3),
('BIT211', 'Advanced Database Systems', 4),
('BSE212', 'Principles of Software Engineering', 3);
