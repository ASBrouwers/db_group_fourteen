CREATE UNLOGGED TABLE GPAandProgress AS SELECT StudentRegistrationsToDegrees.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, CAST(CASE WHEN SUM(Courses.ECTS) < Degrees.TotalECTS AND SUM(Courses.ECTS) IS NOT NULL THEN 1 WHEN SUM(Courses.ECTS) > Degrees.TotalECTS AND SUM(Courses.ECTS) IS NOT NULL THEN 2 ELSE 0 END AS integer) AS Completion FROM StudentRegistrationsToDegrees, CourseRegistrations, CourseOffers, Courses, Degrees WHERE StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId AND CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId AND CourseOffers.CourseId = Courses.CourseId AND StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId AND CourseRegistrations.Grade >= 5.0 GROUP BY StudentRegistrationsToDegrees.StudentRegistrationId, Degrees.TotalECTS;


-- doesnt work
UPDATE StudentRegistrationsToDegrees SET GPA  = SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) FROM CourseRegistrations, CourseOffers, Courses WHERE StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId AND CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId AND CourseOffers.CourseId = Courses.CourseId;


CREATE UNLOGGED TABLE GPAandProgress AS SELECT StudentRegistrationsToDegrees.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, CAST(CASE WHEN SUM(Courses.ECTS) < Degrees.TotalECTS AND SUM(Courses.ECTS) IS NOT NULL THEN 1 WHEN SUM(Courses.ECTS) > Degrees.TotalECTS AND SUM(Courses.ECTS) IS NOT NULL THEN 2 ELSE 0 END AS integer) AS Completion FROM StudentRegistrationsToDegrees, CourseRegistrations, CourseOffers, Courses, Degrees WHERE StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId AND CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId AND CourseOffers.CourseId = Courses.CourseId AND StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId AND CourseRegistrations.Grade >= 5.0 GROUP BY StudentRegistrationsToDegrees.StudentRegistrationId, Degrees.TotalECTS;









CREATE UNLOGGED TABLE GPAAndECTSCount AS SELECT Students.StudentRegistrationId, SUM(CourseRegistrations.Grade * Courses.ECTS) / CAST(SUM(Courses.ECTS) AS float) AS GPA, SUM(Courses.ECTS) AS TotalECTSAcquired FROM CourseRegistrations INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.COurseId = Courses.CourseId) INNER JOIN Students on (CourseRegistrations.StudentRegistrationId = Students.StudentRegistrationId) WHERE (CourseRegistrations.Grade >= 5.0) GROUP BY CourseRegistrations.StudentRegistrationId;

CREATE UNLOGGED TABLE StudentActivity AS SELECT StudentRegistrationsToDegrees.StudentRegistrationId, CAST(CASE WHEN GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS AND GPAAndECTSCount.TotalECTSAcquired IS NOT NULL THEN 1 WHEN GPAAndECTSCount.TotalECTSAcquired > Degrees.TotalECTS AND GPAAndECTSCount.TotalECTSAcquired IS NOT NULL THEN 2 ELSE 0 END AS integer) FROM StudentRegistrationsToDegrees, GPAAndECTSCount, Degrees WHERE StudentRegistrationsToDegrees.StudentRegistrationId = GPAAndECTSCount.StudentRegistrationId





CREATE MATERIALIZED VIEW ActiveStudents AS SELECT GPAandECTSCount.StudentRegistrationId, StudentRegistrationsToDegrees.StudentId, Students.Gender, Students.BirthyearStudent, StudentRegistrationsToDegrees.DegreeId FROM GPAAndECTSCount INNER JOIN StudentRegistrationsToDegrees on (GPAAndECTSCount.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) WHERE GPAAndECTSCount.TotalECTSAcquired < Degrees.TotalECTS;
