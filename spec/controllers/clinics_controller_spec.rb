require 'rails_helper'

RSpec.describe ClinicsController, type: :controller do
    

    describe 'GET #index' do # start testing the GET #index action in the ClinicsController
        
        context 'when user is signed in as a patient' do # start of context block: all scenarios here are for signed in patients

            before do # run `before` each test scenario in this context block
                @patient = FactoryBot.create(:patient)
                session[:user_id] = @patient.id
                session[:user_type] = 'patient'
            end
            
            # this is testing a scenario of the GET #index action in the ClinicsController --- it should render the index template
            it 'renders the index template' do
                get :index # simulate a GET request to the ClinicsController#index action
                expect(response).to render_template(:index) # expectation: the response should render the `index` view template
            end

            it 'returns http success' do
                get :index # simulate a GET request to the ClinicsController#index action
                expect(response).to have_http_status(:success) # expectation: the http response status should be :success (200 OK)
            end
        end # end of context block: all scenarios here are for signed in patients

        
        context 'when user is not signed in' do # start of context block: all scenarios here are for unsigned in users
            
            # this is testing a scenario of the GET #index action in the ClinicsController --- it should redirect to the login page
            it 'redirects to the login page' do
                get :index # simulate a GET request to the ClinicsController#index action
                expect(response).to redirect_to(login_path) # expectation: the response should redirect to the login page
            end
        end # end of context block: all scenarios here are for unsigned in users

    end # end of testing the GET #index action in the ClinicsController


    describe 'GET #search' do # start testing the GET #search action in the ClinicsController
        
        before do
            @patient = FactoryBot.create(:patient)
            session[:user_id] = @patient.id
            session[:user_type] = 'patient'

            @clinic1 = Clinic.create!(name: "NYC Dermatology", specialty: "Dermatology", location: "New York", rating: 4.5)
            @clinic2 = Clinic.create!(name: "LA Dermatology", specialty: "Dermatology", location: "Los Angeles", rating: 4.0)
        end

        context 'with valid search parameters' do

            it 'returns matching clinics' do
                get :search, params: {specialty: "Dermatology", location: "New York"}
                expect(assigns(:clinics)).to include(@clinic1)
                expect(assigns(:clinics)).not_to include(@clinic2)
            end
        end

        context 'with missing search parameters' do

            it 'shows an error message when both are missing' do
                get :search, params: { specialty: "", location: ""}
                expect(flash[:alert]).to be_present
            end
        end

        context 'sorting by rating' do

            it 'returns clinics sorted by rating when sort param is provided' do
                get :search, params: { sort: "rating" }
                clinics = assigns(:clinics).to_a
                expect(clinics.first.rating).to be >= clinics.last.rating
            end
        end
    end # end of testing the GET #search action in the ClinicsController


end







        

