class AdminsController < ApplicationController
  before_action :authenticate_admin!
  def portal
  end
end
