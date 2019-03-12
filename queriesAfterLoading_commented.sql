-- Query I
SELECT (CourseOffers.CourseOfferId, CourseOffers.CourseId, CourseOffers.Year, CourseOffers.Quartile, Courses.CourseName, Courses.CourseDescription, Courses.DegreeId, Courses.ECTS, Degrees.Dept, Degrees.DegreeDescription, Degrees.TotalECTS, Teachers.TeacherId, Teachers.TeacherName, Teachers.Address, Teachers.BirthyearTeacher, Teachers.Gender) FROM CourseOffers
  INNER JOIN Courses on (CourseOffers.CourseId = Courses.CourseId)
  INNER JOIN Degrees on (Courses.DegreeId = Degrees.DegreeId)
  INNER JOIN TeacherAssignmentsToCourses on
    (CourseOffers.CourseOfferId = TeacherAssignmentsToCourses.CourseOfferId)
  INNER JOIN Teachers on (TeacherAssignmentsToCourses.TeacherId = Teachers.TeacherId)
  WHERE CourseOffers.CourseOfferId = 1;

-- Query II
SELECT (CourseOffers.*, Students.*, Degrees.*) FROM 
  CourseOffers
  INNER JOIN StudentAssistants on (CourseOffers.CourseOfferId = StudentAssistants.CourseOfferId)
  INNER JOIN StudentRegistrationsToDegrees on (StudentAssistants.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId)
  INNER JOIN Students on (StudentRegistrationsToDegrees.StudentId = Students.StudentId)
  INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId)
  WHERE StudentRegistrationsToDegrees.StudentRegistrationId = 140;

-- Query III
SELECT AVG(Grade) FROM  CourseRegistrations INNER JOIN StudentRegistrationsToDegrees on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) WHERE StudentRegistrationsToDegrees.StudentRegistrationId = 140;
