require 'resque'
require 'redis-lock'

module ChewyResque
  class Worker
    def self.queue
      ChewyResque::locking_scope
    end

    def self.perform(index_name, ids)
      ActiveSupport::Notifications.instrument('perform.chewy_resque', index_name: index_name, ids: ids) do
        with_lock(index_name, ids)
      end
    end

    def self.with_lock(index_name, ids)
      lock_name = "chewy-resque:#{ChewyResque.locking_scope}:#{index_name}-#{ids.join('-')}"
      Resque.redis.lock(lock_name, life: 60, acquire: 5) { index(index_name, ids) }
    end

    def self.index(index_name, ids)
      ActiveSupport::Notifications.instrument('index.chewy_resque', index_name: index_name, ids: ids) do
        Chewy.derive_type(index_name).import ids
      end
    end
  end
end
