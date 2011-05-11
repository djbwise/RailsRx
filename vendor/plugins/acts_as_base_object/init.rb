# Include hook code here
require 'acts_as_base_object.rb'

ActiveRecord::Base.class_eval do
  include BaseObject
end
