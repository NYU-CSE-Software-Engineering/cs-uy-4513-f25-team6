require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do
  let!(:clinic_ny) do
    Clinic.create!(
      name:      "ClinA",
      specialty: "Dermatology",
      location:  "New York",
      rating:    4.5
    )
  end

  let!(:clinic_boston) do
    Clinic.create!(
      name:      "ClinB",
      specialty: "Dermatology",
      location:  "Boston",
      rating:    5.0
    )
  end

  let!(:doctor_ny) do
    Doctor.create!(
      email:    "nydoc@example.com",
      username: "ny_doc",
      password: "a" * 32,
      clinic:   clinic_ny
    )
  end

  let!(:doctor_boston) do
    Doctor.create!(
      email:    "bosdoc@example.com",
      username: "bos_doc",
      password: "b" * 32,
      clinic:   clinic_boston
    )
  end

  let!(:unemployed_doctor) do
    Doctor.create!(
      email:    "free@example.com",
      username: "free_doc",
      password: "c" * 32,
      clinic:   nil
    )
  end

  describe "GET #index" do
    before do
      session[:user_id] = doctor_ny.id
      session[:role]    = "doctor"
    end

    it "lists only doctors for the given clinic" do
      get :index, params: { clinic_id: clinic_ny.id }

      expect(response).to have_http_status(:ok)
      expect(assigns(:doctors)).to match_array([doctor_ny])
      expect(assigns(:doctors)).not_to include(doctor_boston)
    end

    it "renders the index template" do
      get :index, params: { clinic_id: clinic_ny.id }

      expect(response).to render_template(:index)
    end
  end

  describe "PATCH #update" do
    before do
      session[:user_id] = unemployed_doctor.id
      session[:role]    = "doctor"
    end

    it "assigns the doctor to the given clinic and sets a success notice" do
      patch :update, params: { id: unemployed_doctor.id, clinic_id: clinic_ny.id }

      expect(response).to redirect_to(clinics_path)
      expect(flash[:notice]).to eq("You are now employed at ClinA")
      expect(unemployed_doctor.reload.clinic).to eq(clinic_ny)
    end

    it "does not change clinic if already employed there and sets an alert" do
      unemployed_doctor.update!(clinic: clinic_ny)

      patch :update, params: { id: unemployed_doctor.id, clinic_id: clinic_ny.id }

      expect(response).to redirect_to(clinics_path)
      expect(flash[:alert]).to eq("You are already employed at this clinic")
      expect(unemployed_doctor.reload.clinic).to eq(clinic_ny)
    end

    it "redirects to login if not logged in as a doctor" do
      session[:user_id] = nil
      session[:role]    = nil

      patch :update, params: { id: unemployed_doctor.id, clinic_id: clinic_ny.id }

      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq('This page or action requires you to be logged in as: ["doctor"]')
    end
  end
end
