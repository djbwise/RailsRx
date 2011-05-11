# ProtobufRender
ActionController::Renderers.add :protobuf do |args|
	
	obj = args[0]
	logger.info "<<<///////<<<< rendering some proto buffing action"
	
	if obj.kind_of? Protobuf::Message
		logger.info obj.to_yaml
		send_data(obj.serialize_to_string, {:type => "application/x-protobuf", :disposition => 'inline'})
  elsif obj
 		logger.info "Converting ActiveRecord or custom obj to proto object"
 		proto_obj = ProtobufHelper::ProtobufUtil.to_proto(obj)
		send_data(proto_obj.serialize_to_string, {:type => "application/x-protobuf", :disposition => 'inline'})
 	else
 		logger.info "obj to protobuf is nil"
		send_data("", {:type => headers['Content-Type'], :disposition => 'inline'})
	end
	
end
