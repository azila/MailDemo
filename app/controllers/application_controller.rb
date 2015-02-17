require 'mailchimp'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :setup_mcapi

  def setup_mcapi
    @mc = Mailchimp::API.new('6772113f67bf7b7464d4ad034e2506d5-us10')
  end
end
