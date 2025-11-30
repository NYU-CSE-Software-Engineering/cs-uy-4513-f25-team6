class AppointmentsController < ApplicationController

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

  def index
    # Check if the logged-in user is a Doctor
    is_doctor = defined?(Doctor) && Doctor.exists?(session[:user_id])

    if is_doctor
      # Logic for Doctor: Find appointments through their time slots
      @appointments = Appointment.includes(:time_slot, :patient)
                                 .where(time_slots: { doctor_id: session[:user_id] })
    elsif Appointment.respond_to?(:includes) && Appointment.respond_to?(:where)
      # Logic for Patient: Find appointments by patient_id
      @appointments = Appointment.includes(:time_slot, :doctor)
                                 .where(patient_id: session[:user_id])
    else
      @appointments = []
    end
    # Rails will automatically render app/views/appointments/index.html.erb
  end
end
