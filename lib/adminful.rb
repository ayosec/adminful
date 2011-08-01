require 'rails/engine'
require 'adminful/rails_helper_methods'

module Adminful

  SNEAK_PARAM_NAME = :adminful_ready

  autoload :Properties, 'adminful/properties'

  module Options
    mattr_accessor :namespace
  end

  class Railtie < ::Rails::Engine

    # Add our asset to the pipeline
    #config.assets.precompile << /adminful.(css|js)$/

    config.adminful = Adminful::Options
    config.adminful.namespace = "adminful"
  end
end
