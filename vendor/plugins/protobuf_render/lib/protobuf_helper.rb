module ProtobufHelper
	class ProtobufUtil
		@@proto_base_module = "RateMyCommit::"
		
		def self.to_proto(obj)
			get_proto_from_obj(obj)
		end
		
		def self.get_proto_from_obj(obj)
			#inspect type and make new proto
			class_name = obj.class.name.demodulize
			proto_class_name = @@proto_base_module + class_name
			proto_obj = proto_class_name.constantize.new
			
			#map props
			prop_iterator = obj.kind_of?(ActiveRecord::Base) ? obj.attributes : obj
			
			prop_iterator.each do |key, value|
				
				key = key.camelize(:lower)
				
				if proto_obj.get_field(key)
				
					if value.kind_of?(ActiveRecord::Base)
						proto_obj[key] = self.to_proto(value)
					elsif value.kind_of?(Array)
						proto_obj[key] = get_proto_from_array(value)			
					elsif value.kind_of?(Hash)
						proto_obj[key] = get_proto_from_hash(value)			
					else
						if value && value != ""  #this may have to change, did empty string check because of type error with proto getting nil
							proto_obj[key] = value
						else
							#nothing to set
						end
							
					end
					
				end
				
			end
			proto_obj
		end
		
		def self.get_proto_from_array(input_array)
			array = []
			input_array.each do |obj|
				if obj.kind_of? ActiveRecord::Base
					array.push(self.to_proto(obj)) 
				else
					array.push(obj) unless obj.nil?
				end
			end
			array
		end
		
		def self.get_proto_from_hash(input_hash)
			#what would this be? can we even do hash/generic object in proto?
		end
		
	end
end