class Adminful::Properties
  cattr_accessor :adapters
  self.adapters = []

  def self.inherited(cls)
    adapters << cls
  end

  def self.adapt(model)
    adapters.each do |adapter|
      if adapter.can_process?(model)
        return adapter.new(model)
      end
    end

    nil
  end
end

require 'adminful/properties/mongoid_adapter' if defined?(Mongoid::Document)
