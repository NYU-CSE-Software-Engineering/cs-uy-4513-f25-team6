class DashboardController < ApplicationController
    def patient
    @patient = Patient.find_by(id: session[:user_id])

    if @patient.nil?
      redirect_to login_path, alert: "Please log in first"
      return
    end

    @upcoming_appointments = Appointment
      .includes(:time_slot, :doctor)
      .where(patient_id: @patient.id)
      .order(:date)
    end
    
    def doctor
        @user = Doctor.find(session[:user_id])
    end

    def admin
        @user = Admin.find(session[:user_id])
    end
end