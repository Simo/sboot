require 'simplecov'
SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sboot'

RSpec.configure do |config|
  config.color = true
end
