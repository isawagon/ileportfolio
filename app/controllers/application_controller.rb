class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:about]
  # skip_before_action :verify_authenticity_token
end
