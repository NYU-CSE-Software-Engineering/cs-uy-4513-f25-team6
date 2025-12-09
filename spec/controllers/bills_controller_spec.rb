require 'rails_helper'

RSpec.describe BillsController, type: :controller do
  let(:patient) do
    Patient.create!(
      email: "patient@example.com",
      username: "patient1",
      password: "a" * 32
    )
  end

  let(:other_patient) do
    Patient.create!(
      email: "other@example.com",
      username: "patient2",
      password: "b" * 32
    )
  end

  let(:clinic) do
    FactoryBot.create(:clinic, name: "Test Clinic")
  end

  let(:doctor) do
    Doctor.create!(
      email: "doctor@example.com",
      username: "doctor1",
      password: "b" * 32,
      clinic: clinic
    )
  end

  let(:time_slot) do
    TimeSlot.create!(
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 9, 0, 0),
      ends_at:   Time.utc(2000, 1, 1, 10, 0, 0)
    )
  end

  let(:appointment) do
    Appointment.create!(
      patient: patient,
      time_slot: time_slot,
      date: Date.today
    )
  end

  let(:other_appointment) do
    Appointment.create!(
      patient: other_patient,
      time_slot: time_slot,
      date: Date.today + 1
    )
  end

  let(:bill) do
    Bill.create!(
      appointment: appointment,
      amount: 150.0,
      status: "unpaid",
      due_date: Date.today + 7
    )
  end

  let(:other_bill) do
    Bill.create!(
      appointment: other_appointment,
      amount: 200.0,
      status: "unpaid",
      due_date: Date.today + 7
    )
  end

  describe "GET #show" do
    context "when patient is logged in" do
      before do
        session[:user_id] = patient.id
        session[:role] = 'patient'
      end

      it "assigns the requested bill and renders the show template" do
        get :show, params: { id: bill.id }

        expect(response).to have_http_status(:ok)
        expect(assigns(:bill)).to eq(bill)
        expect(response).to render_template(:show)
      end

      it "redirects with alert when trying to access another patient's bill" do
        get :show, params: { id: other_bill.id }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this bill")
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get :show, params: { id: bill.id }

        expect(response).to redirect_to(login_path)
      end
    end

    context "when logged in as non-patient" do
      before do
        session[:user_id] = doctor.id
        session[:role] = 'doctor'
      end

      it "redirects to login page" do
        get :show, params: { id: bill.id }

        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH #update" do
    context "when patient is logged in" do
      before do
        session[:user_id] = patient.id
        session[:role] = 'patient'
      end

      context "with valid payment information" do
        it "marks the bill as paid and redirects with success notice" do
          patch :update, params: { id: bill.id, card_number: "4242424242424242" }

          bill.reload
          expect(bill.status).to eq("paid")

          expect(response).to redirect_to(billing_path(bill))
          expect(flash[:notice]).to eq("Payment successful")
        end
      end

      context "with invalid payment information" do
        it "does not mark the bill as paid and renders show with error" do
          patch :update, params: { id: bill.id, card_number: "" }

          bill.reload
          expect(bill.status).to eq("unpaid")

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:show)
          expect(flash[:alert]).to eq("Please enter a valid card number")
        end

        it "rejects invalid card number format" do
          patch :update, params: { id: bill.id, card_number: "123" }

          bill.reload
          expect(bill.status).to eq("unpaid")
          expect(flash[:alert]).to eq("Please enter a valid card number")
        end
      end

      context "when bill is already paid" do
        before do
          bill.update!(status: "paid")
        end

        it "does not process payment and shows alert" do
          patch :update, params: { id: bill.id, card_number: "4242424242424242" }

          expect(response).to redirect_to(billing_path(bill))
          expect(flash[:alert]).to eq("This bill is already paid")
        end
      end

      context "when trying to update another patient's bill" do
        it "redirects with unauthorized message" do
          patch :update, params: { id: other_bill.id, card_number: "4242424242424242" }

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq("You are not authorized to access this bill")
        end
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        patch :update, params: { id: bill.id, card_number: "4242424242424242" }

        expect(response).to redirect_to(login_path)
      end
    end
  end
end
