class AppointmentsController < ApplicationController

  def index
    unless session[:user_id]
      flash[:alert] = "You are not authorized to view this page."
      redirect_to login_path
      return
    end

    is_doctor = defined?(Doctor) && Doctor.exists?(session[:user_id])

    if is_doctor
      # Logic for Doctor
      @appointments = Appointment.includes(:time_slot, :patient)
                                 .where(time_slots: { doctor_id: session[:user_id] })

      if params[:status].present? && params[:status] != "All Statuses"
        @appointments = @appointments.where(status: params[:status])
      end

    elsif Appointment.respond_to?(:includes) && Appointment.respond_to?(:where)
      # Logic for Patient
      @appointments = Appointment.includes(:time_slot, :doctor)
                                 .where(patient_id: session[:user_id])
    else
      @appointments = []
    end
  end

  def create
    slot = TimeSlot.find(params.dig(:appointment, :time_slot_id))
    date = params.dig(:appointment, :date)

    if Appointment.exists?(time_slot: slot)
      redirect_to doctor_time_slots_path(slot.doctor.id), alert: "Time slot no longer available"
      return
    end

    Appointment.create!(patient_id: session[:user_id], time_slot: slot, date: date)
    redirect_to patient_appointments_path, notice: "Appointment confirmed"
  end

end