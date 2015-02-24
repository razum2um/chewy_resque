module ChewyResque

  class LogSubscriber < ActiveSupport::LogSubscriber

    def perform(event)
      info "ChewyResque job ran on #{event.payload[:index_name]} with ids #{event.payload[:ids]} - duration #{event.duration}"
    end

    def index(event)
      debug "ChewyResque index updated on #{event.payload[:index_name]} with ids #{event.payload[:ids]} - duration #{event.duration}"
    end

    def queue_jobs(event)
      debug "ChewyResque queued jobs from #{event.payload[:class]} #{event.payload[:id]}"
    end

    def logger
      ChewyResque.logger
    end

  end

end
