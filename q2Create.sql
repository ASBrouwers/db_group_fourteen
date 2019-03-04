ALTER TABLE Students ADD PRIMARY KEY (StudentId);
ALTER TABLE CourseRegistrations ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);
ALTER TABLE StudentRegistrationsToDegrees ADD PRIMARY KEY (StudentRegistrationId);
CREATE INDEX idx_courseRegs ON CourseRegistrations(CourseOfferId);
ALTER TABLE CourseOffers ADD PRIMARY KEY (CourseOfferId);
ALTER TABLE Degrees ADD PRIMARY KEY (DegreeId);
ALTER TABLE Courses ADD PRIMARY KEY (CourseId);
ALTER TABLE StudentAssistants ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);


-- Small MV for max grade per course offer
CREATE MATERIALIZED VIEW MaxGrades AS SELECT CourseRegistrations.CourseOfferId, MAX(Grade) AS MaxGrade FROM CourseRegistrations JOIN CourseOffers ON (CourseOffers.CourseOfferId = CourseRegistrations.CourseOfferId) WHERE Year = 2018 AND Quartile = 1 GROUP BY CourseRegistrations.CourseOfferId;

-- The following creates a materialized view of the GPA and ECTS count per student registration id
CREATE MATERIALIZED VIEW GPAAndECTSCount AS SELECT StudentRegistrationsToDegrees.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, SUM(Courses.ECTS) AS TotalECTSAcquired FROM StudentRegistrationsToDegrees INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.COurseId = Courses.CourseId) INNER JOIN Degrees on (Courses.DegreeId = Degrees.DegreeId) WHERE (CourseRegistrations.Grade > 5.0) GROUP BY StudentRegistrationsToDegrees.StudentRegistrationId;

-- test of materialized view - list student activity:
SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, Students.Gender, StudentRegistrationsToDegrees.DegreeId, GPAAndECTSCount.GPA, GPAAndECTSCount.TotalECTSAcquired, Degrees.TotalECTS, cast((CASE WHEN GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS THEN 1 ELSE 0 END) as float) AS StudentActive FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) LIMIT 100;


-- Materialized view of all active students
CREATE MATERIALIZED VIEW ActiveStudents AS 
SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, Students.Gender, Students.BirthyearStudent, StudentRegistrationsToDegrees.DegreeId
FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId)
WHERE GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS;
