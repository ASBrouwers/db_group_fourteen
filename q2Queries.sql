SELECT 0;
SELECT 0;
SELECT 0;
SELECT 0;
SELECT 0;
SELECT 0;
SELECT 0;
SELECT Courses.CourseName, CourseOffers.Year, CourseOffers.Quartile FROM Courses INNER JOIN CourseOffers on (Courses.CourseId = CourseOffers.CourseId) INNER JOIN NrOfStudents on (CourseOffers.CourseOfferId = NrOfStudents.CourseOfferId) LEFT OUTER JOIN NrOfAssistants on (CourseOffers.CourseOfferId = NrOfAssistants.CourseOfferId) WHERE NrOfStudents.NrOfStudents / 50 > NrOfAssistants.NrOfAssistants OR NrOfAssistants IS NULL ORDER BY CourseOffers.CourseOfferId;