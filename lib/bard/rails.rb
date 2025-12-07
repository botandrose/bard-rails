# frozen_string_literal: true

require "bard-rake"
require "bard-static"
require "bard-staging_banner"
require "labelled_form"
require "slim-rails"
require "bard-file_field"
require "rack-disable_css_animations" if Rails.env.test?
require "bard/api"
require "bard/rails/railtie"
