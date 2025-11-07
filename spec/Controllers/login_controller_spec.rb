require 'rails_helper'
require 'spec_helper'

RSpec.describe LoginController, type: :controller do

    describe 'GET #new' do # creates a test group for the `new` action
                             # Get #new indicates we're testing an HTTP GET request to the `new` action

        it 'renders the login form' do # start of a specific test case1 --- the login form should be rendered when someone visits the login page
            get :new # simulates an HTTP GET request to the `new` action
                       # it's as if a user navigates to the /login in their browswer
            expect(response).to have_http_status(:success) # this assertion checks that the server responded with a successful HTTP status code
            expect(response).to render_template(:new) # this assertion verifies that the controller rendered the correct view template
                                                         # ensuring that the login form is displayed to the user
        end # end of the test case1

        it 'redirects already authenticated users to their dashboards' do # start of a specific test case2 -- the user should be redirected to their dashboard if they are already authenticated (ie logged in)
            patient = create(:user, role: 'patient') # this creates a test user in the database with the role of 'patient'
            allow(controller).to receive(:current_user).and_return(patient) # this simulates the user already being logged in by setting the current_user method to return the test user we created above

            get :new # this simulates the GET request to the `new` action (same as above) but this time with a logged-in user
            expect(response).to redirect_to(patient_dashboard_path) # this assertion checks that the server redirected the already logged-in user to their dashboard instead of showing the login form again
        end
    end


    describe 'POST #submit' do # start a test group for the `create` action (handles the login form submission)
        
        # create test users with different roles for testing
        let!(:patient) { create(:user, email: 'pat@example.com', password: 'secret12', role: 'patient') }
        let!(:doctor) { create(:user, email: 'drsmith@example.com', password: 'secret12', role: 'doctor') }
        let!(:admin) { create(:user, email: 'admin@example.com', password: 'secret12', role: 'admin') }

        
        context 'with valid credentials' do # context start

            it 'patient logs in successfully' do
                post :create, params: {email: 'pat@example.com', password: 'secret12', role: 'patient'} # simulates a POST request to the `create` action with patient's credentials

                expect(session[:user_id]).to eq(patient.id) # verifies that that the patient's user ID is stored in the session (proves they're logged in)
                expect(response).to redirect_to(patient_dashboard_path) # verifies that patient is redirected to patient's dashboard after successful login
            end 

            it 'doctor logs in successfully' do
                post :create, params: {email: 'drsmith@example.com', password: 'secret12', role: 'doctor'}  # simulates a POST request to the `create` action with doctors's credentials


                expect(session[:user_id]).to eq(doctor.id) # verifies that that the doctor's user ID is stored in the session (proves they're logged in)
                expect(response).to redirect_to(doctor_dashboard_path) # verifies that doctor is redirected to doctor's dashboard after successful login
            end 

            it 'admin logs in successfully' do
                post :create, params: {email: 'admin@example.com', password: 'secret12', role: 'admin'} # simulates a POST request to the `create` action with admins's credentials


                expect(session[:user_id]).to eq(admin.id) # verifies that that the admin's user ID is stored in the session (proves they're logged in)
                expect(response).to redirect_to(admin_dashboard_path) # verifies that admin is redirected to admin's dashboard after successful login
            end 
        end # context end



        context 'with invalid credentials' do # context start

            it 'fails with incorrect password' do
                post :create, params: {email: 'pat@example.com', password: 'wrong_password', role: 'patient'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:new) # login failed so we give the user the login form again
                expect(flash[:danger]).to eq('Invalid email or password')
            end

            it 'fails with non-existent email' do
                post :create, params: {email: 'nonexistent@example.com', password: 'secret12', role: 'doctor'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:new) 
                expect(flash[:danger]).to eq('Invalid email or password')
            end

            it 'fails when email is missing' do
                post :create, params: {password: 'secret12', role: 'patient'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:new)
                expect(flash[:danger]).to eq('Invalid email or password')
            end

            it 'fails when password is missing' do
                post :create, params: {email: 'pat@example.com', role: 'admin'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:new)
                expect(flash[:danger]).to eq('Invalid email or password')
            end

            it 'fails when role is missing' do
                post :create, params: {email: 'pat@example.com', password: 'secret12'}

                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:new)
                expect(flash[:danger]).to eq('You must select a role')
            end

            it 'fails when all params are missing' do

                post :create, params: {}


                expect(session[:user_id]).to be_nil
                expect(response).to render_template(:new)
                expect(flash[:danger]).to eq('Invalid email or password')
            end
        end # context end

    end # describe end

    
   describe 'DELETE #exit' do

     let(:user) { create(:user, email: 'test@example.com', password: 'secret12') } # create a test user 

     before do 
        session[:user_id] = user.id # simulates a user being logged in by setting the user ID in the session
     end 


     it 'logs out the user' do
        delete :destroy # simulate the HTTP DELTE request to the destroy action (logout endpoint)

        expect(session[:user_id]).to be_nil 
        expect(response).to redirect_to(root_path) # verify user is redirected to the root path (home page) after logging out
        expect(flash[:info]).to eq('Logged out successfully')
     end 

   end # describe end


end # controller rspec end




