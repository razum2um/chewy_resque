require 'spec_helper'

describe ChewyResque::Worker do

  let(:worker) { ChewyResque::Worker.new }
  let(:lock) { double(acquire!: true, release!: true) }

  before(:each) { allow(worker).to receive(:lock).and_return(lock) }

  it 'calls the indexing with chewy' do
    index = double
    expect(Chewy).to receive(:derive_type).with('foo#bar').and_return(index)
    expect(index).to receive(:update_index).with([17])

    worker.class.perform('foo#bar', [17])
  end

end
