class AdminsController < ApplicationController
    def new
    end

    def create
        begin
            filtered = params.expect(admin: [:email, :username, :password])
        rescue ActionController::ParameterMissing
            flash[:alert] = 'Missing required information'
            redirect_to new_admin_path
            return
        end

        filtered[:password] = Digest::MD5.hexdigest(filtered[:password])
        @new_admin = Admin.new(filtered)

        if (@new_admin.valid?)
            @new_admin.save
            session[:user_id] = @new_admin.id
            session[:role] = 'admin'
            flash[:notice] = 'Admin account created'
            redirect_to admin_dashboard_path
            return
        else
            flash[:alert] = 'Invalid account details: '+@new_admin.errors.full_messages.to_s
            redirect_to new_admin_path
            return
        end
    end
end