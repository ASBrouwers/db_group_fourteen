SELECT 0;
SELECT 0;
SELECT Degrees.DegreeId, (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as female_percent FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) GROUP BY Degrees.DegreeId;
SELECT 0;
SELECT 0;
SELECT * FROM (SELECT StudentRegistrationId, COUNT(CASE WHEN CourseRegistrations.Grade = MaxGrades.MaxGrade THEN 1 END) AS NrOfExcellentCourses FROM CourseRegistrations INNER JOIN MaxGrades ON (CourseRegistrations.CourseOfferId = MaxGrades.CourseOfferId) GROUP BY StudentRegistrationId) AS s WHERE nrOfExcellentCourses >= %1%;
SELECT ActiveStudents.DegreeId, ActiveStudents.BirthyearStudent, ActiveStudents.Gender, AVG(CourseRegistrations.Grade) FROM ActiveStudents INNER JOIN CourseRegistrations on (ActiveStudents.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) GROUP BY (ActiveStudents.DegreeId, ActiveStudents.BirthyearStudent, ActiveStudents.Gender);
SELECT Courses.CourseName, CourseOffers.Year, CourseOffers.Quartile FROM Courses INNER JOIN CourseOffers on (Courses.CourseId = CourseOffers.CourseId) INNER JOIN NrOfStudents on (CourseOffers.CourseOfferId = NrOfStudents.CourseOfferId) LEFT OUTER JOIN NrOfAssistants on (CourseOffers.CourseOfferId = NrOfAssistants.CourseOfferId) WHERE NrOfStudents.NrOfStudents / 50 > NrOfAssistants.NrOfAssistants OR NrOfAssistants IS NULL;
