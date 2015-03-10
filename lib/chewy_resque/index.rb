require 'active_support/core_ext/object/blank'
require 'resque'

module ChewyResque
  class Index

    attr_reader :index_name

    def initialize(backref: :self, index: nil, queue: nil, only_if: nil)
      @only_if = only_if
      @index_name = index
      @backref_method = backref
      @queue = queue
    end

    def enqueue(object)
      return if @only_if.respond_to?(:call) && @only_if.call(object)
      if (ids = backref_ids(object)).present?
        Resque.enqueue_to(@queue || Resque.queue_from_class(ChewyResque::Worker),
                          ChewyResque::Worker,
                          @index_name,
                          ids)
      end
    end

    def backref(object)
      return @backref_method.call(object) if @backref_method.respond_to?(:call)
      return object if @backref_method.to_s == 'self'
      object.send(@backref_method)
    end

    def backref_ids(object)
      Array.wrap(backref(object)).map { |object| object.respond_to?(:id) ? object.id : object.to_i }
    end
  end
end
