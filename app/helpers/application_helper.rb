# frozen_string_literal: true

module ApplicationHelper

  def current_year
    @current_year ||= Date.today.year
  end
end
