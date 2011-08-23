class ActionController::Base
  cattr_accessor :adminful_data
  def self.adminful(model)
    self.adminful_data = { :model => model }
    nil
  end
end

module ActionDispatch::Routing::Mapper::Scoping
  def adminful(options = {}, &block)
    original_set = @set
    @set = Adminful::RoutesWrapper.new(@set)
    namespace options.delete(:namespace) || Adminful::Options.namespace, &block

  ensure
    # Restore original @set
    @set = original_set
  end
end
