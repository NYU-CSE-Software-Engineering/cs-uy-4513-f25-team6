class BillsController < ApplicationController
  before_action :set_bill

  def show
  end

  def update
    if @bill.update(status: "paid")
      redirect_to billing_path(@bill), notice: "Bill paid successfully"
    else
      flash.now[:alert] = "Unable to update bill"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_bill
    @bill = Bill.joins(appointment: :patient)
                .where(patients: { id: session[:user_id] })
                .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Unauthorized access"
  end
end
