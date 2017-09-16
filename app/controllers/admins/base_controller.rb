class Admins::BaseController < ApplicationController
  before_action :authenticate!

  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']

  layout 'layouts/admins'
end
