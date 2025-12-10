require 'rails_helper'

RSpec.describe 'Missing Record Redirect (request)', type: :request do
    it 'redirects to clinics page when not logged in' do
        get clinic_doctors_path(999)

        expect(response).to redirect_to(clinics_path)
        follow_redirect!
        expect(response.body).to include('There is no clinic with id 999')
    end

    describe 'redirects to dashboard when logged in' do
        it 'as patient' do
            login_patient
            get doctor_time_slots_path(999)

            expect(response).to redirect_to(patient_dashboard_path)
            follow_redirect!
            expect(response.body).to include('There is no doctor with id 999')
        end

        it 'as doctor' do
            login_doctor
            get new_appointment_bill_path(999)

            expect(response).to redirect_to(doctor_dashboard_path)
            follow_redirect!
            expect(response.body).to include('There is no appointment with id 999')
        end

        it 'as admin' do
            login_admin
            get bill_path(999)

            expect(response).to redirect_to(admin_dashboard_path)
            follow_redirect!
            expect(response.body).to include('There is no bill with id 999')
        end
    end
end