SELECT (CourseOffers.CourseOfferId, CourseOffers.CourseId, CourseOffers.Year, CourseOffers.Quartile, Courses.CourseName, Courses.CourseDescription, Courses.DegreeId, Courses.ECTS, Degrees.Dept, Degrees.DegreeDescription, Degrees.TotalECTS, Teachers.TeacherId, Teachers.TeacherName, Teachers.Address, Teachers.BirthyearTeacher, Teachers.Gender) FROM CourseOffers
  INNER JOIN Courses on (CourseOffers.CourseId = Courses.CourseId)
  INNER JOIN Degrees on (Courses.DegreeId = Degrees.DegreeId)
  INNER JOIN TeacherAssignmentsToCourses on
    (CourseOffers.CourseOfferId = TeacherAssignmentsToCourses.CourseOfferId)
  INNER JOIN Teachers on (TeacherAssignmentsToCourses.TeacherId = Teachers.TeacherId)
  WHERE CourseOffers.CourseOfferId = '1';
