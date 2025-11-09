class AppointmentsController < ApplicationController

  def create
    slot   = TimeSlot.find(params.dig(:appointment, :time_slot_id))
    doctor = slot.doctor

    if Appointment.exists?(time_slot_id: slot.id)
      redirect_to doctor_time_slots_path(doctor.id), alert: "Time slot no longer available"
      return
    end

    Appointment.create!(patient_id: session[:user_id], time_slot: slot, date: params.dig(:appointment, :date))
    redirect_to patient_appointments_path, notice: "Appointment confirmed"
  end

  def index
    render inline: "<h1>My Appointments</h1><p><%= flash[:notice] %></p>"
  end
end
