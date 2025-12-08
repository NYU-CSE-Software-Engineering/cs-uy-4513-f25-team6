require 'rails_helper'

RSpec.describe ClinicEmploymentController, type: :controller do
  let!(:clinic_a) do
    Clinic.create!(
      name:      "ClinA",
      specialty: "Dermatology",
      location:  "New York",
      rating:    4.5
    )
  end

  let!(:clinic_b) do
    Clinic.create!(
      name:      "ClinB",
      specialty: "Dermatology",
      location:  "Boston",
      rating:    5.0
    )
  end

  let!(:doctor) do
    Doctor.create!(
      email:    "drsmith@example.com",
      username: "dr_smith",
      password: "a" * 32
    )
  end

  def log_in_as_doctor
    session[:user_id] = doctor.id
    session[:role]    = "doctor"
  end

  describe "GET #index" do
    context "when not logged in as a doctor" do
      it "redirects to login with an alert" do
        get :index

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in as a doctor to access this page")
      end
    end

    context "when logged in as a doctor" do
      before do
        log_in_as_doctor
        get :index
      end

      it "responds successfully" do
        expect(response).to have_http_status(:ok)
      end

      it "assigns all clinics" do
        expect(assigns(:clinics)).to match_array([clinic_a, clinic_b])
      end

      it "assigns the current doctor" do
        expect(assigns(:doctor)).to eq(doctor)
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe "POST #create" do
    context "when not logged in as a doctor" do
      it "redirects to login with an alert" do
        post :create, params: { clinic_id: clinic_a.id }

        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in as a doctor to access this page")
      end
    end

    context "when logged in as a doctor" do
      before { log_in_as_doctor }

      context "and the doctor is not yet employed at the clinic" do
        it "assigns the clinic to the doctor" do
          expect {
            post :create, params: { clinic_id: clinic_a.id }
          }.to change { doctor.reload.clinic }.from(nil).to(clinic_a)
        end

        it "sets a success notice and redirects back to clinic employment" do
          post :create, params: { clinic_id: clinic_a.id }

          expect(response).to redirect_to(clinic_employment_path)
          expect(flash[:notice]).to eq("You are now employed at ClinA")
        end
      end

      context "and the doctor is already employed at the clinic" do
        before do
          doctor.update!(clinic: clinic_a)
        end

        it "does not change the doctor’s clinic" do
          expect {
            post :create, params: { clinic_id: clinic_a.id }
          }.not_to change { doctor.reload.clinic_id }
        end

        it "sets an alert and redirects back to clinic employment" do
          post :create, params: { clinic_id: clinic_a.id }

          expect(response).to redirect_to(clinic_employment_path)
          expect(flash[:alert]).to eq("You are already employed at this clinic")
        end
      end
    end
  end
end
