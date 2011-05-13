Rails.application.config.middleware.use OmniAuth::Builder do  
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'  
  provider :facebook, '3ad2592bbb72dda67874018569cd8a86', '2113644d35de08f2fc149a40644f42a3'
  #provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'  
end 