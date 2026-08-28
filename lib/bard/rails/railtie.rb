# frozen_string_literal: true

require "rails/railtie"

module Bard
  module RailsGem
    class Railtie < ::Rails::Railtie
      initializer "bard-rails.mount_api" do |app|
        app.routes.prepend do
          # Anchor to a path boundary so the mount doesn't swallow /bard-api, /bardxyz, etc.
          constraints(->(req) { req.path.match?(%r{\A/bard(/|\z)}) }) do
            mount Bard::Api::App.new => "/bard"
          end
        end
      end
    end
  end
end
