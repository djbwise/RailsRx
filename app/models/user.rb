class User < ActiveRecord::Base
  acts_as_base_object
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :http_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :first_name,
                  :last_name,
                  :authentication_token,
                  :facebook_id,
                  :facebook_access_token,
                  :profile_image,
                  :is_active,
                  :status
   
   
   has_many :group_user_relationships, :dependent => :destroy
   has_many :groups, :through => :group_user_relationships
   has_many :bills
   
   #named_scope :updated_after, lambda {|date| :conditions => ['updated_at > ?', date]}
   #named_scope :updated_after, :conditions => "updated_at >  999999999999999999 "
                  
def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
  data = access_token['extra']['user_hash']
  if user = User.find_by_facebook_id(data["id"])
    user
  else # Create an user with a stub password. 
    User.create!(:email => data["email"], :password => Devise.friendly_token[0,20],:facebook_id => data["id"],:facebook_access_token => access_token['credentials']['token']) 
  end
end

  def member_of_group(group)
    group_user_relationships.find_by_group_id(group)
  end

  def join_group!(group)
    group_user_relationships.create!(:group_id => group.id)
  end

end
