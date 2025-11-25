class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def check_login(roles)
    if (!session[:user_id] || !roles.include?(session[:role]))
      redirect_to login_path, alert: "This page or action requires you to be logged in as: #{roles}"
    end
  end
end
