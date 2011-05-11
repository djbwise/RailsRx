# ActsAsBaseObject
module BaseObject
  
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      include InstanceMethods
    end
  end
  
  module ClassMethods
    def acts_as_base_object
      class_eval  <<-DELIM
      
      attr_accessible :created_by,
                      :sync_token,
                      :deleted
                      
      belongs_to :created_by, :class_name => "User", :foreign_key => "created_by"
                        
      def updated_at=(date)
        date = date.is_a?(Numeric) ? date/1000 : date
        super(Time.at(date))
      end

      def updated_at
        (self[:updated_at].to_f * 1000).to_i
      end
      
      def created_at=(date)
        date = date.is_a?(Numeric) ? date/1000 : date
        super(Time.at(date))
      end

      def created_at
        (self[:created_at].to_f * 1000).to_i
      end

      DELIM
    end
  end
  
  module InstanceMethods
    # generic instance methods go here
  end

end