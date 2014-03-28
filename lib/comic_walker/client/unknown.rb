require 'base64'
require 'digest'

module ComicWalker
  class Client
    module Unknown
      module_function

      A1B = [173, 43, 117, 127, 230, 58, 73, 84, 154, 177, 47, 81, 108, 200, 101, 65]

      # Decode Base64-encoded license object
      # @param [String] bid browser id
      # @param [String] u1 got from cookie
      # @param [String] license_b64 Base64-encoded license object
      # @return [String]
      def a0l(bid, u1, license_b64)
        h = bid.chars.map(&:ord)
        if u1
          h += u1.chars.map(&:ord)
        end
        dea0qData_(h + A1B, license_b64)
      end

      # Decode Base64-encoded data
      # @param [String] key key?
      # @param [String] b64data Base64-encoded data
      # @return [String]
      def dea0qData_(key, b64data)
        data = Base64.decode64(b64data).unpack('C*')
        md5 = Digest::MD5.hexdigest((key + data.slice(8, 8)).pack('C*'))
        l = md5.scan(/.{2}/).map { |xy| Integer(xy, 16) }
        a0gBin(data[16 .. -1], l).pack('U*')
      end

      # Decode data
      # @param [Array<Fixnum>] data
      # @param [String] key
      # @return [Array<Fixnum>] Decoded data
      def a0gBin(data, key)
        tbl = a0Fbin(key)
        d = 0
        e = 0
        data.map do |x|
          e = (e + 1) % 256
          d = (d + tbl[e]) % 256
          tbl[e], tbl[d] = tbl[d], tbl[e]
          c = (tbl[e] + tbl[d]) % 256
          x ^ tbl[c]
        end
      end

      # @param [String] key
      # @return [Array<Fixnum>] Some table
      def a0Fbin(key)
        e = []
        d = []
        256.times do |b|
          e[b] = b
        end
        256.times do |b|
          d[b] = key[b % key.size]
        end
        a = 0
        256.times do |b|
          a = (a + e[b] + d[b]) % 256
          e[b], e[a] = e[a], e[b]
        end
        e
      end
    end
  end
end
