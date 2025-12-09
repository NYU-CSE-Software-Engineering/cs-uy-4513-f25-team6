class PrescriptionsController < ApplicationController
  before_action(only: [:patient_index]) { check_login ['patient'] }
  before_action(only: [:doctor_index, :create]) { check_login ['doctor'] }

  # GET /patient/prescriptions
  # Patients see their own prescriptions
  def patient_index
    @prescriptions = Prescription.where(patient_id: session[:user_id])
                                 .by_status(params[:status])
                                 .recent_first
                                 .includes(:doctor)

    @filter_applied = params[:status].present?
    @current_status = params[:status]
  end

  # GET /doctor/prescriptions
  # Doctors can view all patients and their prescriptions
  def doctor_index
    @patients = Patient.all.order(:username)

    if params[:patient_id].present?
      @selected_patient = Patient.find_by(id: params[:patient_id])
      @prescriptions = @selected_patient&.prescriptions&.recent_first&.includes(:doctor) || []
    end
  end

  # POST /doctor/prescriptions
  # Doctors create prescriptions for patients
  def create
    @prescription = Prescription.new(prescription_params)
    @prescription.doctor_id = session[:user_id]
    @prescription.issued_on ||= Date.today

    if @prescription.save
      redirect_to doctor_prescriptions_path(patient_id: @prescription.patient_id),
                  notice: "Prescription created successfully"
    else
      @patients = Patient.all.order(:username)
      @selected_patient = Patient.find_by(id: @prescription.patient_id)
      @prescriptions = @selected_patient&.prescriptions&.recent_first&.includes(:doctor) || []
      flash.now[:alert] = "Failed to create prescription: #{@prescription.errors.full_messages.join(', ')}"
      render :doctor_index
    end
  end

  private

  def prescription_params
    params.require(:prescription).permit(:patient_id, :medication_name, :dosage, :instructions, :status)
  end
end

