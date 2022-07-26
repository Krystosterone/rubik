# frozen_string_literal: true

class FaqsController < ApplicationController
  delegate :contributors, to: "Rails.application.config.x"

  def show
    @contributors = contributors
  end
end
