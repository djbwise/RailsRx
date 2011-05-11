
class HomeController < ApplicationController
  before_filter :authenticate_user! unless (Rails.env == "development") 
  
  def index

    #Delayed::Job.enqueue DataLoad.new(Commit.last.id+1)
    #start_rev = (Commit.last) ? Commit.maximum(:revision)+1 : 1
    #DataLoad.new(start_rev).perform
    
    @commit = Commit.where("total_ups > total_downs").limit(1).order((Rails.env == "development") ? "RAND()" : "RANDOM()").first
        
  end
end
