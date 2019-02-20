--
COPY Degrees(DegreeId, Dept, DegreeDescription, TotalECTS) FROM '/home/student/Desktop/tables/Degrees.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY Students(StudentId, StudentName, Address, BirthYearStudent, Gender) FROM '/home/student/Desktop/tables/Students.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY StudentRegistrationsToDegrees(StudentRegistrationId, StudentId, DegreeId, RegistrationYear) FROM '/home/student/Desktop/tables/StudentRegistrationsToDegrees.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY Teachers(TeacherId, TeacherName, Address, BirthyearTeacher, Gender) FROM '/home/student/Desktop/tables/Teachers.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY Courses(CourseId, CourseName, CourseDescription, DegreeId, ECTS) FROM '/home/student/Desktop/tables/Courses.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY CourseOffers(CourseOfferId, CourseId, Year, Quartile) FROM '/home/student/Desktop/tables/CourseOffers.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY TeacherAssignmentsToCourses(CourseOfferId, TeacherId) FROM '/home/student/Desktop/tables/TeacherAssignmentsToCourses.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY StudentAssistants(CourseOfferId, StudentRegistrationId) FROM '/home/student/Desktop/tables/StudentAssistants.table' DELIMITER ',' CSV HEADER NULL AS 'null';
COPY CourseRegistrations(CourseOfferId, StudentRegistrationId, Grade) FROM '/home/student/Desktop/tables/CourseRegistrations.table' DELIMITER ',' CSV HEADER NULL AS 'null';
