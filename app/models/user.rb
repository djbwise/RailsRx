class User < ActiveRecord::Base
  has_many :authentications
    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
                  :password,
                  :password_confirmation,
                  :first_name,
                  :last_name,
                  :authentication_token
   
  def apply_omniauth(omniauth)
    self.password = Devise.friendly_token[0,20]
    self.email = omniauth['user_info']['email']
    
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token']) 
  end
  
  def password_required?  
    (authentications.empty? || (!password.blank? && authentications.empty?)) && super  
  end 
  
end
