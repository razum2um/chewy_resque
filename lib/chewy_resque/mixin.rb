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

      def async_update_index(index, queue: ChewyResque::default_queue, backref: :self, only_if: nil)
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
        self.class.indexers.each { |idx| idx.enqueue(self) }
      end
    end
  end
end
