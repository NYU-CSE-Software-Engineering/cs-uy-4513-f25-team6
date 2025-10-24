## User Story

As a patient
I want to find a clinic
So I can sign up for appointments  

## Acceptance Criteria

- When logged in, patient can see search fields for clinics
- Patient can enter a specialty (e.g. dermatology, physical therapy) into `Specialties` to find clinics specializing in a particular area
- Patient entering a nonexistent specialty will not work
- Patient can click on `Sort by Rating` to get a list of clinics sorted by their ratings (0 stars to five stars) 
- Patient can enter their city into `Location` to find clinics located in patient's city
- Patient entering a nonexistent city will not work


## MVC Components

### Models

A Clinic model with Specialty:string, Location:string, Rating:Float


### Views

A `patient/find_clinics.html.erb` view with two search fields (`Specialty` and `Location`) and a `Sort By Rating` button


### Controllers

A `PatientsController` with `find_clinic` action



