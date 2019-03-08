SELECT Courses.CourseName, CourseRegistrations.Grade FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.CourseId = Courses.CourseId) WHERE (Students.StudentId = %1% AND StudentRegistrationsToDegrees.DegreeId = %2% AND CourseRegistrations.Grade >= 5.0);
SELECT DISTINCT StudentRegistrationsToDegrees.StudentId FROM StudentRegistrationsToDegrees INNER JOIN GPAAndECTSCount on (StudentRegistrationsToDegrees.StudentRegistrationId = GPAAndECTSCount.StudentRegistrationId) INNER JOIN CourseRegistrations on (GPAAndECTSCount.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) WHERE (GPAAndECTSCount.TotalECTSAcquired >= Degrees.TotalECTS AND CourseRegistrations.Grade >= 5.0 AND GPAAndECTSCount.GPA > %1%);
SELECT Degrees.DegreeId, (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as percentage FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) GROUP BY Degrees.DegreeId;
SELECT (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as percentage FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) WHERE (Degrees.Dept = %1%);
SELECT CourseId, CAST(COUNT(CASE WHEN Grade >= %1% THEN 1 END) AS FLOAT) / COUNT(Grade) AS percentagePassing FROM CourseRegistrations INNER JOIN CourseOffers ON (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) WHERE Grade IS NOT NULL GROUP BY CourseId;
SELECT studentid, nrOfExcellentCourses AS numberOfCourseswhereExcellent FROM (SELECT StudentId, COUNT(CASE WHEN CourseRegistrations.Grade = MaxGrades.MaxGrade THEN 1 END) AS NrOfExcellentCourses FROM CourseRegistrations INNER JOIN MaxGrades ON (CourseRegistrations.CourseOfferId = MaxGrades.CourseOfferId) INNER JOIN StudentRegistrationsToDegrees ON (CourseRegistrations.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) GROUP BY StudentId) AS s WHERE nrOfExcellentCourses >= %1%;
SELECT ActiveStudents.DegreeId, ActiveStudents.BirthyearStudent AS birthyear, ActiveStudents.Gender, AVG(CourseRegistrations.Grade) AS avgGrade FROM ActiveStudents INNER JOIN CourseRegistrations on (ActiveStudents.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) GROUP BY (ActiveStudents.DegreeId, ActiveStudents.BirthyearStudent, ActiveStudents.Gender);
SELECT Courses.CourseName, CourseOffers.Year, CourseOffers.Quartile FROM Courses INNER JOIN CourseOffers on (Courses.CourseId = CourseOffers.CourseId) INNER JOIN NrOfStudents on (CourseOffers.CourseOfferId = NrOfStudents.CourseOfferId) LEFT OUTER JOIN NrOfAssistants on (CourseOffers.CourseOfferId = NrOfAssistants.CourseOfferId) WHERE NrOfStudents.NrOfStudents / 50 > NrOfAssistants.NrOfAssistants OR NrOfAssistants IS NULL;