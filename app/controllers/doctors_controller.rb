class DoctorsController < ApplicationController
    def index
        @id = params[:cl_id]
        @doctors = Clinic.find(params[:clinic_id]).doctors
    end

    def new
    end

    def create
        begin
            filtered = params.expect(doctor: [:email, :username, :password, :specialty, :phone])
        rescue ActionController::ParameterMissing
            flash[:alert] = 'Missing required information'
            redirect_to new_doctor_path
            return
        end

        filtered[:password] = Digest::MD5.hexdigest(filtered[:password])
        @new_doctor = Doctor.new(filtered)

        if (@new_doctor.valid?)
            @new_doctor.save
            session[:user_id] = @new_doctor.id
            session[:role] = 'doctor'
            flash[:notice] = 'Doctor account created'
            redirect_to doctor_dashboard_path
            return
        else
            flash[:alert] = 'Invalid account details: '+@new_doctor.errors.full_messages.to_s
            redirect_to new_doctor_path
            return
        end
    end
end