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
end
