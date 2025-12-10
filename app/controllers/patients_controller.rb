class PatientsController < ApplicationController
    def new
    end

    def create
        begin
            filtered = params.expect(patient: [:email, :username, :password, :age, :height, :gender])
        rescue ActionController::ParameterMissing
            flash[:alert] = 'Missing required information'
            render :new
            return
        end

        filtered[:password] = Digest::MD5.hexdigest(filtered[:password])
        @new_patient = Patient.new(filtered)

        if (@new_patient.valid?)
            @new_patient.save
            flash[:notice] = 'Patient account created, please log in'
            redirect_to login_path
            return
        else
            flash[:alert] = 'Invalid account details: '+@new_patient.errors.full_messages.to_s
            render :new
            return
        end
    end
end