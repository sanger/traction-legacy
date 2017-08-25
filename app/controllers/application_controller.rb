# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Ensure that the exception notifier is working. It will send an email to the standard email address.
  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end
end
