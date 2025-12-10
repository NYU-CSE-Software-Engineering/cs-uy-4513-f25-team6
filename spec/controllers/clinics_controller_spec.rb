require 'rails_helper'

RSpec.describe ClinicsController, type: :controller do
    

    describe 'GET #index' do # start testing the GET #index action in the ClinicsController
        
        context 'when user is signed in as a patient' do # start of context block: all scenarios here are for signed in patients

            before :each do # run `before` each test scenario in this context block
                @patient = login_patient(true)
                @clinic1 = Clinic.create!(name: "NYC Dermatology", specialty: "Dermatology", location: "New York", rating: 4.5)
                @clinic2 = Clinic.create!(name: "LA Dermatology", specialty: "Dermatology", location: "Los Angeles", rating: 4.0)
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

            it 'returns matching clinics' do
                get :index, params: {specialty: "Dermatology", location: "New York"}
                expect(assigns(:clinics)).to include(@clinic1)
                expect(assigns(:clinics)).not_to include(@clinic2)
            end

            it 'returns clinics sorted by rating when sort param is provided' do
                get :index, params: { sort: "rating" }
                clinics = assigns(:clinics).to_a
                expect(clinics.first.rating).to be >= clinics.last.rating
            end

        end # end of context block: all scenarios here are for signed in patients

    end # end of testing the GET #index action in the ClinicsController

    describe 'POST #create' do
        it 'creates a new clinic with valid details' do
            login_admin(true)
            new_clin = {name: 'fakeClin', specialty: 'spec', location: 'loc', rating: 4.2}

            post :create, params: {clinic: new_clin}

            expect(Clinic.exists?(new_clin)).to be_truthy
            expect(response).to redirect_to(admin_dashboard_path)
        end

        it 'does not create a new clinic with missing details' do
            login_admin(true)
            bad_clin = {name: 'badClin', rating: 4.2}
            pre_count = Clinic.count

            post :create, params: {clinic: bad_clin}

            expect(Clinic.count).to eq(pre_count)
            expect(response).to redirect_to(admin_dashboard_path)
        end

        it 'does not create a new clinic when not an admin' do
            new_clin = {name: 'fakeClin', specialty: 'spec', location: 'loc', rating: 4.2}

            post :create, params: {clinic: new_clin}

            expect(Clinic.exists?(new_clin)).to be_falsy
            expect(response).to redirect_to(login_path)
        end
    end
end







        

