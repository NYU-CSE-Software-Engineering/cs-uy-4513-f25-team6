class BillsController < ApplicationController
  before_action { check_login ['patient'] }
  before_action :set_bill
  before_action :authorize_bill!

  def show
    return if performed?
  end

  def pay
    return if performed?

    if @bill.paid?
      redirect_to patient_bill_path(@bill), alert: "This bill is already paid"
      return
    end

    unless valid_card_params?
      flash.now[:alert] = "Please enter a valid card number"
      render :show, status: :unprocessable_entity
      return
    end

    @bill.mark_paid!
    redirect_to patient_bill_path(@bill), notice: "Payment successful"
  end

  private

  def set_bill
    @bill = Bill.includes(appointment: :time_slot).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to patient_dashboard_path, alert: "Bill not found"
  end

  def authorize_bill!
    return if performed?

    if @bill.patient_id != session[:user_id]
      redirect_to patient_dashboard_path, alert: "You are not authorized to access this bill"
    end
  end

  def valid_card_params?
    card_number = params.dig(:payment, :card_number).to_s.gsub(/\s+/, "")
    exp_month   = params.dig(:payment, :exp_month).to_s
    exp_year    = params.dig(:payment, :exp_year).to_s
    cvc         = params.dig(:payment, :cvc).to_s

    return false if card_number.blank? || card_number !~ /\A\d{12,19}\z/
    return false if exp_month.blank? || exp_year.blank? || cvc.blank?

    true
  end
end
