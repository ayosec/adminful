module Adminful::HomeHelper
  def resources_to_json(resources)
    resources.map do |resource|
      adminful_data = resource[:controller].adminful_data
      route_name = resource[:route_name]

      collection_name = resource[:controller].name.demodulize.sub(/Controller/, '')

      if adminful_data.nil?
        # Try to infer the model name from the controller name
        model = collection_name.singularize.constantize
      else
        model = adminful_data[:model]
      end

      {
        :name => collection_name.underscore,
        :title => t(route_name, :scope => "adminful.resources", :default => collection_name.humanize),
        :index_path => send(route_name + "_path"),
        :model => {
          :name => model.model_name.to_s,
          :label => model.model_name.human,
          :fields => Adminful::Properties.adapt(model).try(:to_hash)
        }
      }
    end.to_json
  end
end
