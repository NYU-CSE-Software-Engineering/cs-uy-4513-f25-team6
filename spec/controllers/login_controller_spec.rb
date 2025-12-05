require 'rails_helper'
require 'spec_helper'

RSpec.describe LoginController, type: :controller do

    describe 'GET #form' do 

        it 'renders the login form' do 
            get :form 
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:form)
        end 

        it 'redirects already authenticated users to their dashboards' do 
            login_patient(true)

            get :form 
            
            expect(response).to redirect_to(patient_dashboard_path) 
        end
    end


    describe 'POST #login' do 
        
        let(:pw_hash) { Digest::MD5.hexdigest('secret12') } 

        context 'with valid credentials' do

            it 'patient logs in successfully' do
                patient_class = class_double("Patient").as_stubbed_const
                patient = instance_double("Patient", email: 'pat@example.com', id: 1, class: patient_class)
                expect(patient_class).to receive(:find_by).with({email: patient.email, password: pw_hash}).and_return(patient)

                post :login, params: {email: 'pat@example.com', password: 'secret12', role: 'patient'}

                expect(session[:user_id]).to eq(patient.id) # verifies that that the patient's user ID is stored in the session (proves they're logged in)
                expect(response).to redirect_to(patient_dashboard_path) # verifies that patient is redirected to patient's dashboard after successful login
            end 

            it 'doctor logs in successfully' do
                doctor_class = class_double("Doctor").as_stubbed_const
                doctor = instance_double("Doctor", email: 'drsmith@example.com', id: 2, class: doctor_class)
                expect(doctor_class).to receive(:find_by).with({email: doctor.email, password: pw_hash}).and_return(doctor)

                post :login, params: {email: 'drsmith@example.com', password: 'secret12', role: 'doctor'}

                expect(session[:user_id]).to eq(doctor.id) # verifies that that the doctor's user ID is stored in the session (proves they're logged in)
                expect(response).to redirect_to(doctor_dashboard_path) # verifies that doctor is redirected to doctor's dashboard after successful login
            end 

            it 'admin logs in successfully' do
                admin_class = class_double("Admin").as_stubbed_const
                admin = instance_double("Admin", email: 'admin@example.com', id: 3, class: admin_class)
                expect(admin_class).to receive(:find_by).with({email: admin.email, password: pw_hash}).and_return(admin)

                post :login, params: {email: 'admin@example.com', password: 'secret12', role: 'admin'}

                expect(session[:user_id]).to eq(admin.id) # verifies that that the admin's user ID is stored in the session (proves they're logged in)
                expect(response).to redirect_to(admin_dashboard_path) # verifies that admin is redirected to admin's dashboard after successful login
            end 
        end


        context 'with invalid credentials' do

            it 'fails with nonexistent user' do
                expect(controller).to receive(:find_user_by).and_return(nil)
                
                post :login, params: {email: 'nonexistent@example.com', password: 'secret12', role: 'doctor'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:form) 
                expect(flash[:alert]).to eq('Invalid email or password')
            end

            it 'fails when email is missing' do
                post :login, params: {password: 'secret12', role: 'patient'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:form)
                expect(flash[:alert]).to eq('Invalid email or password')
            end

            it 'fails when password is missing' do
                post :login, params: {email: 'pat@example.com', role: 'admin'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:form)
                expect(flash[:alert]).to eq('Invalid email or password')
            end

            it 'fails when role is missing' do
                post :login, params: {email: 'pat@example.com', password: 'secret12'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:form)
                expect(flash[:alert]).to eq('You must select a role')
            end

        end

    end

    
   describe 'GET #logout' do

     it 'logs out the user' do
        login_admin(true)

        get :logout

        expect(session[:user_id]).to be_nil 
        expect(session[:role]).to be_nil 
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq('Successfully logged out')
     end 

   end


end



