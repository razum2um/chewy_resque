require 'spec_helper'

describe 'config' do
  context '#logger' do

    after(:each) { ChewyResque.logger = nil }

    it 'can be set from the outside' do
      ChewyResque.logger = :nolog
      expect(ChewyResque.logger).to eq(:nolog)
    end

  end

  context '#locking_scope' do

    after(:each) { ChewyResque.locking_scope = nil }

    it 'can be set from the outside' do
      ChewyResque.locking_scope = '42'
      expect(ChewyResque.locking_scope).to eq('42')
    end

    it 'has a default' do
      expect(ChewyResque.locking_scope).to eq('chewy')
    end

  end
end
