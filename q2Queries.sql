-- Q1 Mitchell 
-- valid StudentId and DegreeId in newer dataset
-- else use SELECT DegreeId FROM StudentRegistrationsToDegrees WHERE (StudentId = 1); to find a suitable subject
SELECT Courses.CourseName, CourseRegistrations.Grade FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN CourseRegistrations on (StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN CourseOffers on (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses on (CourseOffers.CourseId = Courses.CourseId) WHERE (Students.StudentId = 2 AND StudentRegistrationsToDegrees.DegreeId = 1099);

-- Q2 Mitchell

-- Q3 Fabienne

-- Q4 Fabienne

-- Q5 Anne

-- Q6 Anne

-- Q7

-- Q8
