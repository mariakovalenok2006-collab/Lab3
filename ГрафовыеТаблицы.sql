USE master;

DROP DATABASE IF EXISTS UniversityGraph;

CREATE DATABASE UniversityGraph;

USE UniversityGraph;


CREATE TABLE Student
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    major NVARCHAR(50) NULL       
) AS NODE;


CREATE TABLE Course
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    credits INT NOT NULL            
) AS NODE;


CREATE TABLE Professor
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    department NVARCHAR(50) NULL    
) AS NODE;

CREATE TABLE EnrolledIn (grade INT) AS EDGE;

CREATE TABLE Teaches (year INT) AS EDGE;

CREATE TABLE Recommends (recommendation_date DATE) AS EDGE;

ALTER TABLE EnrolledIn ADD CONSTRAINT EC_EnrolledIn CONNECTION (Student TO Course);
ALTER TABLE Teaches    ADD CONSTRAINT EC_Teaches    CONNECTION (Professor TO Course);
ALTER TABLE Recommends ADD CONSTRAINT EC_Recommends CONNECTION (Student TO Student);

INSERT INTO Student (id, name, major) VALUES
(1, N'Anna Kuznetsova', N'Programmnaya inzheneriya'),
(2, N'Ivan Petrov', N'Biznes-informatika'),
(3, N'Mariya Sokolova', N'Matematika'),
(4, N'Dmitriy Ivanov', N'Fizika'),
(5, N'Elena Vasileva', N'Khimiya'),
(6, N'Sergey Kozlov', N'Programmnaya inzheneriya'),
(7, N'Olga Novikova', N'Biznes-informatika'),
(8, N'Aleksey Morozov', N'Matematika'),
(9, N'Tatyana Egorova', N'Fizika'),
(10, N'Nikolay Volkov', N'Khimiya');

Select *
FROM Student;

INSERT INTO Course (id, name, credits) VALUES
(1, N'Bazy dannykh', 5),
(2, N'Algoritmy i struktury dannykh', 6),
(3, N'Web-razrabotka', 4),
(4, N'Matematicheskiy analiz', 5),
(5, N'Fizika (mekhanika)', 4),
(6, N'Obshchaya khimiya', 4),
(7, N'Programmirovanie na Python', 5),
(8, N'Menedzhment IT-proektov', 3),
(9, N'Diskretnaya matematika', 5),
(10, N'Iskusstvennyy intellekt', 6);

Select *
FROM Course;

INSERT INTO Professor (id, name, department) VALUES
(1, N'Prof. Andrey Smirnov', N'Informatsionnykh tekhnologiy'),
(2, N'Dots. Elena Orlova', N'Prikladnoy matematiki'),
(3, N'Prof. Viktor Tarasov', N'Fiziki'),
(4, N'Dots. Natalya Belova', N'Khimii'),
(5, N'Prof. Mikhail Lebedev', N'Informatsionnykh tekhnologiy'),
(6, N'St. prep. Irina Krylova', N'Ekonomiki'),
(7, N'Prof. Denis Zakharov', N'Matematiki'),
(8, N'Dots. Svetlana Pavlova', N'Informatsionnykh tekhnologiy'),
(9, N'St. prep. Grigoriy Semenov', N'Fiziki'),
(10, N'Prof. Larisa Tikhonova', N'Khimii');

Select *
FROM Professor;

INSERT INTO EnrolledIn ($from_id, $to_id, grade) VALUES
((SELECT $node_id FROM Student WHERE id = 1), (SELECT $node_id FROM Course WHERE id = 1), 90),
((SELECT $node_id FROM Student WHERE id = 1), (SELECT $node_id FROM Course WHERE id = 2), 85),
((SELECT $node_id FROM Student WHERE id = 2), (SELECT $node_id FROM Course WHERE id = 1), 78),
((SELECT $node_id FROM Student WHERE id = 2), (SELECT $node_id FROM Course WHERE id = 3), 92),
((SELECT $node_id FROM Student WHERE id = 3), (SELECT $node_id FROM Course WHERE id = 4), 88),
((SELECT $node_id FROM Student WHERE id = 4), (SELECT $node_id FROM Course WHERE id = 5), 75),
((SELECT $node_id FROM Student WHERE id = 5), (SELECT $node_id FROM Course WHERE id = 6), 81),
((SELECT $node_id FROM Student WHERE id = 6), (SELECT $node_id FROM Course WHERE id = 1), 95),
((SELECT $node_id FROM Student WHERE id = 6), (SELECT $node_id FROM Course WHERE id = 7), 89),
((SELECT $node_id FROM Student WHERE id = 7), (SELECT $node_id FROM Course WHERE id = 8), 86),
((SELECT $node_id FROM Student WHERE id = 8), (SELECT $node_id FROM Course WHERE id = 4), 77),
((SELECT $node_id FROM Student WHERE id = 8), (SELECT $node_id FROM Course WHERE id = 9), 84),
((SELECT $node_id FROM Student WHERE id = 9), (SELECT $node_id FROM Course WHERE id = 5), 73),
((SELECT $node_id FROM Student WHERE id = 10), (SELECT $node_id FROM Course WHERE id = 6), 91);
INSERT INTO Teaches ($from_id, $to_id, year) VALUES
((SELECT $node_id FROM Professor WHERE id = 1), (SELECT $node_id FROM Course WHERE id = 1), 2024),
((SELECT $node_id FROM Professor WHERE id = 1), (SELECT $node_id FROM Course WHERE id = 7), 2024),
((SELECT $node_id FROM Professor WHERE id = 2), (SELECT $node_id FROM Course WHERE id = 2), 2023),
((SELECT $node_id FROM Professor WHERE id = 2), (SELECT $node_id FROM Course WHERE id = 9), 2024),
((SELECT $node_id FROM Professor WHERE id = 3), (SELECT $node_id FROM Course WHERE id = 5), 2024),
((SELECT $node_id FROM Professor WHERE id = 4), (SELECT $node_id FROM Course WHERE id = 6), 2023),
((SELECT $node_id FROM Professor WHERE id = 5), (SELECT $node_id FROM Course WHERE id = 1), 2023),
((SELECT $node_id FROM Professor WHERE id = 5), (SELECT $node_id FROM Course WHERE id = 10), 2024),
((SELECT $node_id FROM Professor WHERE id = 7), (SELECT $node_id FROM Course WHERE id = 4), 2024),
((SELECT $node_id FROM Professor WHERE id = 8), (SELECT $node_id FROM Course WHERE id = 3), 2024);

INSERT INTO Recommends ($from_id, $to_id, recommendation_date) VALUES
((SELECT $node_id FROM Student WHERE id = 1), (SELECT $node_id FROM Student WHERE id = 2), '2024-05-10'),
((SELECT $node_id FROM Student WHERE id = 6), (SELECT $node_id FROM Student WHERE id = 1), '2024-05-12'),
((SELECT $node_id FROM Student WHERE id = 3), (SELECT $node_id FROM Student WHERE id = 8), '2024-05-15'),
((SELECT $node_id FROM Student WHERE id = 10), (SELECT $node_id FROM Student WHERE id = 5), '2024-05-18'),
((SELECT $node_id FROM Student WHERE id = 2), (SELECT $node_id FROM Student WHERE id = 7), '2024-05-20');

SELECT s.name AS Student, c.name AS Course, e.grade AS Grade
FROM Student AS s, EnrolledIn AS e, Course AS c
WHERE MATCH(s-(e)->c) 
  AND s.name = N'Anna Kuznetsova';
  
SELECT p.name AS Professor, c.name AS Course, s.name AS Student, e.grade AS Grade
FROM Professor AS p, Teaches AS t, Course AS c, EnrolledIn AS e, Student AS s
WHERE MATCH(p-(t)->c<-(e)-s)
  AND p.name = N'Prof. Andrey Smirnov';

SELECT r1.name AS Recommender, r2.name AS Receiver, 
       rec.recommendation_date AS RecommendationDate,
       c.name AS RecommendedCourse
FROM Student AS r1, Recommends AS rec, Student AS r2,
     EnrolledIn AS e, Course AS c
WHERE MATCH(r1-(rec)->r2-(e)->c);

SELECT s.name AS Student, c.name AS Course, p.name AS Professor
FROM Student AS s, EnrolledIn AS e, Course AS c, Teaches AS t, Professor AS p
WHERE MATCH(s-(e)->c<-(t)-p)
  AND p.department LIKE N'%Informatsionnykh tekhnologiy%'

SELECT s.name AS Student, c.name AS Course, e.grade AS Grade, p.name AS Professor
FROM Student AS s, EnrolledIn AS e, Course AS c, Teaches AS t, Professor AS p
WHERE MATCH(s-(e)->c<-(t)-p)
  AND e.grade > 90;

SELECT 
    s1.name AS StartStudent,
    STRING_AGG(s2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS RecommendationPath,
    LAST_VALUE(s2.name) WITHIN GROUP (GRAPH PATH) AS EndStudent
FROM 
    Student AS s1,
    Recommends FOR PATH AS r,
    Student FOR PATH AS s2
WHERE MATCH(SHORTEST_PATH(s1(-(r)->s2)+))
  AND s1.name = N'Anna Kuznetsova';

SELECT 
    s1.name AS StartStudent,
    STRING_AGG(s2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS RecommendationPath,
    LAST_VALUE(s2.name) WITHIN GROUP (GRAPH PATH) AS EndStudent
FROM 
    Student AS s1,
    Recommends FOR PATH AS r,
    Student FOR PATH AS s2
WHERE MATCH(SHORTEST_PATH(s1(-(r)->s2){1,3}))
  AND s1.name = N'Ivan Petrov';


WITH PathCTE AS
(
    SELECT 
        s1.name AS StartNode,
        STRING_AGG(s2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS FullPath,
        LAST_VALUE(s2.name) WITHIN GROUP (GRAPH PATH) AS LastNode
    FROM 
        Student AS s1,
        Recommends FOR PATH AS r,
        Student FOR PATH AS s2
    WHERE MATCH(SHORTEST_PATH(s1(-(r)->s2)+))
      AND s1.name = N'Anna Kuznetsova'
)
SELECT StartNode, FullPath
FROM PathCTE
WHERE LastNode = N'Olga Novikova';