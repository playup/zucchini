require 'clamp'
require 'fileutils'

$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/..")
require 'lib/config'
require 'lib/screenshot'
require 'lib/report'
require 'lib/feature'
require 'lib/runner'
require 'lib/generator'
require 'lib/approver'

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true
  #config.formatter = :documentation
end
