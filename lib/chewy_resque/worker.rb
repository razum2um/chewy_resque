require 'chewy'
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
        with_strategy do
          Chewy.derive_type(index_name).update_index(ids)
        end
      end
    end

    def self.with_strategy
      if Chewy.respond_to?(:strategy) && Chewy.strategy.current.name == :base
        # production
        begin
          Chewy.strategy(:atomic)
          yield
        rescue
          Chewy.strategy.pop
        end
      else
        # 0.6.2 or test
        yield
      end
    end
  end
end
