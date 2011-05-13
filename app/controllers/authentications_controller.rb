class AuthenticationsController < ApplicationController
  def index
  end
  
  def create
    #current_user.authentications.create(:provider => auth ['provider'], :uid => auth['uid'], :token => auth['credentials']['auth_token'])  
    omniauth = request.env["omniauth.auth"]  
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])  
    if authentication  
      flash[:notice] = "Signed in successfully."  
      sign_in_and_redirect(:user, authentication.user)  
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])  
      flash[:notice] = "Authentication successful."  
      redirect_to authentications_url 
    else
      user = User.new  
      user.apply_omniauth(omniauth) 
      logger.info user.to_yaml
      if user.save  
        flash[:notice] = "Signed in successfully."  
        sign_in_and_redirect(:user, user)  
      else  
        session[:omniauth] = omniauth.except('extra')  
        redirect_to new_user_registration_url
      end 
    end  
  end
  
  def destroy
    
  end
end
