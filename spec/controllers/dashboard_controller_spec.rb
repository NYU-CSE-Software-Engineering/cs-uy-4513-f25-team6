# spec/controllers/dashboard_controller_spec.rb
require "rails_helper"

RSpec.describe DashboardController, type: :controller do
  describe "GET #patient" do
    let(:patient) { FactoryBot.create(:patient) }

    before do
      session[:user_id] = patient.id
      session[:role]    = "patient"
      get :patient
    end

    it "uses @user from ApplicationController and assigns the current patient" do
      expect(assigns(:user)).to eq(patient)
    end

    it "renders the patient template" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:patient)
    end
  end

  describe "GET #doctor" do
    let(:doctor) { FactoryBot.create(:doctor) }

    before do
      session[:user_id] = doctor.id
      session[:role]    = "doctor"  # only if used
      get :doctor
    end

    it "uses @user from ApplicationController and assigns the current doctor" do
      expect(assigns(:user)).to eq(doctor)
    end

    it "renders the doctor template" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:doctor)
    end
  end

  describe "GET #admin" do
    let(:admin) { FactoryBot.create(:admin) }

    before do
      session[:user_id] = admin.id
      session[:role]    = "admin"  # only if used
      get :admin
    end

    it "uses @user from ApplicationController and assigns the current admin" do
      expect(assigns(:user)).to eq(admin)
    end

    it "renders the admin template" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:admin)
    end

  end

  describe "GET #admin with table parameter" do  
    before :each do 
      login_admin(true)
    end

    it 'loads all records from a table that exists' do
      allow(Doctor).to receive(:count) # needed because of line 30

      expect(Doctor).to receive(:<).and_return(true)
      expect(Doctor).to receive(:abstract_class).and_return(false)
      expect(Doctor).to receive(:attribute_names)
      expect(Doctor).to receive(:all)

      get :admin, params: { table: 'Doctor' }
      
      expect(response).to have_http_status(:ok)
    end

    it 'displays an error for a table that does not exist' do
      get :admin, params: { table: 'bongo' }

      expect(response).to have_http_status(:ok)
      expect(flash[:alert]).to eq('The database has no table called \'bongo\'')
    end

    it 'displays an error for a class that is not a table' do
      expect(LoginController).to receive(:<).and_return(false)

      get :admin, params: { table: 'LoginController' }

      expect(response).to have_http_status(:ok)
      expect(flash[:alert]).to eq('The database has no table called \'LoginController\'')
    end
  end
end
