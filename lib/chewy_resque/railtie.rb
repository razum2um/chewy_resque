module ChewyResque
  class Railtie < Rails::Railtie
    initializer 'chewy_resque.logging' do |app|
      ChewyResque.logger = Rails.logger
    end
  end
end
