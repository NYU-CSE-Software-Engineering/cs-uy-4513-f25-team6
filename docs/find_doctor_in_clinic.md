## User Story

As a Patient
I want to find a doctor within a clinic
So that I can make an appointment

## Acceptance Criteria

- When on this page, the patient can see a list of all doctors within the clinic, and two search fields
- Patient can enter a specialty into `Specialties` to see all doctors specializing in that particular area within the clinic
- Patient entering a nonexistent specialty will not work
- Patient can enter doctor's name into `Name` to find a specific doctor
- Patient entering a nonexistent name will not work
- Patient can click on `Sort By Rating` to sort the doctor list by their ratings


## MVC Components

### Models

A Doctor model with Name:string, Specialty:string, Rating:Float

### Views

A `patient/show_doctors.html.erb` view with two search fields: `Name` and `Speciality`, and a `Sort By Rating` button


### Controllers

A `DoctorController` with `show_doctors` action


