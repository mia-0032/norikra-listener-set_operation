# Norikra::Listener::SetOperation

This Norikra listener plugin execute set operation between `new events` and `old events`.

`new events` are events in current window, and `old events` are in previous window.

## Example

Events in current window is below.

```javascript
{"hostname": "host1"}
{"hostname": "host2"}
{"hostname": "host3"}
{"hostname": "host4"}
```

Events in previous window is below.

```javascript
{"hostname": "host3"}
{"hostname": "host4"}
{"hostname": "host5"}
{"hostname": "host6"}
{"hostname": "host7"}
```

If you register `SET_OPERATION(hostname,diff_hostname)` to `query_group`, `diff_hostname` event is created like below.

```javascript
{
  "difference_new_old": [1,2],
  "difference_old_new": [5,6,7],
  "union": [1,2,3,4,5,6,7],
  "intersection": [3,4]
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'norikra-listener-set_operation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install norikra-listener-set_operation

## Usage

TODO: Write later.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/norikra-listener-set_operation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
