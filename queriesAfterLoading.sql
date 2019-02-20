SELECT (CourseOffers.*, Courses.*, Degrees.*, Teachers.*) FROM CourseOffers
  INNER JOIN Courses on (CourseOffers.CourseId = Courses.CourseId)
  INNER JOIN Degrees on (Courses.DegreeId = Degrees.DegreeId)
  INNER JOIN TeacherAssignmentsToCourses on
    (CourseOffers.CourseOfferId = TeacherAssignmentsToCourses.CourseOfferId)
  INNER JOIN Teachers on (TeacherAssignmentsToCourses.TeacherId = Teachers.TeacherId)
  WHERE CourseOffers.CourseOfferId = '1';
