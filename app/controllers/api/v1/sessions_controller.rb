class Api::SessionsController < Api::BaseController
  prepend_before_filter :require_no_authentication, :only => [:create ]
  include Devise::Controllers::InternalHelpers

  def create
    build_resource
    resource = User.find_for_database_authentication(:login=>params[:user_login][:login])
    if resource.nil?
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end

    if resource.valid_password?(params[:user_login][:password])
      sign_in("user", resource)
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
    else
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end