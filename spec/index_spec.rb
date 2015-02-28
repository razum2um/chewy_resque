require 'spec_helper'

describe ChewyResque::Index do

  context 'compute the backref' do

    it 'defaults to the corresponding object' do
      object = Object.new
      idx = ChewyResque::Index.new
      expect(idx.backref(object)).to eq object
    end

    it 'can run a random method' do
      object = double(foobar: :backref)
      idx = ChewyResque::Index.new(backref: :foobar)
      expect(idx.backref(object)).to eq :backref
    end

    it 'can use a proc' do
      object = double(foobar: :my_backref)
      idx = ChewyResque::Index.new(backref: -> (r) { r.foobar })
      expect(idx.backref(object)).to eq :my_backref
    end

    context 'turning backrefs into ids' do
      let(:idx) { ChewyResque::Index.new }

      it 'uses the ids of the objects' do
        expect(idx.backref_ids([double(id: 3), double(id: 6)])).to eq [3, 6]
      end

      it 'turns everything else into ints' do
        expect(idx.backref_ids([3, '6'])).to eq [3, 6]
      end

    end

    context 'queue the job' do
      it 'queues the job with the settings from the index' do
        object = double(id: 24)
        idx = ChewyResque::Index.new index: 'foo#bar',
                                     queue: 'hello'

        expect(Resque).to receive(:enqueue_to).with('hello', ChewyResque::Worker, 'foo#bar', [24])
        idx.enqueue object
      end
    end

  end

end
