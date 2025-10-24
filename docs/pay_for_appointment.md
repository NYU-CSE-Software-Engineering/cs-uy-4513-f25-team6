# Pay for Appointment (Patient)

## User Story
As a signed-in patient, I want to pay the bill for my appointment so that I can settle the balance and view my updated billing status.

## Acceptance Criteria
1. Given I have an unpaid bill, when I open the bill page, then I see the bill details (doctor, clinic, appointment date/time, amount due) and a “Pay Now” form.
2. Given I am on my unpaid bill page, when I submit valid payment details, then I see “Payment successful,” the bill status becomes “paid,” and I remain on the bill page with an updated status.
3. Given I am on my unpaid bill page, when I submit invalid or incomplete card info, then I see an error and stay on the same page with my previous inputs preserved (except sensitive fields).
4. Given a bill is already paid, when I attempt to pay again, then I see “This bill is already paid” and no new charge is recorded.
5. Given I open a bill that does not belong to me, then I am blocked (redirected with an authorization error).

## MVC Outline

### Models
- **Bill**: `id`, `patient_id`, `appointment_id`, `amount_cents:integer`, `status:string` (enum: `unpaid`, `paid`), `paid_at:datetime`, timestamps  
  Associations: `belongs_to :patient`, `belongs_to :appointment`  
  Validations: `amount_cents > 0`, `status` inclusion
- **Appointment** (existing): links a patient & doctor, date/time
- **Patient** (existing): authentication + ownership
- **Payment** audit: `bill_id`, `txn_id`, `amount_cents`, `state`, `gateway_response`, timestamps

> Matches spec’s **bills** table and “Payment system” module, which lets patients make a payment for an appointment. :contentReference[oaicite:3]{index=3}

### Views
- `patients/billing/show.html.erb` (or `bills/show.html.erb`): shows bill details + a “Pay Now” form (`card_number`, `exp_month`, `exp_year`, `cvc`) and messages for success/failure.  
  Browser path conforms to `/patient/billing/{bill}`. :contentReference[oaicite:4]{index=4}

### Controllers
- `BillsController`
  - `show` — renders the bill page for the current patient
  - `pay` — POST handler to process payment, update `Bill` to `paid`, set `paid_at`, flash success, redirect back to `show`
  - `index` — list of bills for the current patient
