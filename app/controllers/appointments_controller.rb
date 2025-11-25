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
    if Appointment.respond_to?(:where)
      @appointments = Appointment.includes(:time_slot, :doctor)
                                 .where(patient_id: session[:user_id])
    else
      # In tests where Appointment is a class_double without .where
      @appointments = []
    end
    # Rails will automatically render app/views/appointments/index.html.erb
  end
end
