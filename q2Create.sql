ALTER TABLE Students ADD PRIMARY KEY (StudentId);
ALTER TABLE CourseRegistrations ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);
ALTER TABLE StudentRegistrationsToDegrees ADD PRIMARY KEY (StudentRegistrationId);
CREATE INDEX idx_courseRegs ON CourseRegistrations(CourseOfferId);
ALTER TABLE CourseOffers ADD PRIMARY KEY (CourseOfferId);

-- The following creates a materialized view of the GPA and ECTS count per student registration id (i.e. per student id and degree id)
-- warning - uses an incorrect method of calculating gpa
CREATE MATERIALIZED VIEW GPAAndECTSCount AS SELECT StudentRegistrationsToDegrees.StudentRegistrationId, AVG(CAST(CourseRegistrations.Grade as float)/cast(Courses.ECTS as float)) AS GPA, SUM(Courses.ECTS) AS TotalECTSAcquired FROM StudentRegistrationsToDegrees INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.COurseId = Courses.CourseId) INNER JOIN Degrees on (Courses.DegreeId = Degrees.DegreeId) WHERE (CourseRegistrations.Grade > 5.0) GROUP BY StudentRegistrationsToDegrees.StudentRegistrationId;
 
