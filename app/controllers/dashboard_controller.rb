class DashboardController < ApplicationController
  before_action(only: [:patient]) { check_login ['patient'] }
  before_action(only: [:doctor]) { check_login ['doctor'] }
  before_action(only: [:admin]) { check_login ['admin'] }
  
  def patient
    @appointments = Appointment
                      .joins(:time_slot)
                      .includes(:time_slot, :doctor)
                      .where(patient_id: @user.id)
                      .where('date > ?', Date.yesterday)
                      .order(:date, 'time_slots.starts_at')

    @unpaid_bills = Bill
                      .joins(:appointment)
                      .where(appointments: { patient_id: @user.id }, status: "unpaid")
  end

  def doctor

    @appointments = Appointment
                      .joins(:time_slot)
                      .includes(:patient, :time_slot)
                      .where(time_slots: { doctor_id: @user.id })
                      .order(:date, 'time_slots.starts_at')
  end

  def admin
    @patients_count     = Patient.count
    @doctors_count      = Doctor.count
    @appointments_count = Appointment.count
    @unpaid_bills_count = Bill.where(status: "unpaid").count

    @models = [
      'Patient', 'Doctor', 'Admin', 'Clinic',
      'Bill', 'Appointment', 'Prescription', 'TimeSlot'
    ]
    tableName = params[:table]
    if tableName != nil
      invalid = false

      # make sure it's a real class, and that it's a usable model
      begin
        tableClass = tableName.constantize
        if !(tableClass < ApplicationRecord) || tableClass.abstract_class
          invalid = true
        end
      rescue NameError
        invalid = true
      end
      
      if invalid
        flash[:alert] = "The database has no table called '#{tableName}'"
      else
        @col_names = tableClass.attribute_names
        @rows = tableClass.all
      end
    end
  end
end
