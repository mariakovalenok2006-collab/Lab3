USE master;

DROP DATABASE IF EXISTS UniversityGraph;

CREATE DATABASE UniversityGraph;

USE UniversityGraph;


CREATE TABLE Student
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    major NVARCHAR(50) NULL        -- специальность
) AS NODE;


CREATE TABLE Course
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    credits INT NOT NULL            -- задолжности
) AS NODE;


CREATE TABLE Professor
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    department NVARCHAR(50) NULL    -- кафедра
) AS NODE;

-- Ребро: Студент зачислен на курс (многие ко многим, с атрибутом "оценка")
CREATE TABLE EnrolledIn (grade INT) AS EDGE;

-- Ребро: Преподаватель ведёт курс (многие ко многим, с атрибутом "год")
CREATE TABLE Teaches (year INT) AS EDGE;

-- Ребро: Студент рекомендует курс другому студенту (направленная связь)
CREATE TABLE Recommends (recommendation_date DATE) AS EDGE;

ALTER TABLE EnrolledIn ADD CONSTRAINT EC_EnrolledIn CONNECTION (Student TO Course);
ALTER TABLE Teaches    ADD CONSTRAINT EC_Teaches    CONNECTION (Professor TO Course);
ALTER TABLE Recommends ADD CONSTRAINT EC_Recommends CONNECTION (Student TO Student);

INSERT INTO Student (id, name, major) VALUES
(1, N'Анна Кузнецова', N'Программная инженерия'),
(2, N'Иван Петров', N'Бизнес-информатика'),
(3, N'Мария Соколова', N'Математика'),
(4, N'Дмитрий Иванов', N'Физика'),
(5, N'Елена Васильева', N'Химия'),
(6, N'Сергей Козлов', N'Программная инженерия'),
(7, N'Ольга Новикова', N'Бизнес-информатика'),
(8, N'Алексей Морозов', N'Математика'),
(9, N'Татьяна Егорова', N'Физика'),
(10, N'Николай Волков', N'Химия');

Select *
FROM Student;

INSERT INTO Course (id, name, credits) VALUES
(1, N'Базы данных', 5),
(2, N'Алгоритмы и структуры данных', 6),
(3, N'Web-разработка', 4),
(4, N'Математический анализ', 5),
(5, N'Физика (механика)', 4),
(6, N'Общая химия', 4),
(7, N'Программирование на Python', 5),
(8, N'Менеджмент ИТ-проектов', 3),
(9, N'Дискретная математика', 5),
(10, N'Искусственный интеллект', 6);

Select *
FROM Course;

INSERT INTO Professor (id, name, department) VALUES
(1, N'Проф. Андрей Смирнов', N'Информационных технологий'),
(2, N'Доц. Елена Орлова', N'Прикладной математики'),
(3, N'Проф. Виктор Тарасов', N'Физики'),
(4, N'Доц. Наталья Белова', N'Химии'),
(5, N'Проф. Михаил Лебедев', N'Информационных технологий'),
(6, N'Ст. преп. Ирина Крылова', N'Экономики'),
(7, N'Проф. Денис Захаров', N'Математики'),
(8, N'Доц. Светлана Павлова', N'Информационных технологий'),
(9, N'Ст. преп. Григорий Семёнов', N'Физики'),
(10, N'Проф. Лариса Тихонова', N'Химии');

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

SELECT s.name AS Студент, c.name AS Курс, e.grade AS Оценка
FROM Student AS s, EnrolledIn AS e, Course AS c
WHERE MATCH(s-(e)->c) 
  AND s.name = N'Анна Кузнецова';
  
SELECT p.name AS Преподаватель, c.name AS Курс, s.name AS Студент, e.grade AS Оценка
FROM Professor AS p, Teaches AS t, Course AS c, EnrolledIn AS e, Student AS s
WHERE MATCH(p-(t)->c<-(e)-s)
  AND p.name = N'Проф. Андрей Смирнов';

SELECT r1.name AS Рекомендатель, r2.name AS Получатель, 
       rec.recommendation_date AS ДатаРекомендации,
       c.name AS РекомендованныйКурс
FROM Student AS r1, Recommends AS rec, Student AS r2,
     EnrolledIn AS e, Course AS c
WHERE MATCH(r1-(rec)->r2-(e)->c);

SELECT s.name AS Студент, c.name AS Курс, p.name AS Преподаватель
FROM Student AS s, EnrolledIn AS e, Course AS c, Teaches AS t, Professor AS p
WHERE MATCH(s-(e)->c<-(t)-p)
  AND p.department LIKE N'%Информационных технологий%'

SELECT s.name AS Студент, c.name AS Курс, e.grade AS Оценка, p.name AS Преподаватель
FROM Student AS s, EnrolledIn AS e, Course AS c, Teaches AS t, Professor AS p
WHERE MATCH(s-(e)->c<-(t)-p)
  AND e.grade > 90;

SELECT 
    s1.name AS НачальныйСтудент,
    STRING_AGG(s2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ПутьРекомендаций,
    LAST_VALUE(s2.name) WITHIN GROUP (GRAPH PATH) AS КонечныйСтудент
FROM 
    Student AS s1,
    Recommends FOR PATH AS r,
    Student FOR PATH AS s2
WHERE MATCH(SHORTEST_PATH(s1(-(r)->s2)+))
  AND s1.name = N'Анна Кузнецова';

SELECT 
    s1.name AS НачальныйСтудент,
    STRING_AGG(s2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ПутьРекомендаций,
    LAST_VALUE(s2.name) WITHIN GROUP (GRAPH PATH) AS КонечныйСтудент
FROM 
    Student AS s1,
    Recommends FOR PATH AS r,
    Student FOR PATH AS s2
WHERE MATCH(SHORTEST_PATH(s1(-(r)->s2){1,3}))
  AND s1.name = N'Иван Петров';


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
      AND s1.name = N'Анна Кузнецова'
)
SELECT StartNode, FullPath
FROM PathCTE
WHERE LastNode = N'Ольга Новикова';