ALTER TABLE Students ADD PRIMARY KEY (StudentId);
ALTER TABLE CourseRegistrations ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);
ALTER TABLE StudentRegistrationsToDegrees ADD PRIMARY KEY (StudentRegistrationId);
CREATE INDEX idx_courseRegs ON CourseRegistrations(CourseOfferId);
ALTER TABLE CourseOffers ADD PRIMARY KEY (CourseOfferId);

-- The following creates a materialized view of the GPA and ECTS count per student registration id
CREATE MATERIALIZED VIEW GPAAndECTSCount AS SELECT StudentRegistrationsToDegrees.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, SUM(Courses.ECTS) AS TotalECTSAcquired FROM StudentRegistrationsToDegrees INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.COurseId = Courses.CourseId) INNER JOIN Degrees on (Courses.DegreeId = Degrees.DegreeId) WHERE (CourseRegistrations.Grade > 5.0) GROUP BY StudentRegistrationsToDegrees.StudentRegistrationId;

-- test of materialized view - list student activity:
SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, StudentRegistrationsToDegrees.DegreeId, GPAAndECTSCount.GPA, GPAAndECTSCount.TotalECTSAcquired, Degrees.TotalECTS, cast((CASE WHEN GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS THEN 1 ELSE 0 END) as float) AS StudentActive FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) LIMIT 100;
 
