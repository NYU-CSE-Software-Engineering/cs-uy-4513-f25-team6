require 'rails_helper'

RSpec.describe 'Account Registration (request)', type: :request do
    describe 'new patient' do
        let(:patient_obj) { Patient.new }
        let(:patient_details) {
            {email: 'newPat@test.com', username: 'NewPatient', password:'helloworld', 
             age: 25, height: 72, weight: 200, gender: 'Male'}
        }

        it 'visits registration page' do
            get new_patient_path
    
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('Sign up as a patient')
        end

        it 'fails to create account with missing parameters' do
            post patients_path

            expect(response).to render_template('patients/new')
            expect(response.body).to include('Missing required information')
        end

        it 'fails to create account with invalid details' do
            expect(Patient).to receive(:new).and_return(patient_obj)
            expect(patient_obj).to receive(:valid?).and_return(false)
            expect(patient_obj).not_to receive(:save)

            post patients_path, params: {patient: patient_details}

            expect(response).to render_template('patients/new')
            expect(response.body).to include('Invalid account details')
        end

        it 'creates account with valid details' do
            expect(Patient).to receive(:new).and_return(patient_obj)
            expect(patient_obj).to receive(:valid?).and_return(true)
            expect(patient_obj).to receive(:save)
            expect(patient_obj).to receive(:id)

            post patients_path, params: {patient: patient_details}

            expect(response).to redirect_to(patient_dashboard_path)
            follow_redirect!
            expect(response.body).to include('Patient account created')
        end
    end

    describe 'new doctor' do
        let(:doctor_obj) { Doctor.new }
        let(:doctor_details) {
            {email: 'newDoc@test.com', username: 'NewDoctor', password:'helloworld', 
             specialty: 'Fever', phone: '555-555-5555'}
        }

        it 'visits registration page' do
            get new_doctor_path
    
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('Sign up as a doctor')
        end

        it 'fails to create account with missing parameters' do
            post doctors_path

            expect(response).to render_template('doctors/new')
            expect(response.body).to include('Missing required information')
        end

        it 'fails to create account with invalid details' do
            expect(Doctor).to receive(:new).and_return(doctor_obj)
            expect(doctor_obj).to receive(:valid?).and_return(false)
            expect(doctor_obj).not_to receive(:save)

            post doctors_path, params: {doctor: doctor_details}

            expect(response).to render_template('doctors/new')
            expect(response.body).to include('Invalid account details')
        end

        it 'creates account with valid details' do
            expect(Doctor).to receive(:new).and_return(doctor_obj)
            expect(doctor_obj).to receive(:valid?).and_return(true)
            expect(doctor_obj).to receive(:save)
            expect(doctor_obj).to receive(:id)

            post doctors_path, params: {doctor: doctor_details}

            expect(response).to redirect_to(doctor_dashboard_path)
            follow_redirect!
            expect(response.body).to include('Doctor account created')
        end
    end

    describe 'new admin' do
        let(:admin_obj) { Admin.new }
        let(:admin_details) {
            {email: 'newAdm@test.com', username: 'NewAdmin', password:'helloworld'}
        }

        it 'visits registration page' do
            get new_admin_path
    
            expect(response).to have_http_status(:ok)
            expect(response.body).to include('Sign up as an admin')
        end

        it 'fails to create account with missing parameters' do
            post admins_path

            expect(response).to render_template('admins/new')
            expect(response.body).to include('Missing required information')
        end

        it 'fails to create account with invalid details' do
            expect(Admin).to receive(:new).and_return(admin_obj)
            expect(admin_obj).to receive(:valid?).and_return(false)
            expect(admin_obj).not_to receive(:save)

            post admins_path, params: {admin: admin_details}

            expect(response).to render_template('admins/new')
            expect(response.body).to include('Invalid account details')
        end

        it 'creates account with valid details' do
            expect(Admin).to receive(:new).and_return(admin_obj)
            expect(admin_obj).to receive(:valid?).and_return(true)
            expect(admin_obj).to receive(:save)
            expect(admin_obj).to receive(:id)

            post admins_path, params: {admin: admin_details}

            expect(response).to redirect_to(admin_dashboard_path)
            follow_redirect!
            expect(response.body).to include('Admin account created')
        end
    end
end