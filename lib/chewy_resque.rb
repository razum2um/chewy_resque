require 'active_support/notifications'
require 'active_support/log_subscriber'

require "chewy_resque/version"
require "chewy_resque/mixin"
require "chewy_resque/worker"
require "chewy_resque/index"
require "chewy_resque/config"
require "chewy_resque/log_subscriber"

require "chewy_resque/railtie" if defined?(::Rails)

ChewyResque::LogSubscriber.attach_to 'chewy_resque'
