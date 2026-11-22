# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "bard/rails/puma_manifest"

RSpec.describe Bard::RailsGem::PumaManifest do
  around do |example|
    Dir.mktmpdir { |dir| Dir.chdir(dir) { example.run } }
  end

  let(:locked) { { "puma" => "8.1.1", "nio4r" => "2.7.5", "uri" => "1.1.2", "bard-rails" => Bard::RailsGem::VERSION } }

  before do
    FileUtils.mkdir_p %w[config tmp/pids]
    File.write "config/puma.rb", "workers 4\n"
    stub_const "Puma::Const::PUMA_VERSION", "8.1.1"
    stub_const "NIO::VERSION", "2.7.5"
    allow(Gem).to receive(:loaded_specs).and_return("uri" => double(version: Gem::Version.new("1.1.2")), "did_you_mean" => double(version: Gem::Version.new("2.0.0")))
  end

  def restart_kind(locked: self.locked, ruby: RUBY_VERSION) = described_class.restart_kind(locked:, ruby:)

  it "restarts fully when no puma master has recorded what it loaded" do
    expect(restart_kind).to eq(:full)
  end

  context "once the master has booted" do
    before { described_class.write }

    it "reloads in phases when nothing the master holds has changed" do
      expect(restart_kind).to eq(:phased)
    end

    it "restarts fully when the deploy runs a different ruby, since a hot restart re-execs the old one" do
      expect(restart_kind(ruby: "9.9.9")).to eq(:full)
    end

    it "hot restarts when puma changed, though prune_bundler keeps it out of the master's loaded specs" do
      expect(restart_kind(locked: locked.merge("puma" => "8.1.2"))).to eq(:hot)
    end

    it "hot restarts when nio4r changed" do
      expect(restart_kind(locked: locked.merge("nio4r" => "2.7.6"))).to eq(:hot)
    end

    it "hot restarts when another gem the master activated changed" do
      expect(restart_kind(locked: locked.merge("uri" => "1.1.3"))).to eq(:hot)
    end

    it "hot restarts when bard-rails changed, since the master loads this file from it" do
      expect(restart_kind(locked: locked.merge("bard-rails" => "99.0.0"))).to eq(:hot)
    end

    it "hot restarts when config/puma.rb changed, since a phased reload never rereads it" do
      File.write "config/puma.rb", "workers 8\n"
      expect(restart_kind).to eq(:hot)
    end

    it "ignores gems the master holds that the lockfile doesn't pin" do
      expect(locked).not_to have_key("did_you_mean")
      expect(restart_kind).to eq(:phased)
    end
  end

  it "doesn't compare nio4r when the master never loaded it" do
    hide_const "NIO"
    described_class.write
    expect(restart_kind(locked: locked.merge("nio4r" => "2.7.6"))).to eq(:phased)
  end
end
