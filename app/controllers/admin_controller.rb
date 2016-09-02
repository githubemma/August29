class AdminController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @admins = Admin.all
  end

  def save_admin
    @response = {}

    data = {
        email: params[:email],
        password: params[:password]
    }

    if params[:admin_id].present? #Update
      admin = Admin.find_by(id: params[:admin_id])
      admin.update(data)
      @response['admin'] = admin
    elsif params[:email].present? # Insert
      admin = Admin.create(data)
      @response['new'] = true
      @response['admin'] = admin
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

  def delete_admin
    @response = {}

    if params[:admin_id].present?
      admin = Admin.find_by(id: params[:admin_id])
      if admin
        admin.destroy
        @response['admin_id'] = params[:admin_id]
      end
    end

    respond_to do |format|
      format.json { render :json => @response }
    end
  end

end
