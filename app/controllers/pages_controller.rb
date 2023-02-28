class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def about
  end

  def home
  end

end
