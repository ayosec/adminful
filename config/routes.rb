Rails.application.routes.draw do

  match "/#{Adminful::Options.namespace}" => "adminful/home#index", :as => :adminful_home

end
