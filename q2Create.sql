ALTER TABLE CourseRegistrations ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);
CREATE INDEX idx_courseRegs ON CourseRegistrations(CourseOfferId);

-- Small MV for max grade per course offer
CREATE MATERIALIZED VIEW MaxGrades AS SELECT CourseRegistrations.CourseOfferId, MAX(Grade) AS MaxGrade FROM CourseRegistrations JOIN CourseOffers ON (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId) WHERE Year = 2018 AND Quartile = 1 GROUP BY CourseRegistrations.CourseOfferId;

-- The following creates a materialized view of the GPA and ECTS count per student registration id
-- updated, should be faster to complete this command
-- execution times:
-- * with PK on courseregistrations (02:31,257)
-- * without PK on courseregistrations (02:52,535)
CREATE MATERIALIZED VIEW GPAAndECTSCount AS SELECT CourseRegistrations.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, SUM(Courses.ECTS) AS TotalECTSAcquired FROM CourseRegistrations INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.COurseId = Courses.CourseId) WHERE (CourseRegistrations.Grade >= 5.0) GROUP BY CourseRegistrations.StudentRegistrationId;

-- test of materialized view - list student activity:
SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, Students.Gender, StudentRegistrationsToDegrees.DegreeId, GPAAndECTSCount.GPA, GPAAndECTSCount.TotalECTSAcquired, Degrees.TotalECTS, cast((CASE WHEN GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS THEN 1 ELSE 0 END) as float) AS StudentActive FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) LIMIT 100;


-- Materialized view of all active students
CREATE MATERIALIZED VIEW ActiveStudents AS 
SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, Students.Gender, Students.BirthyearStudent, StudentRegistrationsToDegrees.DegreeId
FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId)
WHERE GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS;

-- Materialized view of number of students per courseoffer
CREATE MATERIALIZED VIEW NrOfStudents AS
SELECT CourseOffers.CourseOfferId, COUNT(CourseRegistrations.StudentRegistrationId) AS NrOfStudents
FROM CourseOffers INNER JOIN CourseRegistrations on (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId)
GROUP BY CourseOffers.CourseOfferId;

-- Materialized view of number of studentassistants per courseoffer
CREATE MATERIALIZED VIEW NrOfAssistants AS
SELECT CourseOffers.CourseOfferId, COUNT(StudentAssistants.StudentRegistrationId) AS NrOfAssistants
FROM CourseOffers INNER JOIN StudentAssistants on (CourseOffers.CourseOfferId = StudentAssistants.CourseOfferId)
GROUP BY CourseOffers.CourseOfferId;
