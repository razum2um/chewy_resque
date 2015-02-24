# ChewyResque

[![Build Status](https://travis-ci.org/razum2um/chewy_resque.svg?branch=master)](https://travis-ci.org/razum2um/chewy_kiqqer)
[![Code Climate](https://codeclimate.com/github/razum2um/chewy_resque.png)](https://codeclimate.com/github/razum2um/chewy_kiqqer)
[![Test Coverage](https://codeclimate.com/github/razum2um/chewy_resque/coverage.png)](https://codeclimate.com/github/razum2um/chewy_kiqqer)

This is an alternative udpate/callback mechanism for [Chewy](https://github.com/toptal/chewy). It queues the updates as [Resque](https://github.com/resque/resque) jobs.

You can pass backrefs like with the standard chewy mechanism, but the job itself will always receive an array of ids.

It is possible to install more multiple update hooks.

## Installation

Add this line to your application's Gemfile:

    gem 'chewy_resque'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chewy_resque

## Usage

Just add the module and set it up:

    class User < ActiveRecord::Base
      include ChewyResque::Mixin

      async_update_index index: 'users#user', backref: :something
    end

Giving a backref is also optional (also check the chewy docs for the concept). The backref is the element
which will be indexed. The default is to use the current record.

    # use the current record for the backref
    ... backref: :self
    # call a method on the current record to get the backref
    ... backref: :some_method
    # Pass a proc. It will be called with the current record to get the backref
    ... backref: -> (rec) { |rec| rec.do_something }

## Update handling

The resque does *not* use Chewy's `atomic` update, since that functionality is deeply linked with Chewy's syncronous update mechanism.


However, if you have multiple database transactions, the resque will still queue multiple jobs. The same is true when you enqueue jobs manually.

ChewyResque uses locking via redis to ensure that all updates for one database record are run sequentially. This prevents race conditions which could lead to outdated data being written to the index otherwise.

## Logging

Logging is disabled by default, but you can set `ChewyResque.logger` if you need log output (e.g. `ChewyResque.logger = Rails.logger`). ChewyResque uses ActiveSupport notifications, which you can also subscribe to.
See `log_subscriber.rb` for more info.

## Acknoledgements

This gem is heavily borrowed from [chewy_kiqqer](https://github.com/averell23/chewy_kiqqer).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
