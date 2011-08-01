class ActionController::Base
  cattr_accessor :adminful_data
  def self.adminful(model)
    self.adminful_data = { :model => model }
    nil
  end
end

module ActionDispatch::Routing::Mapper::Scoping
  def adminful(options={})
    options[Adminful::SNEAK_PARAM_NAME] = true

    scope(options) do
      namespace(options.delete(:namespace) || Adminful::Options.namespace) do
        yield
     end
    end
  end
end
