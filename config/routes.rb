Rails.application.routes.draw do

  match Adminful::Options.path => "adminful/home#index", :as => :adminful_home

end
