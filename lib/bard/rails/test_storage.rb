# frozen_string_literal: true

require "fileutils"
require "active_storage/service/disk_service"

module Bard
  module RailsGem
    module TestStorage
      def initialize(root:, **)
        pid = Process.pid
        super(root: File.join(root, "pid-#{pid}"), **)
        # Forked children inherit this hook; only the creating process may delete the dir.
        at_exit { FileUtils.rm_rf(self.root) if Process.pid == pid }
      end
    end
  end
end

ActiveStorage::Service::DiskService.prepend Bard::RailsGem::TestStorage
