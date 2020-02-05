class ApplicationController < ActionController::Base
  # before_action :basic

  include SessionsHelper

  # def basic
  #   authenticate_or_request_with_http_basic('BA') do |name, password|
  #     name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASSWORD']
  #   end
  # end
end
