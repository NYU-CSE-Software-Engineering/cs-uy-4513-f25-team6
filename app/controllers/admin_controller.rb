

class AdminController < ApplicationController
    def dashboard
        @user = Admin.find(session[:user_id])
    end
end