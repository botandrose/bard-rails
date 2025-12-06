# frozen_string_literal: true

require "rails/railtie"
require "bard-api"

module Bard
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "bard-rails.mount_api" do |app|
        app.routes.prepend do
          mount Bard::Api::Engine => "/bard"
        end
      end
    end
  end
end
