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

    gem 'backbone-rails' # backbone-rails must be required before adminful
    gem 'adminful', :git => 'git://github.com/setepo/adminful.git'

Run:

    $ bundle install

And you are ready to go!

# Configuration

Let's say you want to manage users and products with adminful.

Assuming that you have already got the models `User` and `Product`, the first thing to do is to generate the corresponding controllers. Adminful expects a RESTful JSON backend so the use of `inherited_resources` is encouraged but not mandatory.

The controllers need to be namespaced, by default the expected namespace is `adminful` but if you can use another namespace if you want. We'll see how to override that later:

    $ rails g controller adminful/products
    $ rails g controller adminful/users

The generator might also create the views for you but adminful doesn't need them, so if you want go ahead and delete them.
Instead make sure your controller serves JSON and set it to be included in the adminful interface.

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


