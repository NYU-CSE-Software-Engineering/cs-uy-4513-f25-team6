require 'rails_helper'

RSpec.describe PrescriptionsController, type: :controller do
    let(:pat1) { FactoryBot.create(:patient) }
    let(:pat2) { FactoryBot.create(:patient) }
    let(:doc1) { FactoryBot.create(:doctor) }
    let(:doc2) { FactoryBot.create(:doctor) }
    let(:pres1) { Prescription.create!(patient: pat1, doctor: doc1, medication_name: 'med1', issued_on: '2025-01-01', status: 'active') }
    let(:pres2) { Prescription.create!(patient: pat1, doctor: doc2, medication_name: 'med2', issued_on: '2025-01-01', status: 'active') }
    let(:pres3) { Prescription.create!(patient: pat2, doctor: doc1, medication_name: 'med3', issued_on: '2025-01-01', status: 'active') }
    let(:pres4) { Prescription.create!(patient: pat2, doctor: doc2, medication_name: 'med4', issued_on: '2025-01-01', status: 'active') }
    
    describe 'GET #patient_index' do
        context 'when logged in as patient' do
            before :each do
                session[:user_id] = pat1.id
                session[:role] = 'patient'
                get :patient_index
            end

            it 'assigns the current patient\'s prescriptions' do
                expect(assigns(:prescriptions)).to match_array([pres1, pres2])
                expect(assigns(:prescriptions)).not_to include(pres3, pres4)
            end

            it 'renders the patient_index template' do
                expect(response).to have_http_status(:ok)
                expect(response).to render_template(:patient_index)
            end
        end

        it 'redirects when not logged in as patient' do
            get :patient_index
            expect(response).to redirect_to(login_path)
            login_doctor(true)
            get :patient_index
            expect(response).to redirect_to(login_path)
            login_admin(true)
            get :patient_index
            expect(response).to redirect_to(login_path)
        end
    end

    describe 'GET #doctor_index' do
        context 'when logged in as doctor' do
            before :each do
                session[:user_id] = doc1.id
                session[:role] = 'doctor'
            end

            it 'finds the current doctor\'s patients' do
                expect(subject).to receive(:find_patients_of).with(doc1).and_return([pat1, pat2])
                get :doctor_index
            end

            it 'loads prescriptions for the selected patient if present' do
                expect(Patient).to receive(:find).with(pat2.id.to_s).and_return(pat2)
                expect(pat2).to receive_message_chain(:prescriptions, :recent_first, :includes)
                
                get :doctor_index, params: { patient_id: pat2.id }
            end

            it 'renders the doctor_index template' do
                get :doctor_index
                expect(response).to have_http_status(:ok)
                expect(response).to render_template(:doctor_index)
            end
        end

        it 'redirects when not logged in as doctor' do
            get :doctor_index
            expect(response).to redirect_to(login_path)
            login_patient(true)
            get :doctor_index
            expect(response).to redirect_to(login_path)
            login_admin(true)
            get :doctor_index
            expect(response).to redirect_to(login_path)
        end
    end

    describe 'POST #create' do
        context 'when logged in as doctor' do
            before :each do
                login_doctor(true)
            end

            it 'creates a new prescription with valid parameters' do
                params = {patient_id: pat1.id, medication_name: 'newMed', status: 'active'}
                pres = instance_double('Prescription', patient_id: pat1.id)

                expect(Prescription).to receive(:new).and_return(pres)
                expect(pres).to receive(:doctor_id=)
                expect(pres).to receive(:issued_on)
                expect(pres).to receive(:issued_on=)
                expect(pres).to receive(:save).and_return(true)

                post :create, params: {prescription: params}

                expect(response).to redirect_to(doctor_prescriptions_path(patient_id: pat1.id))
            end

            it 'rerenders #doctor_index with invalid parameters' do
                pres = instance_double('Prescription')

                expect(Prescription).to receive(:new).and_return(pres)
                expect(pres).to receive(:doctor_id=)
                expect(pres).to receive(:issued_on)
                expect(pres).to receive(:issued_on=)
                expect(pres).to receive(:save).and_return(false)
                
                expect(subject).to receive(:find_patients_of).and_return([])
                expect(pres).to receive(:patient_id)
                expect(Patient).to receive(:find_by).and_return(nil)
                expect(pres).to receive_message_chain(:errors, :full_messages, :join)

                post :create, params: {prescription: {patient_id: pat2.id}}

                expect(response).to render_template(:doctor_index)
            end
        end

        it 'redirects when not logged in as doctor' do
            get :doctor_index
            expect(response).to redirect_to(login_path)
            login_patient(true)
            get :doctor_index
            expect(response).to redirect_to(login_path)
            login_admin(true)
            get :doctor_index
            expect(response).to redirect_to(login_path)
        end
    end

    describe 'PATCH #update' do
        context 'when logged in as doctor' do
            before :each do
                login_doctor(true)
            end

            it 'saves prescription with valid new status' do
                expect(Prescription).to receive(:find).with(pres1.id.to_s).and_return(pres1)
                expect(pres1).to receive(:status=)
                expect(pres1).to receive(:valid?).and_return(true)
                expect(pres1).to receive(:save)

                patch :update, params: {id: pres1.id, status: 'expired'}

                expect(pres1).to receive(:patient_id).and_call_original
                expect(response).to redirect_to(doctor_prescriptions_path(patient_id: pres1.patient_id))
            end

            it 'does not save prescription with invalid new status' do
                expect(Prescription).to receive(:find).with(pres1.id.to_s).and_return(pres1)
                expect(pres1).to receive(:status=)
                expect(pres1).to receive(:valid?).and_return(false)
                expect(pres1).not_to receive(:save)
                expect(pres1).to receive_message_chain(:errors, :to_json)

                patch :update, params: {id: pres1.id, status: 'hurgus'}

                expect(pres1).to receive(:patient_id).and_call_original
                expect(response).to redirect_to(doctor_prescriptions_path(patient_id: pres1.patient_id))
            end
        end

        it 'redirects when not logged in as doctor' do
            get :doctor_index
            expect(response).to redirect_to(login_path)
            login_patient(true)
            get :doctor_index
            expect(response).to redirect_to(login_path)
            login_admin(true)
            get :doctor_index
            expect(response).to redirect_to(login_path)
        end
    end
end