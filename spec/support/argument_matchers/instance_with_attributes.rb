module InstanceWithAttributes
  class InstanceWithAttributes
    def initialize(attributes)
      @attributes = attributes
    end

    def matches?(actual)
      @attributes.all? do |name, value|
        value == actual.public_send(name)
      end
    end
    alias == matches?

    def inspect
      "An instance having attributes #{@attributes}"
    end
  end

  def instance_with_attributes(actual)
    InstanceWithAttributes.new(actual)
  end
end

RSpec.configure { |config| config.include InstanceWithAttributes }
