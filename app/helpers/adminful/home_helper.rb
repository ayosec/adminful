module Adminful::HomeHelper
  def resources_to_json(resources)
    resources.map do |resource|
      adminful_data = resource[:controller].adminful_data
      route_name = resource[:route].name

      if adminful_data.nil?
        # Try to infer the model name from the route
        model = route_name.singularize.camelcase.constantize
      else
        model = adminful_data[:model]
      end

      {
        :name => route_name,
        :title => t(route_name, :scope => "adminful.resources", :default => route_name.humanize),
        :index_path => send(route_name + "_path"),
        :show_path => send(route_name.singularize + "_path", "PLACEHOLDER"),
        :model => {
          :name => model.model_name.to_s,
          :label => model.model_name.human,
          :fields => Adminful::Properties.adapt(model).try(:to_hash)
        }
      }
    end.to_json
  end
end
