ENV['REDIS_NAMESPACE_QUIET'] ||= '1'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'chewy_resque'
require 'chewy'

RSpec.configure do |config|
  config.before do
    logger = Logger.new(STDOUT)
    logger.level = Logger::ERROR
    ChewyResque.logger = logger
  end
end

