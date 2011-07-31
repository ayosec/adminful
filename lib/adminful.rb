require 'rails/engine'
require 'adminful/rails_helper_methods'

module Adminful

  SNEAK_PARAM_NAME = :adminful_ready

  # autoload :foo, 'adminful/foo'

  module Options
    mattr_accessor :path
    mattr_accessor :prefix_resources
  end

  class Railtie < ::Rails::Engine

    # Add our asset to the pipeline
    #config.assets.precompile << /adminful.(css|js)$/

    config.adminful = Adminful::Options
    config.adminful.path = "/admin"
    config.adminful.prefix_resources = true
  end
end
