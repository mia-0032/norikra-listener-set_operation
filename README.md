# Norikra::Listener::SetOperation

[![Build Status](https://travis-ci.org/mia-0032/norikra-listener-set_operation.svg?branch=master)](https://travis-ci.org/mia-0032/norikra-listener-set_operation)

This Norikra listener plugin execute set operation between `new events` and `old events`.

`new events` are events in current window, and `old events` are in previous window.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'norikra-listener-set_operation'
```

And then execute:

    $ bundle
    $ bundle exec rspec
    $ bundle exec norikra start --more-verbose

Or install it yourself as:

    $ gem install norikra-listener-set_operation
    $ norikra start --more-verbose

## Usage

You register query like below.

```sql
SELECT DISTINCT hostname
FROM ping_message.win:time(2 min)
```

This query sends events in current window like below.

```javascript
{"hostname": "host1"}
{"hostname": "host2"}
{"hostname": "host3"}
{"hostname": "host4"}
```

Events in previous window is like below.

```javascript
{"hostname": "host3"}
{"hostname": "host4"}
{"hostname": "host5"}
{"hostname": "host6"}
{"hostname": "host7"}
```

If you register `SET_OPERATION(hostname,diff_hostname)` to `query_group`, `diff_hostname` target is created.

And then event is send like below.

```javascript
{
  "difference_new_old": ["host1", "host2"],
  "difference_old_new": ["host5", "host6", "host7"],
  "union": ["host1", "host2", "host3", "host4", "host5", "host6", "host7"],
  "intersection": ["host3", "host4"]
}
```

## Contributing

1. Fork it ( https://github.com/mia-0032/norikra-listener-set_operation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
