class Adminful::HomeController < ApplicationController

  def index
    @available_resources =
      Adminful.managed_resources.map do |route|
        {
          :route_name => route.name,
          :controller => "#{route.defaults[:controller].camelize}Controller".constantize
        }
      end
  end

end
