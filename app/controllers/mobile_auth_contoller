class MobileAuthController < ApplicationController
  # mobile authentication services...TODO: update facebook authorizing to be generic oauth provider?
  # add this to routes if you are going to use it
  
  def sign_up
    
     if @user = User.find_by_email(params[:email])
        errors = {:error_code => 1, :detail => "User already exists"}
     else
        @user = User.create!(:email => params["email"], :password => params[:password] )
        @user.ensure_authentication_token!
        errors = {:error_code => 0} 
     end
        
    respond_to do |format|
        format.json  { render :json => {:authentication_token => user.authentication_token, :errors => errors } }
    end
  end
  
   def sign_in
     
     user = User.find_by_email(params[:email])
     
     if user && user.valid_password?(params[:password])
       errors = {:error_code => 0}
     else
       errors = {:error_code => 1, :detail => "Invalid username or password"}
       user = nil
     end
       
     respond_to do |format|
        format.json  { render :json => {:authentication_token => user.authentication_token } }
      end
    
  end
  
  def facebook_authorize
    #verify this token by calling graph api
    begin
      fb_user = FbGraph::User.me(params[:fb_auth_token]).fetch
      authentication = Authentications.find_by_uid(fb_user.identifier)
      user = User.find(authentication.user_id) if authentication
      if fb_user && !user
        #create the user?
        user = User.create!(:email => fb_user.email, :password => Devise.friendly_token[0,20])
        user.authentications.create(:provider => "facebook", :uid => fb_user.identifier, :token => params[:fb_auth_token]) 
      end
    rescue
      #auth failed...what to do here?
    end
    
    
    if user
      user.ensure_authentication_token!
      errors = {:error_code => 0}
    else
      errors = {:error_code => 1, :detail => "Invalid authorization"}  
    end
         
    respond_to do |format|
        format.json  { render :json => {:authentication_token => user.authentication_token , :errors => errors} }
        logger.info user.to_yaml
        logger.info errors.to_yaml
    end
    
  end

  def destroy

  end

end
