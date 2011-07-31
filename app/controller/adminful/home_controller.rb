class Adminful::HomeController < ApplicationController

  def index
    @available_resources =
      Rails.application.routes.routes.find_all do |route|
        route.defaults[Adminful::SNEAK_PARAM_NAME] and route.defaults[:action] == "index"
      end.map do |route|
        {
          :route => route,
          :controller => "#{route.defaults[:controller]}_controller".camelcase.constantize
        }
      end
  end

  if Rails.application.config.cache_classes
    def index_with_cache
      if cache = self.class.cached_resources
        @available_resources = cache
      else
        index_without_cache
        self.class.cached_resources = @available_resources
      end
    end

    cattr_accessor :cached_resources
    alias_method_chain :index, :cache

  end

end
