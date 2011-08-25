require 'rails/engine'
require 'adminful/rails_helper_methods'

module Adminful

  autoload :Properties, 'adminful/properties'
  autoload :RoutesWrapper, 'adminful/routes_wrapper'

  module Options
    mattr_accessor :namespace

    mattr_accessor :enable_default_styles
    mattr_accessor :custom_css
    mattr_accessor :custom_javascript
  end

  class Railtie < ::Rails::Engine

    # Add our asset to the pipeline
    #config.assets.precompile << /adminful.(css|js)$/

    config.adminful = Adminful::Options
    config.adminful.namespace = "adminful"

    # Custom definitions for CSS and JavaScript
    config.adminful.enable_default_styles = true

    initializer "*" do
      # Default paths to custom CSS/JS files.
      # Need the initializer since Rails.root is nil when this file is loaded

      config.adminful.custom_css = Rails.root.join("app", "assets", "stylesheets", "adminful")
      config.adminful.custom_javascript = Rails.root.join("app", "assets", "javascripts", "adminful")
    end

    initializer "add_routing_paths" do
      Adminful.managed_resources = []
    end
  end

  # Resources to be managed with this gem
  mattr_accessor :managed_resources
end
