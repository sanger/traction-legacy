# frozen_string_literal: true

# See ../messages.rb
module Messages
  # Base message class. Inherited subclasses should set a key
  # and provide a content method which describes the main body
  # of the message in hash format.
  # eg.
  #
  # class Messages::MyMessage < Messages::Base
  #   self.key = 'my_message'
  #
  #   def content
  #     {
  #       key_a: resource.key_a,
  #     }
  #   end
  # end
  class Base
    class_attribute :key

    attr_reader :resource, :timestamp

    def initialize(resource)
      @resource = resource
      @timestamp = Time.current
    end

    def routing_key
      "#{Rails.env}.message.#{key}.#{resource.id}"
    end

    def payload
      {
        key => content,
        'lims' => LIMS_ID
      }.to_json
    end
  end
end
