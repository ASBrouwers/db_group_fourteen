ALTER TABLE CourseRegistrations ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);
CREATE INDEX idx_courseRegs ON CourseRegistrations(CourseOfferId);
CREATE MATERIALIZED VIEW MaxGrades AS SELECT CourseRegistrations.CourseOfferId, MAX(Grade) AS MaxGrade FROM CourseRegistrations JOIN CourseOffers ON (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId) WHERE Year = 2018 AND Quartile = 1 GROUP BY CourseRegistrations.CourseOfferId;
CREATE MATERIALIZED VIEW GPAAndECTSCount AS SELECT CourseRegistrations.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, SUM(Courses.ECTS) AS TotalECTSAcquired FROM CourseRegistrations INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.COurseId = Courses.CourseId) WHERE (CourseRegistrations.Grade >= 5.0) GROUP BY CourseRegistrations.StudentRegistrationId;
CREATE MATERIALIZED VIEW ActiveStudents AS 
SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, Students.Gender, Students.BirthyearStudent, StudentRegistrationsToDegrees.DegreeId
FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId)
WHERE GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS;
CREATE MATERIALIZED VIEW NrOfStudents AS
SELECT CourseOffers.CourseOfferId, COUNT(CourseRegistrations.StudentRegistrationId) AS NrOfStudents
FROM CourseOffers INNER JOIN CourseRegistrations on (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId)
GROUP BY CourseOffers.CourseOfferId;
CREATE MATERIALIZED VIEW NrOfAssistants AS
SELECT CourseOffers.CourseOfferId, COUNT(StudentAssistants.StudentRegistrationId) AS NrOfAssistants
FROM CourseOffers INNER JOIN StudentAssistants on (CourseOffers.CourseOfferId = StudentAssistants.CourseOfferId)
GROUP BY CourseOffers.CourseOfferId;
CREATE MATERIALIZED VIEW ExcellentStudentId AS SELECT StudentRegistrationsToDegrees.StudentId FROM StudentRegistrationsToDegrees INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) Group By StudentRegistrationsToDegrees.StudentId HAVING (COUNT(CASE WHEN CourseRegistrations.Grade < 5.0 THEN 1 WHEN CourseRegistrations.Grade IS NULL THEN 1 END) = 0) ORDER BY StudentRegistrationsToDegrees.StudentId;
