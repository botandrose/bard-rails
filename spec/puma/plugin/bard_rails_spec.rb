# frozen_string_literal: true

require "puma"
require "puma/plugin"

RSpec.describe "puma plugin :bard_rails" do
  it "writes the manifest just before the master forks its workers" do
    hooks = []
    dsl = double
    allow(dsl).to receive(:before_fork) { |&hook| hooks << hook }

    Puma::Plugins.find("bard_rails").new.config(dsl)

    expect(Bard::RailsGem::PumaManifest).to receive(:write)
    hooks.each(&:call)
  end
end
