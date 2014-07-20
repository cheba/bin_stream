require "spec_helper"
require "bin_stream/reader"

describe BinStream::Reader do

  let(:reader) { BinStream::Reader.new(io) }

  context 'constructor' do
    it 'require IO' do
      expect(-> { BinStream::Reader.new }).to raise_error
      expect(-> { BinStream::Reader.new(STDIN) }).to_not raise_error
    end
  end


  context 'delegation' do
    let(:io) { double('io') }

    it 'delegates rewind to io' do
      expect(io).to receive(:rewind)

      reader.rewind
    end

    it 'delegates pos to io' do
      expect(io).to receive(:pos)

      reader.pos
    end

    it 'delegates pos= to io' do
      expect(io).to receive(:pos=)

      reader.pos = 42
    end

    it 'delegates seek to io' do
      expect(io).to receive(:seek)

      reader.seek 42, IO::SEEK_CUR
    end

    it 'delegates read to io' do
      expect(io).to receive(:read)

      reader.read 42
    end

    it 'delegates readbyte to io' do
      expect(io).to receive(:readbyte)

      reader.readbyte
    end

    it 'delegates readchar to io' do
      expect(io).to receive(:readchar)

      reader.readchar
    end

    it 'delegates getbyte to io' do
      expect(io).to receive(:getbyte)

      reader.getbyte
    end

    it 'delegates getc to io' do
      expect(io).to receive(:getc)

      reader.getc
    end
  end

  context 'types' do
    let(:data) { [0x00, 0x01, 0xff, 0x02, 0xfe, 0x03, 0xfd, 0x04, 0xfc, 0x05, 0xfb, 0x06, 0xfb, 0x07, 0xfa, 0x08, 0xf0, 0x09, 0xf9, 0x0a] }
    let(:io) { StringIO.new(data.pack('C*')) }

    it 'reads uin8' do
      expect(reader.uint8).to eq(0)
      expect(reader.uint8).to eq(1)
      expect(reader.uint8).to eq(255)
    end

    it 'reads int8' do
      expect(reader.int8).to eq(0)
      expect(reader.int8).to eq(1)
      expect(reader.int8).to eq(-1)
    end

    it 'reads uint16' do
      expect(reader.uint16).to eq(1)
      expect(reader.uint16).to eq(65282)
    end

    it 'reads int16' do
      expect(reader.int16).to eq(1)
      expect(reader.int16).to eq(-254)
    end

    it 'reads uint32' do
      expect(reader.uint32).to eq(130818)
      expect(reader.uint32).to eq(4261674244)
    end

    it 'reads int32' do
      expect(reader.int32).to eq(130818)
      expect(reader.int32).to eq(-33293052)
    end

    context do
      let(:data) { [0x7f, 0xff, 0x40, 0x00, 0x00, 0x00, 0xc0, 0x00, 0x80, 0x00] }

      it 'reades short_frac' do
        expect(reader.short_frac).to be_within(0.00005).of(1.9999)
        expect(reader.short_frac).to eq(1.0)
        expect(reader.short_frac).to eq(0.0)
        expect(reader.short_frac).to eq(-1.0)
        expect(reader.short_frac).to eq(-2.0)
      end
    end

    context do
      let(:data) { [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xa9, 0x75, 0x65, 0xda] }

      it 'reads long_date_time' do
        expect(reader.long_date_time).to eq(Time.utc 1904, 1, 1, 0, 0)
        expect(reader.long_date_time).to eq(Time.utc 1994, 2, 2, 14, 14, 50)
      end
    end
  end
end
