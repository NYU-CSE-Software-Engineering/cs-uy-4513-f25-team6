# Doctor sign-up: User story, acceptance criteria, and MVC outline

## User Story
As a doctor, I want to create an account for the clinic so that I can access the provider dashboard and manage my patients.

## Acceptance Criteria
- Happy path: From the “Sign up as Doctor” page, entering Name, Email, Password/Confirmation, Medical License Number, Specialty, Phone Number, and Account Number successfully creates an account and signs me in (or shows a confirmation notice if email confirmation is required).
- Validation: Missing required fields (Email, Password, License Number, Phone Number, Account Number) shows inline errors and does not create the account.
- Uniqueness: Using an email already taken by another doctor shows an error and prevents sign-up.
- License format: An invalid License Number (wrong format) shows a validation error.
- Phone format: An invalid Phone Number shows a validation error.
- Account number format: An invalid Account Number (non-numeric or too short/long) shows a validation error.
- Security: Passwords below the minimum length show an error. Password and confirmation must match.

## MVC Outline

### Models
Doctor(email:string:index, encrypted_password:string, name:string, specialty:string, license_number:string:index, phone_number:string, account_number:string, confirmed_at:datetime?)

Validations:
- email presence/format/uniqueness
- password presence/length (e.g., ≥ 8), confirmation
- license_number presence/format (e.g., /\A[A-Z0-9\-]{6,20}\z/)
- phone_number presence/format (e.g., /\A[0-9\-\+\(\)\s]{7,20}\z/)
- account_number presence/format (e.g., digits only, length 6–20: /\A\d{6,20}\z/)

### Views
- doctors/registrations/new.html.erb (sign-up form)
- doctors/show.html.erb or dashboard page after sign-up

### Controllers
- If using Devise: `Doctors::RegistrationsController < Devise::RegistrationsController` (override strong params to permit name, specialty, license_number)
  - Permit: `name`, `specialty`, `license_number`, `phone_number`, `account_number`
- If custom auth: `DoctorsController#new`, `#create`, `SessionsController#new`, `#create`

### Routes
- With Devise (recommended):
  `devise_for :doctors, controllers: { registrations: 'doctors/registrations' }`
- Or custom:
  `resources :doctors, only: %i[new create show]`

## Notes
- The success message can be either immediate welcome or Devise’s confirmation notice.
- Keep error messages synchronized with actual model validations to avoid brittle tests.

