module Adminful::HomeHelper
  def resource_definition(resource)
    adminful_data = resource[:controller].adminful_data
    collection_name = resource[:controller].name.demodulize.sub(/Controller/, '')

    model = adminful_data.nil? ? collection_name.singularize.constantize : adminful_data[:model]
    model_name = model.model_name

    {
      :name => collection_name.underscore,
      :label => t(resource[:route_name], :scope => "adminful.resources", :default => collection_name.humanize),
      :index_path => send("#{resource[:route_name]}_path"),
      :collection_name => model_name.pluralize,
      :model => {
        :name => model_name.to_s,
        #:label => model_name.human,
        :fields => Adminful::Properties.adapt(model).try(:to_hash)
      }
    }
  end
end
