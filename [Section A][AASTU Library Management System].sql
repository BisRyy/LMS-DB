DROP DATABASE IF EXISTS LMS;
CREATE DATABASE LMS;
USE LMS;

-- Database table Creation
CREATE TABLE user(
	UserID char(10) PRIMARY KEY,
    Fname varchar(15) NOT NULL,
    Lname varchar(15) NOT NULL,
	Sex varchar(1),
    CHECK (Sex in ('F', 'M')),
    DeptID char(10),
    Email varchar(50) UNIQUE
);

CREATE TABLE book( 
	BookID char(10) PRIMARY KEY,
    Title varchar(100) NOT NULL, 
	Author varchar(50), 
    Pyear int,
    Publisher varchar(50), 
    DeptID char(10), 
    Edition tinyint, 
    CHECK (Edition > 0),
    Sno varchar(5), 
    NoC int , 
    CHECK (NoC >= 0) ); 

CREATE TABLE librarian(
	LibID char(10) PRIMARY KEY,
    Fname varchar(15) NOT NULL,
    Lname varchar(15) NOT NULL,
	Sex varchar(1),
    CHECK (Sex IN ('F', 'M')),
    Email varchar(50) UNIQUE 
);

CREATE TABLE department(
	DeptID char(10) PRIMARY KEY, 
    Dname varchar(50) UNIQUE NOT NULL, 
    Email varchar(50) UNIQUE 
);

CREATE TABLE borrow( BorrowID int AUTO_INCREMENT PRIMARY KEY, UserID char(10), BookID char(10), 
	LibID char(10), Bdate date NOT NULL, Rdate date NOT NULL, Rstatus varchar(15),
	CHECK (Rstatus IN ('Lent', 'Returned')), CHECK (Rdate > Bdate),
    FOREIGN KEY(UserID) REFERENCES user(UserID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY(BookID) REFERENCES book(BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(LibID) REFERENCES librarian(LibID) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE book 
ADD FOREIGN KEY(DeptID) 
REFERENCES department(DeptID) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE user 
ADD FOREIGN KEY(DeptID) 
REFERENCES department(DeptID) 
ON DELETE SET NULL ON UPDATE CASCADE;

-- Sample data entry to tables
INSERT INTO department VALUES ('D00', 'Freshman', NULL),
('D01', 'Software Engineering', 'sweg@aastu.edu.et'), ('D02', 'Electrical Engineering', 'ele@aastu.edu.et'),
('D03', 'Mechanical Engineering', 'mec@aastu.edu.et'), ('D04', 'Architecture', 'arch@aastu.edu.et'),
('D05', 'Chemical Engineering', 'chem@aastu.edu.et'), ('D06', 'Civil Engineering', 'civil@aastu.edu.et');

INSERT INTO user VALUES
('ETS0306/13', 'Bisrat', 'Kebere','M', 'D01', 'bisrat.kebere@aastustudent.edu.et'),
('ETS0309/13', 'Biyaol', 'Mesay','M', 'D03', 'biyaol.mesay@aastustudent.edu.et'),
('ETS0152/13', 'Ararsa', 'Dereje','M', 'D02', 'ararsa.dereje@aastustudent.edu.et'),
('ETS0333/13', 'Dagim', 'Tezerawork','M', 'D04', 'dagim.tezerawork@aastustudent.edu.et'),
('ETS0290/13', 'Biruk', 'Mesfin','M', 'D01', 'biruk.mesfin@aastustudent.edu.et'),
('ETS0279/13', 'Birhanu', 'Worku','M', 'D01', 'birhanu.worku@aastustudent.edu.et'),
('ETS1306/13', 'Yeshi', 'Afewerk','F', 'D05', 'yeshi.afewerk@aastustudent.edu.et');

INSERT INTO book VALUES
('B0001', 'Fundamentals of Database Systems', 'Ramez Elmasri, Shamkant B. Navathe', 2016, 'Pearson Education', 'D01', 7, 'S01', 13),
('B0002', 'Fundamentals of Sustainability in Civil Engineering', 'Andrew Braham', 1977, 'McGraw-Hill Education', 'D06', 2, 'S06', 23),
('B0003', 'Distillation Design', 'Henry Kister',  2000, 'Cengage', 'D05', 3, 'S05', 10),
('B0004', 'Standard Handbook of Machine Design', 'Joseph E. Shigley and Charles R. Mischke', 2017, 'Springer Nature', 'D03', 12, 'S03', 8),
('B0005', 'The Architecture of the City', 'Aldo Rossi', 1999, 'John Wiley & Sons', 'D04', 1, 'S04', 15),
('B0006', 'Clean Code', 'Robert C. Martin', 2012, 'Penguin Random House', 'D01', 5, 'S01', 5);

INSERT INTO librarian VALUES ('L01', 'Aberash', 'Wegayewu', 'M', 'aberash@aastu.edu.et'),
('L02', 'Bereket', 'Dalebo', 'M', 'bekibek13@yahoo.com'),
('L03', 'Gelete', 'Umama', 'F', 'gelete.umama@aastu.edu.et'),
('L04', 'Fatuma', 'Gulilat', 'F', 'fatumaG@gmail.com'), 
('L05', 'Hagos', 'Teklay', 'M', 'hagosteklay4@gmail.com'),
('L06', 'Abdulaziz', 'Mohamed', 'M', 'abdulaziz.mohamed@aastu.edu.et');

INSERT INTO borrow (UserID, BookID, LibID, Bdate, Rdate, Rstatus) 
VALUES ('ETS0306/13', 'B0006', 'L01', '1973-07-22', '1973-07-28', 'Lent'),
	('ETS0309/13', 'B0002', 'L03', '2022-02-22', '2022-03-03', 'Lent'),
	('ETS0279/13', 'B0003', 'L04', '2021-07-12', '2021-07-18', 'Returned'),
	('ETS0309/13', 'B0001', 'L01', '2022-06-20', '2022-07-01', 'Lent'),
	('ETS0152/13', 'B0004', 'L02', '2022-04-10', '2022-04-11', 'Lent'),
	('ETS0152/13', 'B0005', 'L02', '2022-04-10', '2022-04-11', 'Lent');

UPDATE borrow SET Rstatus = 'Returned' WHERE BorrowID = 1 OR BorrowID = 4;

-- Frequently Asked Queries
-- Show list of all users
SELECT * FROM user;

-- Search for a book by title and Department
SELECT *
FROM book
WHERE Title LIKE 'Fundamental%' AND DeptID = 'D06';

-- Search for a book by Author 
SELECT *
FROM book
WHERE Author LIKE '% Elmasri%';

-- Show list of unreturned books with borrower info and book title
SELECT b.UserID 'Student ID', Fname 'First Name', Lname 'Last Name', Dname Department, bo.Title, Bdate 'Borrowed on', Rdate 'Return on', u.Email
FROM borrow as b
join user as u on b.UserID = u.UserID 
join book as bo on bo.BookID = b.BookID
join department as d on d.DeptID = u.DeptID
WHERE Rstatus = 'Lent' ORDER BY Bdate;

-- No of books Borrowed and returned
SELECT count(BorrowID)
FROM borrow
WHERE Rstatus != 'Returned';

-- The Title of the books with more than 10 copies in the library
SELECT Title
FROM book
WHERE NoC > 10;

-- Total number of Book copies in the library
SELECT SUM(NoC)
FROM book;

-- Sample Trigger to decrease the number of copies of a book after a borrow
DROP TRIGGER IF EXISTS modify_book_count; 
DELIMITER $$ 
CREATE TRIGGER modify_book_count 
AFTER INSERT ON borrow 
FOR EACH ROW BEGIN
	UPDATE book as c 
    SET NoC = NoC - 1 
    WHERE c.BookID = NEW.BookID; 
END$$ 
DELIMITER ;

-- Stored Procedure to get 1.all borrows of a user, 2.all borrows of a book, 3.unreturned borrows of a user 4. All unreturned borrows
DROP PROCEDURE IF EXISTS get_query;
DELIMITER $$
CREATE PROCEDURE get_query(c int, search char(10)) 
BEGIN
	IF c = 1 THEN 
		SELECT BorrowID, Fname, BookID, Rstatus 
        FROM user as u 
        JOIN borrow 
			AS b ON b.UserID = u.UserID 
            WHERE b.UserID = search;
	ELSEIF c = 2 THEN 
		SELECT BorrowID, Title, UserID, Rdate, Rstatus 
        FROM book as c 
        JOIN borrow AS b 
			ON b.BookID = c.BookID 
            WHERE b.BookID = search;
	ELSEIF c = 3 THEN 
		SELECT BorrowID, u.UserID, Fname, BookID 
        FROM borrow as b 
        JOIN user AS u 
			ON b.UserID = u.UserID 
            WHERE b.UserID = Search AND Rstatus = 'Lent';
	ELSE 
		SELECT * 
        FROM borrow 
        WHERE Rstatus = 'Lent'; 
END IF; 
END$$
DELIMITER ;

-- Sample queries for stoed procedures
CALL get_query(1, 'ETS0309/13');
CALL get_query(2, 'B0002');
CALL get_query(3, 'ETS0309/13');
CALL get_query(4, NULL);

-- Developers Section A
-- 1	Ararsa Derese		ETS0152/13
-- 2	Birhanu Worku		ETS0279/13
-- 3	Biruk Mesfin 		ETS0290/13
-- 4	Bisrat Kebere 		ETS0306/13
-- 5	Biyaol Mesay 		ETS0309/13
-- 6	Dagim Tezerawork 	ETS0333/13

-- All rights Reserved @ 2022 AASTU