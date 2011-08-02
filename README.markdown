# Adminful

A simple, powerful and non-invasive admin interface for Rails apps based on Backbone.js

## Status

This project is still under heavy development and thus in very alpha stage. You might come across bugs and the API might change in the future. Contributions are welcome.

## Features

* ORM-agnostic: Use with any ActiveModel compliant ORM: ActiveRecord, MongoId, MongoMapper, etc.
* Backbone.js: All actions are implemented with Backbone.js, there is only one

## Alternatives

The following projects are very popular but at the moment still ActiveRecord-centric and not usable with other ORMs. They are also more feature-rich and not Javascript-enabled.

* [Typus](https://github.com/typus/typus)
* [RailsAdmin](https://github.com/sferik/rails_admin)

# Installation

In your `Gemfile`, add the following dependencies:

    gem 'backbone-rails'
    gem 'adminful', :git => 'git://github.com/ayosec/adminful.git'

Run:

    $ bundle install

And you are ready to go!

Note:
At the moment, in order for the Rails 3.1 asset pipeline to work properly, backbone-rails must also be added to your Gemfile although it is a dependency of adminful.

# Configuration

Let's say you want to manage users and products with adminful.

Assuming that you have already got the models `User` and `Product`, the first thing to do is to generate the corresponding controllers. Adminful expects a RESTful JSON backend so the use of `inherited_resources` is encouraged but not mandatory.

The controllers need to be namespaced, by default the expected namespace is `adminful` but if you can use another namespace if you want. We'll see how to override that later:

    $ rails g controller adminful/products
    $ rails g controller adminful/users

The generator might also create the views for you but adminful doesn't need them, so if you want go ahead and delete them.
Instead make sure your controller serves JSON and tell adminful which model this controller works with (this last step might not be necessary in the future, as we will try to infer it from the controller name):

    class Adminful::ProductsController < ApplicationController
      respond_to :json
      adminful Product
    end

In your `config/routes.rb` file add the following block:

    adminful do
      resources :users
      resources :products
    end

If you used a namespace other than adminful you can set it inside your `config/application.rb`, e.g.:

    config.adminful.namespace = "admin"

# Usage

Fire up the server

    $ rails s

and point your browser at your adminful namespace, e.g. `http://localhost:3000/adminful`.


