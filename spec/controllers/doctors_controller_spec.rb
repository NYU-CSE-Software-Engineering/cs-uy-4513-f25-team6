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

  describe "GET #index" do
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
end
