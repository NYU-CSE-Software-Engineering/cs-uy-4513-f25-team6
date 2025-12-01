require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do


    describe 'GET #index' do # start testing the GET #index action in the DoctorsController

        context 'when user is signed in as a patient' do # start of context block: all scenarios here are for signed in patients

            before do # run `before` each test scenario in this context block
                @patient = FactoryBot.create(:patient)
                session[:user_id] = @patient.id
                session[:user_type] = 'patient'

                # Create a clinic with doctors
                @clinic = FactoryBot.create(:clinic, name: "NYC Health Center")
                @doctor1 = FactoryBot.create(:doctor, username: "john_smith", clinic: @clinic)
                @doctor2 = FactoryBot.create(:doctor, username: "jane_doe", clinic: @clinic)
            end

            # Test scenario: it should render the index template
            it 'renders the index template' do
                get :index, params: { clinic_id: @clinic.id } # simulate a GET request to /clinics/:clinic_id/doctors
                expect(response).to render_template(:index) # expectation: the response should render the `index` view template
            end

            # Test scenario: it should return http success
            it 'returns http success' do
                get :index, params: { clinic_id: @clinic.id }
                expect(response).to have_http_status(:success)
            end

            # Test scenario: it should assign doctors belonging to the clinic
            it 'assigns doctors belonging to the clinic' do
                get :index, params: { clinic_id: @clinic.id }
                expect(assigns(:doctors)).to include(@doctor1, @doctor2)
            end

            # Test scenario: it should not include doctors from other clinics
            it 'does not include doctors from other clinics' do
                other_clinic = FactoryBot.create(:clinic, name: "LA Health Center")
                other_doctor = FactoryBot.create(:doctor, clinic: other_clinic)

                get :index, params: { clinic_id: @clinic.id }
                expect(assigns(:doctors)).not_to include(other_doctor)
            end

        end # end of context block: all scenarios here are for signed in patients


        context 'when user is not signed in' do # start of context block: all scenarios here are for unsigned in users

            before do
                @clinic = FactoryBot.create(:clinic, name: "Test Clinic")
            end

            # Test scenario: it should redirect to the login page
            it 'redirects to the login page' do
                get :index, params: { clinic_id: @clinic.id }
                expect(response).to redirect_to(login_path)
            end

        end # end of context block: all scenarios here are for unsigned in users

    end # end of testing the GET #index action in the DoctorsController


    describe 'GET #search' do # start testing the GET #search action in the DoctorsController

        before do
            @patient = FactoryBot.create(:patient)
            session[:user_id] = @patient.id
            session[:user_type] = 'patient'

            # Create a clinic with doctors
            @clinic = FactoryBot.create(:clinic, name: "NYC Health Center")

            @doctor1 = FactoryBot.create(:doctor,
                username: "john_smith",
                specialty: "Physical therapy",
                clinic: @clinic,
                rating: 4.5
            )
            @doctor2 = FactoryBot.create(:doctor,
                username: "jane_doe",
                specialty: "Physical therapy",
                clinic: @clinic,
                rating: 4.0
            )
            @doctor3 = FactoryBot.create(:doctor,
                username: "bob_wilson",
                specialty: "Cardiology",
                clinic: @clinic,
                rating: 3.5
            )
        end

        context 'with valid search parameters' do # start of context block: valid search scenarios

            # Test scenario: search by name and specialty returns matching doctors
            it 'returns doctors matching both name and specialty' do
                get :search, params: { clinic_id: @clinic.id, name: "john", specialty: "Physical therapy" }
                expect(assigns(:doctors)).to include(@doctor1)
                expect(assigns(:doctors)).not_to include(@doctor2, @doctor3)
            end

            # Test scenario: search by name only returns matching doctors
            it 'returns doctors matching only name' do
                get :search, params: { clinic_id: @clinic.id, name: "john", specialty: "" }
                expect(assigns(:doctors)).to include(@doctor1)
                expect(assigns(:doctors)).not_to include(@doctor2, @doctor3)
            end

            # Test scenario: search by specialty only returns matching doctors
            it 'returns doctors matching only specialty' do
                get :search, params: { clinic_id: @clinic.id, name: "", specialty: "Physical therapy" }
                expect(assigns(:doctors)).to include(@doctor1, @doctor2)
                expect(assigns(:doctors)).not_to include(@doctor3)
            end

        end # end of context block: valid search scenarios


        context 'with missing search parameters' do # start of context block: missing parameters scenarios

            # Test scenario: shows error message when both name and specialty are missing
            it 'shows an error message when both are missing' do
                get :search, params: { clinic_id: @clinic.id, name: "", specialty: "" }
                expect(flash[:error]).to be_present
            end

        end # end of context block: missing parameters scenarios


        context 'with non-existent doctor' do # start of context block: no results scenarios

            # Test scenario: shows error message when no doctors match the search
            it 'shows an error message when no doctors are found' do
                get :search, params: { clinic_id: @clinic.id, name: "nonexistent", specialty: "Pediatrics" }
                expect(flash[:error]).to be_present
            end

            # Test scenario: returns empty results when no doctors match
            it 'returns empty results when no doctors match' do
                get :search, params: { clinic_id: @clinic.id, name: "nonexistent", specialty: "Pediatrics" }
                expect(assigns(:doctors)).to be_empty
            end

        end # end of context block: no results scenarios


        context 'sorting by rating' do # start of context block: sorting scenarios

            # Test scenario: returns doctors sorted by rating in descending order
            it 'returns doctors sorted by rating when sort param is provided' do
                get :search, params: { clinic_id: @clinic.id, sort: "rating" }
                doctors = assigns(:doctors).to_a
                expect(doctors.first).to eq(@doctor1)  # highest rating (4.5)
                expect(doctors.last).to eq(@doctor3)   # lowest rating (3.5)
            end

            # Test scenario: sorted doctors should be in descending order
            it 'sorts doctors with highest rating first' do
                get :search, params: { clinic_id: @clinic.id, sort: "rating" }
                doctors = assigns(:doctors).to_a
                expect(doctors.first.rating).to be >= doctors.last.rating
            end

        end # end of context block: sorting scenarios

    end # end of testing the GET #search action in the DoctorsController


end