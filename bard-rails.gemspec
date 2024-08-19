# frozen_string_literal: true

require_relative "lib/bard/rails/version"

Gem::Specification.new do |spec|
  spec.name = "bard-rails"
  spec.version = Bard::RailsVERSION
  spec.authors = ["Micah Geisel"]
  spec.email = ["micah@botandrose.com"]

  spec.summary = "Metagem that includes all the gems common to all Rails project by BARD."
  spec.homepage = "https://github.com/botandrose/bard-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bard"
  spec.add_dependency "bard-rake"
  spec.add_dependency "bard-static"
  spec.add_dependency "bard-staging_banner"
  spec.add_dependency "bard-file_field"
  spec.add_dependency "slim-rails"
  spec.add_dependency "labelled_form"
  spec.add_dependency "rack-disable_css_animations"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
