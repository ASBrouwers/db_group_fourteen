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
SELECT CourseId, cast(num as float)/denom AS percentagePassing
FROM (SELECT CourseId, COUNT(case when Grade >= 5 then 1 end) AS num, COUNT(Grade) AS denom
          FROM course_reg_offer_join
          WHERE Grade IS NOT NULL
GROUP BY (CourseId)) AS s;

-- Q6 Anne
SELECT studentid, nrExcellent as nrOfCoursesWhereExcellent FROM (
SELECT studentid, COUNT(courseOfferId) as NrExcellent FROM
    (SELECT DISTINCT ON (courseOfferId)  studentId, courseOfferId 
               FROM course_reg_offer_join
               ORDER BY courseOfferId, grade DESC) AS s
GROUP BY studentid) AS t
WHERE nrExcellent >= 2;

-- Q7 Mitchell
-- check for actieve studenten moet nog toegevoegd worden
SELECT StudentRegistrationsToDegrees.DegreeId, Students.BirthyearStudent, Students.Gender, AVG(CourseRegistrations.Grade) FROM StudentRegistrationsToDegrees INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) GROUP BY (StudentRegistrationsToDegrees.DegreeId, Students.BirthyearStudent, Students.Gender);

-- Q8 Fabienne
SELECT Courses.CourseName, CourseOffers.Year, CourseOffers.Quartile
FROM (SELECT Courses.CourseId, Courses.CourseName, CourseOffers.Year, CourseOffers.Quartile FROM Courses INNER JOIN CourseOffers on (Courses.CourseId = CourseOffers.CourseId) INNER JOIN CourseRegistrations on (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId) INNER JOIN StudentAssistants on (CourseOffers.CourseOfferId = StudentAssistants.CourseOfferId)
GROUP BY Courses.CourseId, CourseOffers.Year, CourseOffers.Quartile
HAVING COUNT(CourseRegistrations.CourseOfferId) / 50 < COUNT(StudentAssistants.CourseOfferId)) as s;
