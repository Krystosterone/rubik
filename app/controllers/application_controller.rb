# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :show_navigation

  private

  def show_navigation
    @show_navigation = true
  end
end
