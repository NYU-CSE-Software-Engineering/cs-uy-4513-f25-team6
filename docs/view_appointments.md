Feature: View appointments as a doctor

User Story:
As a doctor, I want to view a list of my upcoming appointments, so that I can organize my daily schedule and know which patients I will be seeing.

Acceptance Criteria:
Happy Paths:
1. A signed-in doctor can access a page showing their list of appointments.
2. Each appointment displays key details: patient name, date, time, clinic location, and appointment status.
3. Appointments are ordered by date/time, showing the next upcoming appointment first.
4. The doctor can filter appointments by status (e.g., upcoming, completed, cancelled).

Sad Paths:
1. If a non-authenticated user tries to access the page, they are redirected to the login page.
2. If a doctor attempts to view another doctor’s appointments (by manually changing the URL or ID), an error message appears saying “You are not authorized to view this page.”
3. If there are no appointments scheduled, the page displays: “No upcoming appointments found.”

MVC Components:

Models:
1. Doctor: 'has_many :appointments'
2. Patient: 'has_many :appointments'
3. Appointment:
    a. doctor_id:integer
    b. patient_id:integer
    c. appointment_time:datetime
    d. status:string
    e. clinic_name:string

Views: `app/views/appointments/index.html.erb`
- Displays a table of the doctor’s appointments
- Includes a filter dropdown for status
- If none exist, displays “No upcoming appointments found”
- If unauthorized, displays “You are not authorized to view this page.”

Controllers: AppointmentsController with the following actions
- before_action :authenticate_doctor!
- index action retrieves all appointments belonging to the current doctor
- Supports filtering by status