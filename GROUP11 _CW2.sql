-- ENUM setup
CREATE TYPE dep_type AS ENUM ('academic', 'non-academic');

-- COUNTRY Table
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(30) NOT NULL UNIQUE,
    country_code CHAR(2)
);

-- DEPARTMENTS Table
CREATE TABLE departments (
    dep_id SERIAL PRIMARY KEY,
    dep_name VARCHAR(30) NOT NULL UNIQUE,
    dep_type dep_type NOT NULL
);

-- STAFF Table
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    dep_id INT NOT NULL REFERENCES departments(dep_id),
    country_id INT NOT NULL REFERENCES country(country_id),
    staff_name VARCHAR(50) NOT NULL,
    staff_surname VARCHAR(50) NOT NULL,
    staff_address_line_1 VARCHAR(50) NOT NULL,
    staff_address_line_2 VARCHAR(50),
    staff_city VARCHAR(30) NOT NULL,
    staff_postcode CHAR(10) NOT NULL,
    staff_email VARCHAR(150) NOT NULL UNIQUE,
    staff_phone VARCHAR(15) NOT NULL UNIQUE
);

-- ROLES Table
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(30) NOT NULL UNIQUE
);

-- STAFF_ROLES Table
CREATE TABLE staff_roles (
    staff_id INT REFERENCES staff(staff_id) NOT NULL,
    role_id INT REFERENCES roles(role_id) NOT NULL,
    PRIMARY KEY (staff_id, role_id)
);

-- COURSES Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    dep_id INT NOT NULL REFERENCES departments(dep_id),
    course_name VARCHAR(50) NOT NULL UNIQUE,
    course_fees DECIMAL(8, 2) NOT NULL
);

-- SUBJECT Table
CREATE TABLE subject (
    subject_id SERIAL PRIMARY KEY,
    subject_name VARCHAR(50) NOT NULL UNIQUE
);

-- COURSE_SUBJECT Table
CREATE TABLE course_subject (
    course_id INT REFERENCES courses(course_id) NOT NULL,
    subject_id INT REFERENCES subject(subject_id) NOT NULL,
    PRIMARY KEY (course_id, subject_id)
);

-- SESSIONS Table
CREATE TABLE sessions (
    session_id SERIAL PRIMARY KEY,
    subject_id INT REFERENCES subject(subject_id) NOT NULL,
    session_date DATE NOT NULL,
    session_time TIME NOT NULL,
    session_duration INTERVAL NOT NULL CHECK (session_duration >= '50 minutes' AND session_duration <= '2 hours')
);

-- STAFF_SESSIONS Table
CREATE TABLE staff_sessions (
    staff_id INT REFERENCES staff(staff_id) NOT NULL,
    session_id INT REFERENCES sessions(session_id) NOT NULL,
    PRIMARY KEY (staff_id, session_id)
);

-- ENUM setup
CREATE TYPE academic_level AS ENUM ('level_4', 'level_5', 'level_6', 'level_7');

-- STUDENTS Table
CREATE TABLE students (
    stu_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(course_id),
    country_id INT REFERENCES country(country_id),
    academic_level  academic_level NOT NULL CHECK (academic_level IN ('level_4', 'level_5', 'level_6', 'level_7')),
    stu_name VARCHAR(50) NOT NULL,
    stu_surname VARCHAR(50) NOT NULL,
    stu_address_line_1 VARCHAR(50) NOT NULL,
    stu_address_line_2 VARCHAR(50),
    stu_city VARCHAR(30) NOT NULL,
    stu_postcode CHAR(8),
    stu_phone VARCHAR(15) NOT NULL UNIQUE,
    stu_email VARCHAR(150) NOT NULL UNIQUE
);

-- STUDENT_RECORD Table
CREATE TABLE student_record (
    subject_id INT REFERENCES subject(subject_id),
    stu_id INT REFERENCES students(stu_id) NOT NULL,
    submission INT NOT NULL,
    stu_grades DECIMAL(5, 2) NOT NULL CHECK(stu_grades >= 0 AND stu_grades <= 100),
    PRIMARY KEY (subject_id, stu_id, submission)
);

-- STUDENT_SESSIONS Table
CREATE TABLE student_sessions (
    stu_id INT REFERENCES students(stu_id) NOT NULL,
    session_id INT REFERENCES sessions(session_id) NOT NULL,
    session_attendance BOOL NOT NULL,
    PRIMARY KEY (stu_id, session_id)
);

-- PERSONAL_TUTOR Table
CREATE TABLE tutor_meeting (
    meeting_id INT NOT NULL,  
    stu_id INT REFERENCES students(stu_id) NOT NULL,
    staff_id INT REFERENCES staff(staff_id) NOT NULL,
    meeting_date DATE NOT NULL,
    meeting_time TIME NOT NULL,
    PRIMARY KEY (meeting_id, stu_id, staff_id)
);

INSERT INTO country (country_id, country_name, country_code)
VALUES 
    (1, 'United Kingdom', 'UK'),
    (2, 'Latvia', 'LV'),
    (3, 'Cote D Ivoire', 'CI'),
    (4, 'Seychelles', 'SC'),
    (5, 'Thailand', 'TH'),
    (6, 'Venezuela', 'VE');

INSERT INTO departments (dep_id, dep_name, dep_type)
VALUES  
    (1, 'Magic', 'academic'), 
    (2, 'Finance', 'non-academic'), 
    (3, 'Science', 'academic'),
    (4, 'HR', 'non-academic'),
    (5, 'Computer Science', 'academic');

INSERT INTO staff (staff_id, dep_id, country_id, staff_name, staff_surname, staff_address_line_1, staff_address_line_2, staff_city, staff_postcode, staff_email, staff_phone)
VALUES 
(1, 1, 1, 'Val', 'Adamescu', 'Princess Mary Promenade', NULL, 'Portsmouth', 'PO5 6DSD', 'Val.Adamescu@port.ac.u', '+447788354340'),
(2, 1, 3, 'DSD', 'Lab', 'Audley End Rd', 'Suite 9', 'Upper Mentia', 'W1G 9PU', 'database@postgre.sql', '+244 2 844 203'),
(3, 1, 6, 'Mr',  'Bean', 'something something road', 'what even is address 2?', 'City', 'WIP NAE2', 'email@example.com', '+248 2 150 313'),
(4, 2, 2, 'Comma', 'Forgot', '139 High St', 'Flat 99999', 'Evanning', 'KA29 0ED', 'punctuation@sucks.com', '+12 2 160 424'),
(5, 2, 5, 'Meow', 'Meower', '1C Head St', NULL, 'Hutecross', 'BD1 BEH2', 'nyancat@feline.rulz', '+98 2 766 634' ),
(6, 2, 4, 'Archie', 'Owen','8 Union St', NULL, 'Delerridge', 'TN17 4DS', 'archery@ispretty.cool', '+31 2 601 276' ),
(7, 3, 1, 'Adam', 'Edwards', '30a Brook St', NULL, 'Ilkley', 'LS29 8DE', 'brrrrr@gmail.org', '+248 2 687 846'),
(8, 3, 4, 'John', 'Thomas', 'Saffron Rd', 'Apt. 12', 'White Mostable', 'IV22 2LL', 'xbox@gaming.com', '+1 2 636 445'),
(9, 3, 2, 'Craig', 'Price', '4 Mayfield Grove', 'Flat 45', 'Walsore', 'HG1 5HB', 'fisherprice@toys.co.uk', '+44 2 585 750'),
(10, 4, 1, 'Edward', 'Robinson', '5  Castlegate Avenue', NULL, 'Colline', 'YO1 9RN', 'edward@twilight.books', '+12 2 890 767'),
(11, 4, 6, 'Jason', 'Owen', 'Half blood hill', 'Cabin 4', 'Long Island', 'BD14 6AN', 'golden@fleece.hera', '+420 420 420'),
(12, 4, 5, 'Max', 'Medina', '27-28 Woodhouse Rd', NULL, 'Stars Hollow', 'SN15 5DA', 'gilmoregirls@sucks.com', '+31 2 564 242'),
(13, 5, 3, 'Jodie', 'Llyod', 'Finkley Down Farm Park', NULL, 'Cassavale', 'SP11 6NF', 'whyallLloyd@huh.com', '+12 2 545 736'),
(14, 5, 2, 'Bradley', 'James', 'Lady Lawson St', NULL, 'Savourn', 'EH3 9DS', 'jamesbaxter@adventure.time', '+1 505-291-5934'),
(15, 5, 1, 'Suzzane', 'Saunders', 'Coastguard Cottages', NULL, 'District 12', 'SA3 1PR', 'hungergames@rocks.com', '+1 503-760-2898');

INSERT INTO roles (role_id, role_name)
VALUES 
    (1, 'Teacher'),
    (2, 'Server Maitenance'),
    (3, 'Teaching Assistant'),
    (4, 'Head of Department'),
    (5, 'Accountant');

INSERT INTO staff_roles (role_id, staff_id)
VALUES 
    (1, 1),
    (4, 1),
    (1, 2),
    (3, 3),
    (5, 4),
    (5, 5),
    (5, 6),
    (4, 6),
    (1, 7),
    (4, 7),
    (1, 8),
    (3, 9),
    (2, 10),
    (2, 11),
    (4, 11),
    (2, 12),
    (3, 13),
    (1, 14),
    (4, 15),
    (1, 15);

INSERT INTO courses (course_id, dep_id, course_name, course_fees)
VALUES 
    (1, 1, 'Bending', '3500.00'),
    (2, 1, 'Alchemy', '5000.00'),
    (3, 1, 'Spell Casting', '3000.00'),
    (4, 3, 'Astrophysics', '2000.00'),
    (5, 3, 'Chemical engineering', '2000.00'),
    (6, 3, 'Microbiology', '2000.00'),
    (7, 5, 'Cybersecurity', '1900.00'),
    (8, 5, 'Software Engineering', '2000.00'),
    (9, 5, 'Data Analytics', '1900.00'); 


INSERT INTO subject (subject_id, subject_name)
VALUES 
    (1, 'Physics 1'),
    (2, 'Chemistry 1'),
    (3, 'Waterbending'),
    (4, 'Firebending'),
    (5, 'Brewing'),
    (6, 'Nuclear Chemistry'),
    (7, 'Thermodynamics'),
    (8, 'Quantum Mechanics'),
    (9, 'Statistics'),
    (10, 'Data visualization'),
    (11, 'Mathematics 1'),
    (12, 'Earthbending'),
    (13, 'Cryptography'),
    (14, 'Operating Systems'),
    (15, 'Programming'),
    (16, 'Software Engineering Fundamentals'),
    (17, 'Charms and Spells'),
    (18, 'History of Magic'),
    (19, 'Biology 1'),
    (20, 'Micro-organisms');

INSERT INTO course_subject (course_id, subject_id)
VALUES 
    (9, 9),
    (9, 10),
    (9, 11),
    (8, 15),
    (8, 16),
    (7, 13),
    (7, 14),
    (7, 15),
    (6, 19),
    (6, 20),
    (6, 2),
    (5, 1),
    (5, 2),
    (5, 7),
    (4, 7),
    (4, 9),
    (4, 8),
    (4, 6),
    (4, 1),
    (3, 1),
    (3, 17),
    (3, 18),
    (2, 18),
    (2, 5),
    (2, 2),
    (1, 12),
    (1, 4),
    (1, 3);

INSERT INTO sessions (session_id, subject_id, session_date, session_time, session_duration)
VALUES 
    (1, 1, '2024-03-01', '10:00', '50 MINUTES'),
    (2, 2, '2024-03-01', '10:00', '1 HOUR 50 MINUTES'),
    (3, 3, '2024-03-01', '10:00', '50 MINUTES'),
    (4, 10, '2024-03-01', '10:00', '50 MINUTES'),
    (5, 16, '2024-03-01', '10:00', '50 MINUTES'),
    (6, 18, '2024-03-01', '10:00', '50 MINUTES'),
    (7, 4, '2024-03-01', '11:00', '50 MINUTES'),
    (8, 20, '2024-03-01', '11:00', '50 MINUTES'),
    (9, 16, '2024-03-01', '13:00', '50 MINUTES'),
    (10, 7, '2024-03-01', '13:00', '1 HOUR 50 MINUTES'),
    (11, 5, '2024-03-01', '13:00', '50 MINUTES'),
    (12, 17, '2024-03-01', '13:00', '50 MINUTES'),
    (13, 6, '2024-03-01', '15:00', '50 MINUTES'),
    (14, 13, '2024-03-01', '15:00', '50 MINUTES'),
    
    (15, 6, '2024-03-02', '10:00', '50 MINUTES'),
    (16, 17, '2024-03-02', '10:00', '50 MINUTES'),
    (17, 20, '2024-03-02', '10:00', '1 HOUR 50 MINUTES'),
    (18, 5, '2024-03-02', '10:00', '50 MINUTES'),
    (19, 8, '2024-03-02', '10:00', '50 MINUTES'),
    (20, 11, '2024-03-02', '10:00', '50 MINUTES'),
    (21, 9, '2024-03-02', '11:00', '50 MINUTES'),
    (22, 15, '2024-03-02', '11:00', '50 MINUTES'),
    (23, 18, '2024-03-02', '13:00', '50 MINUTES'),
    (24, 10, '2024-03-02', '13:00', '50 MINUTES'),
    (25, 1, '2024-03-02', '13:00', '50 MINUTES'),
    (26, 3, '2024-03-02', '13:00', '50 MINUTES'),
    (27, 2, '2024-03-02', '15:00', '50 MINUTES'),
    (28, 13, '2024-03-02', '15:00', '1 HOUR'),

    (29, 1, '2024-03-03', '10:00', '1 HOUR 50 MINUTES'),
    (30, 2, '2024-03-03', '10:00', '50 MINUTES'),
    (31, 3, '2024-03-03', '10:00', '50 MINUTES'),
    (32, 10, '2024-03-03', '10:00', '50 MINUTES'),
    (33, 16, '2024-03-03', '10:00', '1 HOUR 50 MINUTES'),
    (34, 18, '2024-03-03', '10:00', '50 MINUTES'),
    (35, 4, '2024-03-03', '11:00', '50 MINUTES'),
    (36, 20, '2024-03-03', '11:00', '50 MINUTES'),
    (37, 16, '2024-03-03', '13:00', '50 MINUTES'),
    (38, 7, '2024-03-03', '13:00', '1 HOUR 50 MINUTES'),
    (39, 5, '2024-03-03', '13:00', '50 MINUTES'),
    (40, 17, '2024-03-03', '13:00', '50 MINUTES'),
    (41, 6, '2024-03-03', '15:00', '1 HOUR'),
    (42, 13, '2024-03-03', '15:00', '50 MINUTES');

INSERT INTO staff_sessions (session_id, staff_id)
VALUES 
    (1, 8),
    (2, 9),
    (3, 1),
    (4, 15),
    (5, 14),
    (6, 2),
    (7, 3),
    (8, 7),
    (9, 13),
    (10, 8),
    (11, 2),
    (12, 3),
    (13, 9),
    (14, 14),

    (15, 13),
    (16, 1),
    (17, 7),
    (18, 2),
    (19, 14),
    (20, 8),
    (21, 3),
    (22, 14),
    (23, 3),
    (24, 10),
    (25, 9),
    (26, 3),
    (27, 7),
    (28, 15),

    (29, 8),
    (30, 9),
    (31, 1),
    (32, 15),
    (33, 14),
    (34, 2),
    (35, 3),
    (36, 7),
    (37, 13),
    (38, 8),
    (39, 2),
    (40, 3),
    (41, 9),
    (42, 14);

INSERT INTO students (stu_id, course_id, country_id, academic_level, stu_name, stu_surname, stu_address_line_1, stu_address_line_2, stu_city, stu_postcode, stu_phone, stu_email)
VALUES 
(1, 1, 2, 'level_4', 'Kombo', 'Detective',  'No. 11, Hamster Cage', 'Student Halls', 'Portsmouth', 'HAM STER', '+449030434934', 'dectectivee@rodent.com'), 
(2, 1, 3, 'level_5', 'Willy',  'William', 'Krūmu iela 1', 'Pelču pag.', 'Kuldiga', 'CAT KIT', '+34475837474828', 'willylikeswetfood@cat.com'),
(3, 2, 1, 'level_6', 'What', 'Coursework?',  'Future Buidling of Databases', NULL, 'Portsmouth', 'PO1 DSD', '+314247289991', 'dsdcoursework@dsd.ac.uk'),
(4, 2, 5, 'level_5', 'Rick', 'N Roll', 'NO. 1 Youtube street', NULL, 'New York', 'RA T2', '+66666666666', 'blablablalbla@bla.com'),
(5, 3, 4, 'level_4', 'Tea', 'Addict', 'No 2 Tea gang house', 'Hot choclate street', 'city', 'CHOC TEA', '+165744443333', 'tearocks@gmail.com'),
(6, 3, 6, 'level_4', 'Mia', 'Roberts', '147 North St', 'Flat 1', 'White Mostable', 'G3 7DA', '+12 2 525 345', 'more@emails.aa'),
(7, 4, 1, 'level_5', 'Dominic', 'Elis', '23 Bay St', NULL, 'Lamerville', 'BB1 5NJ', '+44 2 648 534', 'manthis@ispretty.gah'),
(8, 4, 6, 'level_6', 'Darren', 'Anderson', '231 Byres Rd', 'Suite 9', 'Ridena River', 'G12 8UD', '+23 2 703 180', 'person@mailservice.com'),
(9, 5, 5, 'level_6', 'Keely', 'Knight', '6 Church St', NULL, 'Piremont', 'NR18 0PH', '+12 2 191 330', 'keely@yahoo.com'),
(10, 5, 3, 'level_4', 'Stephen', 'Prince', '18 St Helen Rd', 'Apt. 45', 'Merrait', 'SA1 4AP', '+23 2 825 674', 'freshprince@bellair.com'),
(11, 6, 2, 'level_4', 'Lizze', 'Harris', '8-10 Arcade Rd', NULL, 'Grand Evaster', 'BN17 5AP', '+1 2 635 156', 'hariiii@hotmail.com'),
(12, 7, 4, 'level_5', 'Alexander', 'Cooper', '308 North Promenade', 'Flat 4', 'Grand Evaster', 'FY1 2HA', '+31 2 645 562', 'alex@gmail.com'),
(13, 8, 6, 'level_6', 'Sabrina', 'Taylor', '17 Church Rd', 'Suite 24', 'Saugamont', 'SE19 2TF', '+31 2 654 779', 'sabrinatheteenage@witches.com'),
(14, 8, 3, 'level_6', 'Linda', 'Lloyd', '95-97 Dyke Rd', NULL, 'Tannaburn', 'BN1 3JE', '+23 2 634 442', 'lloyds@banking.co.uk'),
(15, 9, 2, 'level_4', 'Samantha', 'Hunter', 'Spiersbridge Rd', 'Apt.2', 'Chapas Grove', 'G46 7SN', '+44 2 798 026', 'thehunt@archives.co.uk'); 

INSERT INTO student_record(subject_id, stu_id, submission, stu_grades)
VALUES
    (9, 15, 1, '69.00'),
    (9, 15, 2, '70.01'),
    (10, 15, 1, '71.00'),
    (11, 15, 1, '82.00'),
    (11, 15, 2, '84.00'),
    (16, 13, 1, '54.00'),
    (16, 13, 2, '67.00'),
    (15, 13, 1, '74.00'),
    (16, 14, 1, '88.00'),
    (16, 14, 2, '84.00'),
    (15, 14, 1, '81.00'),
    (13, 12, 1, '87.00'),
    (14, 12, 1, '84.00'),
    (14, 12, 2, '75.00'),
    (14, 12, 3, '74.00'),
    (20, 11, 1, '65.00'),
    (20, 11, 2, '73.00'),
    (19, 11, 1, '85.00'),
    (7, 9, 1, '85.00'),
    (2, 9, 1, '65.00'),
    (1, 9, 1, '75.00'),
    (7, 10, 1, '75.00'),
    (2, 10, 1, '71.00'),
    (1, 10, 1, '78.00'),
    (4, 1, 1, '70.35'),
    (3, 1, 1, '68.00'),
    (3, 1, 2, '81.56'),
    (4, 2, 1, '50.89'),
    (3, 2, 1, '40.00'),
    (3, 2, 2, '65.05'),
    (5, 3, 1, '84.00'),
    (5, 3, 2, '76.03'),
    (18, 3, 1, '40.00'),
    (5, 4, 1, '56.98'),
    (5, 4, 2, '76.00'),
    (18, 4, 1, '73.00'),
    (18, 5, 1, '88.5'),
    (17, 5, 1, '79.00'),
    (1, 5, 1, '56.00'),
    (18, 6, 1, '58.5'),
    (17, 6, 1, '74.00'),
    (1, 6, 1, '71.00'),
    (6, 7, 1, '64.99'),
    (8, 7, 1, '85.00'),
    (8, 7, 2, '56.8'),
    (6, 8, 1, '73.99'),
    (8, 8, 1, '51.00'),
    (8, 8, 2, '88.8');

INSERT INTO student_sessions(stu_id, session_id, session_attendance)
VALUES
    (10, 1, 'TRUE'),
    (6, 1, 'TRUE'),
    (9, 1, 'FALSE'),
    (5, 2, 'FALSE'),
    (11, 2, 'TRUE'),
    (1, 3, 'TRUE'),
    (2, 3, 'TRUE'),
    (3, 4, 'TRUE'),
    (4, 4, 'FALSE'),
    (15, 5, 'TRUE'),
    (12, 5, 'TRUE'),
    (8, 6, 'FALSE'),
    (4, 7, 'FALSE'),
    (2, 8, 'TRUE'),
    (1, 8, 'TRUE'),
    (11, 9, 'FALSE'),
    (5, 9, 'TRUE'),
    (7, 9, 'TRUE'),
    (10, 11, 'TRUE'),
    (6, 10, 'FALSE'),
    (5, 11, 'FALSE'),
    (2, 12, 'TRUE'),
    (4, 13, 'TRUE'),
    (14, 13, 'TRUE'),
    (13, 14, 'TRUE'),

    (15, 15, 'FALSE'),
    (13, 15, 'TRUE'),
    (11, 16, 'FALSE'),
    (12, 16, 'TRUE'),
    (7, 17, 'TRUE'),
    (8, 17, 'FALSE'),
    (1, 18, 'TRUE'),
    (4, 18, 'TRUE'),
    (2, 19, 'TRUE'),
    (8, 19, 'FALSE'),
    (10, 20, 'FALSE'),
    (11, 20, 'FALSE'),
    (13, 21, 'TRUE'),
    (15, 21, 'FALSE'),
    (9, 22, 'FALSE'),
    (1, 22, 'TRUE'),
    (3, 23, 'TRUE'),
    (4, 24, 'FALSE'),
    (11, 25, 'TRUE'),
    (15, 25, 'TRUE'),
    (13, 26, 'FALSE'),
    (14, 27, 'TRUE'),
    (1, 27, 'TRUE'),
    (3, 28, 'FALSE'),
    (12, 28, 'TRUE'),
    
    (10, 28, 'FALSE'),
    (6, 28, 'TRUE'),
    (9,29, 'TRUE'),
    (5, 29, 'FALSE'),
    (11, 30, 'TRUE'),
    (1, 31, 'TRUE'),
    (2, 31, 'FALSE'),
    (3, 31, 'TRUE'),
    (4, 32, 'FALSE'),
    (15, 32, 'TRUE'),
    (12, 33, 'TRUE'),
    (8, 33, 'TRUE'),
    (4, 33, 'FALSE'),
    (2, 34, 'TRUE'),
    (1, 34, 'FALSE'),
    (11, 35, 'FALSE'),
    (5, 35, 'TRUE'),
    (7, 36, 'TRUE'),
    (10, 37, 'TRUE'),
    (6, 38, 'FALSE'),
    (5, 39, 'FALSE'),
    (2, 39, 'TRUE'),
    (4, 40, 'FALSE'),
    (14, 41, 'TRUE'),
    (13, 42, 'TRUE');


INSERT INTO tutor_meeting(meeting_id, stu_id, staff_id, meeting_date, meeting_time)
VALUES --no 2/5
    (1, 1, 1, '2024-03-04', '12:00'),
    (2, 3, 1, '2024-03-11', '14:00'),
    (3, 6, 2, '2024-03-04', '13:00'),
    (4, 9, 2, '2024-03-9', '15:00'),
    (5, 4, 6, '2024-03-04', '10:00'),
    (6, 11, 7, '2024-03-05', '13:00'),
    (7, 12, 7, '2024-03-15', '16:00'),
    (8, 15, 8, '2024-03-04', '12:00'),
    (9, 5, 6, '2024-03-22', '11:00'),
    (10, 6, 2, '2024-03-24', '13:00'),
    (11, 1, 1, '2024-03-14', '12:00'),
    (12, 3, 1, '2024-03-14', '14:00'),
    (13, 11, 7, '2024-03-15', '15:00'),
    (14, 12, 7, '2024-03-15', '11:00'),
    (15, 15, 8, '2024-03-14', '14:00');