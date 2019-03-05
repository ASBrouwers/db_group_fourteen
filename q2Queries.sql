-- Q1 Mitchell 
-- valid StudentId and DegreeId in newer dataset
-- else use SELECT DegreeId FROM StudentRegistrationsToDegrees WHERE (StudentId = 1); to find a suitable subject
SELECT Courses.CourseName, CourseRegistrations.Grade FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.CourseId = Courses.CourseId) WHERE (Students.StudentId = 2 AND StudentRegistrationsToDegrees.DegreeId = 1099);

-- Q2 Mitchell
-- did not find any duplicate StudentId's while testing, but this could be due to the dataset used.
SELECT DISTINCT StudentRegistrationsToDegrees.StudentId FROM StudentRegistrationsToDegrees INNER JOIN GPAAndECTSCount on (StudentRegistrationsToDegrees.StudentRegistrationId = GPAAndECTSCount.StudentRegistrationId) INNER JOIN CourseRegistrations on (GPAAndECTSCount.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) WHERE (GPAAndECTSCount.TotalECTSAcquired >= Degrees.TotalECTS AND CourseRegistrations.Grade > 5.0 AND GPAAndECTSCount.GPA > 9.0);

-- Q3 Fabienne
SELECT Degrees.DegreeId, (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as female_percent
FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId)
GROUP BY Degrees.DegreeId;

-- Q4 Fabienne
SELECT (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as female_percent
FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId)
WHERE (Degrees.Dept = %1%);

-- Q5 Anne
SELECT CourseId, COUNT(Grade), COUNT(CASE WHEN Grade >= 5 THEN 1 END), CAST(COUNT(CASE WHEN Grade >= 5 THEN 1 END) AS FLOAT) / COUNT(Grade) AS percentagePassing FROM CourseRegistrations INNER JOIN CourseOffers ON (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) WHERE Grade IS NOT NULL GROUP BY CourseId;
																					  
-- Q6 Anne
SELECT * FROM (SELECT StudentRegistrationId, COUNT(CASE WHEN CourseRegistrations.Grade = MaxGrades.MaxGrade THEN 1 END) AS NrOfExcellentCourses FROM CourseRegistrations INNER JOIN MaxGrades ON (CourseRegistrations.CourseOfferId = MaxGrades.CourseOfferId) GROUP BY StudentRegistrationId) AS s WHERE nrOfExcellentCourses >= 2;

-- Q7 Mitchell
SELECT StudentRegistrationsToDegrees.DegreeId, ActiveStudents.BirthyearStudent, ActiveStudents.Gender, AVG(CourseRegistrations.Grade) FROM StudentRegistrationsToDegrees INNER JOIN ActiveStudents on (StudentRegistrationsToDegrees.StudentId = ActiveStudents.StudentId) INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) GROUP BY (StudentRegistrationsToDegrees.DegreeId, ActiveStudents.BirthyearStudent, ActiveStudents.Gender);

-- Q8 Fabienne
SELECT CourseName, Year, Quartile
FROM (SELECT Courses.CourseId, Courses.CourseName, CourseOffers.Year, CourseOffers.Quartile FROM Courses INNER JOIN CourseOffers on (Courses.CourseId = CourseOffers.CourseId) INNER JOIN CourseRegistrations on (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId) INNER JOIN StudentAssistants on (CourseOffers.CourseOfferId = StudentAssistants.CourseOfferId)
GROUP BY Courses.CourseId, CourseOffers.Year, CourseOffers.Quartile
HAVING COUNT(CourseRegistrations.CourseOfferId) / 50 < COUNT(StudentAssistants.CourseOfferId)) as s;
