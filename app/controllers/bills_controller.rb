class BillsController < ApplicationController
  before_action :check_patient_login
  before_action :set_bill

  def show
  end

  def update
    if @bill.paid?
      flash[:alert] = "This bill is already paid"
      redirect_to billing_path(@bill)
      return
    end

    if valid_payment_params?
      @bill.mark_as_paid!
      flash[:notice] = "Payment successful"
      redirect_to billing_path(@bill)
    else
      flash.now[:alert] = "Please enter a valid card number"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def check_patient_login
    check_login(['patient'])
  end

  def set_bill
    @bill = Bill.joins(appointment: :patient)
                .where(patients: { id: session[:user_id] })
                .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "You are not authorized to access this bill"
  end

  def valid_payment_params?
    card_number = params[:card_number]&.strip
    return false if card_number.blank?

    # Basic validation: card number should be 13-19 digits
    card_number.match?(/^\d{13,19}$/)
  end
end
