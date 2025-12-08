class ClinicEmploymentController < ApplicationController
  before_action :require_doctor!

  def index
    @clinics = Clinic.all
    @doctor  = current_doctor
  end

  def create
    clinic = Clinic.find(params[:clinic_id])

    if current_doctor.clinic == clinic
      flash[:alert] = "You are already employed at this clinic"
    else
      if current_doctor.update(clinic: clinic)
        flash[:notice] = "You are now employed at #{clinic.name}"
      else
        flash[:alert] = "Unable to sign up for clinic"
      end
    end

    redirect_to clinic_employment_path
  end

  private

  def current_doctor
    return nil unless session[:role] == 'doctor' && session[:user_id]

    @current_doctor ||= Doctor.find_by(id: session[:user_id])
  end
  helper_method :current_doctor

  def require_doctor!
    unless current_doctor
      flash[:alert] = "You must be logged in as a doctor to access this page"
      redirect_to login_path
    end
  end
end
