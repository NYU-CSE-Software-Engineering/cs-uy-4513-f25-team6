## User Story

As a doctor  
I want to configure my time slots  
So that patients can see when I'm available  

## Acceptance Criteria

- When logged in, doctor can see their current set of time slots
- Doctor can press "Edit time slots" to go to the slot editor page (which shows all possible slots)
- On the slot page, doctor can click each slot to toggle it on or off
- On the slot page, doctor can press "Confirm time slots" to save their changes
- Pressing "Confirm time slots" will not work if no slots are selected

## MVC Components

### Models

A Doctor model with ID:integer (and a variety of other attributes), only needed here for login purposes  
A TimeSlot model with doctorID:integer and time:datetime attributes, to associate each doctor with their selected time slots

### Views

A `doctors/show.html.erb` page that serves as the main doctor profile page  
A `doctors/time_slots.html.erb` view with a list of time slots that can be toggled (via checkboxes)

### Controllers

A DoctorsController with show, edit_slots, and update_slots actions