require 'bin_stream/delegation'

module BinStream
  # Reader class provides convenience methods for reading data types used in
  # many file formats and binary streams.
  #
  # It assumes network (Big-endian) byte order.
  class Reader
    # Constructor
    #
    # @param io [IO] An instance of IO to read from.
    #
    # @example
    #   BinStream.new(STDIN)
    #
    # @api public
    def initialize(io)
      @io = io
    end

    extend Delegation
    delegate :rewind, :pos, :pos=, :seek, :read, :readbyte, :readchar, :getc, :getbyte, to: :io

    # Reads 1 byte as an unsigned integer
    #
    # @example IO content: 01 FF
    #   reader.uint8      # => 1
    #   reader.uint8      # => 255
    #
    # @api public
    # @return [Fixnum]
    def uint8
      io.read(1).unpack('C')[0]
    end
    alias_method :byte, :uint8

    # Reads 1 byte as a signed integer
    #
    # @example IO content: 01 FF
    #   reader.int8     # => 1
    #   reader.int8     # => -1
    #
    # @api public
    # @return [Fixnum]
    def int8
      io.read(1).unpack('c')[0]
    end
    alias_method :char, :int8

    # Reads 2 byte as an unsigned integer
    #
    # @example IO content: 00 01 FF 02
    #   reader.uint16     # => 1
    #   reader.uint16     # => 65282
    #
    # @api public
    # @return [Fixnum]
    def uint16
      io.read(2).unpack('n')[0]
    end
    alias_method :ushort, :uint16

    # Reads 2 byte as a signed integer
    #
    # @example IO content: 00 01 FF 02
    #   reader.int16      # => 1
    #   reader.int16      # => -254
    #
    # @api public
    # @return [Fixnum]
    def int16
      io.read(2).unpack('s>')[0]
    end

    # Reads 4 byte as an unsigned integer
    #
    # @example IO content: 00 01 FF 02 FE 03 FD 04
    #   reader.uint32     # => 130818
    #   reader.uint32     # => 4261674244
    #
    # @api public
    # @return [Fixnum]
    def uint32
      io.read(4).unpack('N')[0]
    end

    # Reads 4 byte as a signed integer
    #
    # @example IO content: 00 01 FF 02 FE 03 FD 04
    #   reader.int32      # => 130818
    #   reader.int32      # => -33293052
    #
    # @api public
    # @return [Fixnum]
    def int32
      io.read(4).unpack('l>')[0]
    end

    # Reads 2 bytes as a 16-bit signed fraction
    #
    # 2 bit signed interger and 14 bit mantissa.
    #
    # @example IO content: 7F FF 40 00 00 00 C0 00 80 00
    #   reader.short_frac     # => 1.99993896484375
    #   reader.short_frac     # => 1.0
    #   reader.short_frac     # => 0.0
    #   reader.short_frac     # => -1.0
    #   reader.short_frac     # => -2.0
    #
    # @api public
    # @return [Float]
    def short_frac
      int16 / 0x4000.to_f
    end

    # Reads 8 bytes as 64-bit timestamp
    #
    # The timestamp is a number of seconds since 12:00 midnight, January 1,
    # 1904.
    #
    # @example IO content: 00 00 00 00 00 00 00 00 00 00 00 00 A9 75 65 DA
    #   reader.long_date_time     # => 1904-01-01 00:00:00 UTC
    #   reader.long_date_time     # => 1994-02-02 14:14:50 UTC
    #
    # @api public
    # @return [Time]
    def long_date_time
      require 'time'

      z = 2082844800 # Timestamp offset
      s = io.read(8).unpack('q>')[0]

      Time.at(s - z).utc
    end

    private

    # IO accessor
    #
    # @return [IO]
    # @api private
    attr_reader :io
  end
end
