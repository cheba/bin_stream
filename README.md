# BinStream

BinStream prowides IO wrappers for convenient reading and writing of common data
types used in binary file formats.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bin_stream'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bin_stream

## Usage

```ruby
File.opne('myfile.bin') do |f|
  # Instantiate a reader with an IO instance
  r = BinStream::Reader.new(f)

  r.uint8           # Read 1 byte as an unsigned integer
  r.int16           # Read 2 bytes as a signed integer
  r.short_frac      # Read 2 bytes as a signed 2.14 fraction
  r.long_date_time  # Read 8 bytes timestamp since 12:00 midnight, January 1, 1904
end
```

## Contributing

1. [Fork it](https://github.com/cheba/bin_stream/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
