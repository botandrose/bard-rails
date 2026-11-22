# frozen_string_literal: true

require "puma/plugin"
require_relative "../../bard/rails/puma_manifest"

Puma::Plugin.create do
  def config(dsl)
    dsl.before_fork { Bard::RailsGem::PumaManifest.write }
  end
end
