require 'active_support/concern'
require 'active_support/core_ext/array/wrap'

module ChewyResque

  def self.default_queue=(queue)
    @default_queue = queue
  end

  def self.default_queue
    @default_queue || 'default'
  end

  module Mixin

    extend ActiveSupport::Concern

    included do
      class_attribute :indexers
      self.indexers = []
    end

    module ClassMethods

      def async_update_index(index, queue: nil, backref: :self, only_if: nil)
        install_chewy_hooks if indexers.empty? # Only install them once
        indexers << ChewyResque::Index.new(index: index, queue: queue, backref: backref, only_if: only_if)
      end

      def install_chewy_hooks
        after_commit :queue_chewy_jobs
      end
    end

    def queue_chewy_jobs
      ActiveSupport::Notifications.instrument('queue_jobs.chewy_resque', class: self.class.name, id: self.id) do
        self.class.indexers or return
        self.class.indexers.each do |idx|
          begin
            idx.enqueue(self)
          rescue => e
            # ResqueSpec stubs all exeptions from here in tests, even no logs
            if ChewyResque.logger.respond_to? :error
              ChewyResque.logger.error "Cannot update index #{idx.index_name}: #{e}\n#{e.backtrace}"
            end
            raise e
          end
        end
      end
    end
  end
end
