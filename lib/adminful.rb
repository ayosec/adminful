require 'rails/engine'
require 'adminful/rails_helper_methods'

module Adminful

  autoload :Properties, 'adminful/properties'
  autoload :RoutesWrapper, 'adminful/routes_wrapper'

  module Options
    mattr_accessor :namespace
  end

  class Railtie < ::Rails::Engine

    # Add our asset to the pipeline
    #config.assets.precompile << /adminful.(css|js)$/

    config.adminful = Adminful::Options
    config.adminful.namespace = "adminful"

    initializer "add_routing_paths" do
      Adminful.managed_resources = []
    end
  end

  # Resources to be managed with this gem
  mattr_accessor :managed_resources
end
