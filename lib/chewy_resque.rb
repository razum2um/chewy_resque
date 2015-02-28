require 'active_support/notifications'
require 'active_support/log_subscriber'

require "chewy_resque/version"
require "chewy_resque/mixin"
require "chewy_resque/worker"
require "chewy_resque/index"
require "chewy_resque/config"
require "chewy_resque/log_subscriber"

if defined?(::Rails)
  ChewyResque.logger = Rails.logger
end

ChewyResque::LogSubscriber.attach_to 'chewy_resque'
