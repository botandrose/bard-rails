# frozen_string_literal: true

require_relative "version"

module Bard
  module RailsGem
    # Written inside puma's pruned master, so it may only use what that master has already loaded.
    module PumaManifest
      MANIFEST = "tmp/pids/puma.manifest"
      BOOTED_CONFIG = "tmp/pids/puma.rb.booted"
      CONFIG = "config/puma.rb"
      private_constant :MANIFEST, :BOOTED_CONFIG, :CONFIG

      def self.write
        held = Gem.loaded_specs.to_h { |name, spec| [name, spec.version.to_s] }
        held["puma"] = Puma::Const::PUMA_VERSION
        held["nio4r"] = NIO::VERSION if defined?(NIO::VERSION)
        held["bard-rails"] = VERSION
        held["ruby"] = RUBY_VERSION
        File.write MANIFEST, held.map { |name, version| "#{name} #{version}\n" }.join
        File.write BOOTED_CONFIG, File.read(CONFIG)
      end

      def self.restart_kind(locked: Bundler.locked_gems.specs.to_h { |spec| [spec.name, spec.version.to_s] }, ruby: RUBY_VERSION)
        return :full unless File.exist?(MANIFEST) && File.exist?(BOOTED_CONFIG)

        held = File.readlines(MANIFEST, chomp: true).to_h(&:split)
        return :full if held.fetch("ruby") != ruby
        return :hot if File.read(BOOTED_CONFIG) != File.read(CONFIG)
        return :hot if held.any? { |name, version| locked.fetch(name, version) != version }

        :phased
      end
    end
  end
end
