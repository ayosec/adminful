class Adminful::Properties
  cattr_accessor :adapters
  self.adapters = []

  def self.adapt(model)
    adapters.each do |adapter|
      if adapter.can_process?(model)
        return adapter.new(model)
      end
    end

    nil
  end
end
