module Adminful
  class RoutesWrapper
    def initialize(source)
      @source = source
    end

    def add_route(app, conditions = {}, requirements = {}, defaults = {}, name = nil, anchor = true)
      new_route = @source.add_route(app, conditions, requirements, defaults, name, anchor)

      if defaults[:action] == "index"
        Adminful.managed_resources << new_route
      end

      new_route
    end

    ## Proxy everything else
    def method_missing(method_name, *arguments, &block)
      arguments.unshift method_name
      @source.send(*arguments, &block)
    end
  end
end
