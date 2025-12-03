class PatientsController < ApplicationController
    def new
    end

    def create
        begin
            filtered = params.expect(patient: [:email, :username, :password, :age, :height, :gender])
        rescue ActionController::ParameterMissing
            flash[:alert] = 'Missing required information'
            redirect_to new_patient_path
            return
        end

        filtered[:password] = Digest::MD5.hexdigest(filtered[:password])
        @new_patient = Patient.new(filtered)

        if (@new_patient.valid?)
            @new_patient.save
            session[:user_id] = @new_patient.id
            session[:role] = 'patient'
            flash[:notice] = 'Patient account created'
            redirect_to patient_dashboard_path
            return
        else
            flash[:alert] = 'Invalid account details: '+@new_patient.errors.full_messages.to_s
            redirect_to new_patient_path
            return
        end
    end
end