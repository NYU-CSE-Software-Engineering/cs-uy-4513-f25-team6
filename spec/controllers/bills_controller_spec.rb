require "rails_helper"

RSpec.describe BillsController, type: :controller do
  let(:patient) { FactoryBot.create(:patient) }
  let(:other_patient) { FactoryBot.create(:patient) }

  let(:appointment) { FactoryBot.create(:appointment, patient: patient) }
  let(:bill) { FactoryBot.create(:bill, patient: patient, appointment: appointment, amount_cents: 2500) }

  before do
    session[:user_id] = patient.id
    session[:role] = 'patient'
  end

  describe "GET #show" do
    it "allows the owner to view their bill" do
      get :show, params: { id: bill.id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:bill)).to eq(bill)
    end

    it "blocks access to someone else's bill" do
      other_bill = FactoryBot.create(:bill, patient: other_patient, appointment: FactoryBot.create(:appointment, patient: other_patient))
      get :show, params: { id: other_bill.id }
      expect(response).to redirect_to(patient_dashboard_path)
      expect(flash[:alert]).to match(/not authorized/)
    end
  end

  describe "POST #pay" do
    it "marks the bill as paid with valid card info" do
      post :pay, params: { id: bill.id, payment: { card_number: "4242424242424242", exp_month: "12", exp_year: "2030", cvc: "123" } }
      expect(response).to redirect_to(patient_bill_path(bill))
      expect(flash[:notice]).to eq("Payment successful")
      expect(bill.reload).to be_paid
    end

    it "rejects invalid card info" do
      post :pay, params: { id: bill.id, payment: { card_number: "", exp_month: "", exp_year: "", cvc: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("Please enter a valid card number")
      expect(bill.reload).not_to be_paid
    end

    it "prevents double payment" do
      bill.update!(status: "paid", paid_at: Time.current)
      post :pay, params: { id: bill.id, payment: { card_number: "4242424242424242", exp_month: "12", exp_year: "2030", cvc: "123" } }
      expect(response).to redirect_to(patient_bill_path(bill))
      expect(flash[:alert]).to eq("This bill is already paid")
    end
  end
end
