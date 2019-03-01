ALTER TABLE Students ADD PRIMARY KEY (StudentId);
ALTER TABLE CourseRegistrations ADD PRIMARY KEY (CourseOfferId, StudentRegistrationId);
ALTER TABLE StudentRegistrationsToDegrees ADD PRIMARY KEY (StudentRegistrationId);
CREATE INDEX idx_courseRegs ON CourseRegistrations(CourseOfferId);
ALTER TABLE CourseOffers ADD PRIMARY KEY (CourseOfferId);
