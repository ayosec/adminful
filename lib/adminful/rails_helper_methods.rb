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

    if Adminful::Options.prefix_resources
      options[:path] ||= Adminful::Options.path
    end

    scope(options) { yield }
  end
end
