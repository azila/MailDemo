class MoviesController < ApplicationController

  def index
    mailchimp = Mailchimp::API.new(MAILCHIMP-API-KEY)
    
    mailchimp.lists.members(MAILCHIMP-LIST-ID)['data']
    binding.pry
  end

end
