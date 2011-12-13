class OauthApplicationsController < ApplicationController
  before_filter :login_required
  before_filter :get_oauth_application, :only => [:show, :edit, :update, :destroy]

  def index
    @oauth_applications = current_user.oauth_applications
    @tokens = current_user.tokens.find :all, :conditions => 'oauth_tokens.invalidated_at is null and oauth_tokens.authorized_at is not null'
  end

  def new
    @oauth_application = OauthApplication.new
  end

  def create
    @oauth_application = current_user.oauth_applications.build(params[:oauth_application])
    if @oauth_application.save
      flash[:notice] = "Registered the information successfully"
      redirect_to :action => "show", :id => @oauth_application.id
    else
      render :action => "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @oauth_application.update_attributes(params[:oauth_application])
      flash[:notice] = "Updated the client information successfully"
      redirect_to :action => "show", :id => @oauth_application.id
    else
      render :action => "edit"
    end
  end

  def destroy
    @oauth_application.destroy
    flash[:notice] = "Destroyed the client application registration"
    redirect_to :action => "index"
  end

  private
  def get_oauth_application
    unless @oauth_application = current_user.oauth_applications.find(params[:id])
      flash.now[:error] = "Wrong application id"
      raise ActiveRecord::RecordNotFound
    end
  end
end
