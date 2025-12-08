class DoctorsController < ApplicationController
  # Only doctor role is required for updating employment
  before_action only: [:update] do
    check_login ['doctor']
  end

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
      render :new
      return
    end

    filtered[:password] = Digest::MD5.hexdigest(filtered[:password])
    @new_doctor = Doctor.new(filtered)

    if @new_doctor.valid?
      @new_doctor.save
      session[:user_id] = @new_doctor.id
      session[:role]    = 'doctor'
      flash[:notice]    = 'Doctor account created'
      redirect_to doctor_dashboard_path
    else
      flash[:alert] = 'Invalid account details: ' + @new_doctor.errors.full_messages.to_s
      render :new
    end
  end

  def update
    doctor = Doctor.find(params[:id])
    clinic = Clinic.find(params[:clinic_id])

    if doctor.clinic == clinic
      flash[:alert] = "You are already employed at this clinic"
    else
      if doctor.update(clinic: clinic)
        flash[:notice] = "You are now employed at #{clinic.name}"
      else
        flash[:alert] = "Unable to sign up for clinic"
      end
    end

    redirect_to clinics_path
  end
end
