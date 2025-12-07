# frozen_string_literal: true

require "rails/railtie"

module Bard
  module RailsGem
    class Railtie < ::Rails::Railtie
      initializer "bard-rails.mount_api" do |app|
        app.routes.prepend do
          mount Bard::Api::App.new => "/bard"
        end
      end
    end
  end
end
