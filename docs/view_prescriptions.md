Feature: View prescriptions as a patient

User Story:
As a patient, I want to view my prescriptions from my doctor(s), so that I can see the medicine prescribed, the required dosage, necessary instructions to follow, and when it was issued, and its issued date.

Acceptance Criteria:
Happy Paths:
1. Only authenticated users can access the prescriptions - once they sign in, they can view their prescriptions and the required information stated above.
2. Patients can filter their prescriptions through a dropdown menu by their status - active, expired, or cancelled. When no results match, the screen can just print "No matches found."
3. By default, patients can view their prescriptions by issue date, starting with the most recent and working their way down.

Sad Path:
1. A patient can only view their own prescriptions, not anyone else's, in order to maintain appropriate confidentiality and privacy. If someone attempts to access another patient's records, an error message will pop up.
2. If a patient has no prescriptions, the table will be empty, and have no contents.

MVC Components:

Models:
1. Patient: 'has_many :prescriptions'
2. Doctor: 'has_many :prescriptions'
3. Prescription Model:
   a. patient_id:integer
   b. doctor_id:integer
   c. medication_name:string
   d. dosage:string
   e. instructions:text
   f. issued_on:date
   g. status: string

Views: `app/prescriptions/index.html.erb`
- Lists patient prescriptions in tabular format
- Filter dropdowns by status (active, expired, cancelled)
- If no matches, empty table
- Display authorization error if attempt to access another patient's records

Controllers: PrescriptionsController with the following actions:
- Authentication, requiring the user to sign in
- Show current patient prescriptions

   
