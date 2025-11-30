require "rails_helper"

RSpec.describe AppointmentsController, type: :controller do
  let(:patient)       { FactoryBot.create(:patient) }
  let(:other_patient) { FactoryBot.create(:patient) }
  let(:doctor)        { FactoryBot.create(:doctor) }

  let(:slot1) do
    FactoryBot.create(
      :time_slot,
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 9, 0),
      ends_at:   Time.utc(2000, 1, 1, 9, 30)
    )
  end

  let(:slot2) do
    FactoryBot.create(
      :time_slot,
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 10, 0),
      ends_at:   Time.utc(2000, 1, 1, 10, 30)
    )
  end

  let(:slot_other) do
    FactoryBot.create(
      :time_slot,
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 11, 0),
      ends_at:   Time.utc(2000, 1, 1, 11, 30)
    )
  end

  let!(:appt1) do
    FactoryBot.create(
      :appointment,
      patient: patient,
      time_slot: slot1,
      date: Date.new(2025, 1, 1)
    )
  end

  let!(:appt2) do
    FactoryBot.create(
      :appointment,
      patient: patient,
      time_slot: slot2,
      date: Date.new(2025, 1, 2)
    )
  end

  let!(:other_appt) do
    FactoryBot.create(
      :appointment,
      patient: other_patient,
      time_slot: slot_other,
      date: Date.new(2025, 1, 3)
    )
  end

  describe "GET #index" do
    before do
      # simulate logged-in patient
      session[:user_id] = patient.id
      get :index
    end

    it "assigns only the current patient's appointments" do
      expect(assigns(:appointments)).to match_array([appt1, appt2])
      expect(assigns(:appointments)).not_to include(other_appt)
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    context "when logged in as a doctor" do
      before do
        # Simulate logged-in doctor (overrides the patient login from the parent block)
        session[:user_id] = doctor.id
        get :index
      end

      it "assigns the doctor's appointments" do
        # appt1 and appt2 belong to 'doctor' defined in your let block
        expect(assigns(:appointments)).to include(appt1, appt2)
      end

      it "does not include appointments for other doctors" do
        # Create a generic appointment for a DIFFERENT doctor to ensure isolation
        other_doctor = FactoryBot.create(:doctor)
        other_slot = FactoryBot.create(:time_slot, doctor: other_doctor)
        other_doc_appt = FactoryBot.create(:appointment, time_slot: other_slot)
        
        expect(assigns(:appointments)).not_to include(other_doc_appt)
      end
    end
  end
end
