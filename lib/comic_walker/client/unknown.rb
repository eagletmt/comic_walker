require 'base64'
require 'digest'

module ComicWalker
  class Client
    module Unknown
      module_function

      A1B = [173, 43, 117, 127, 230, 58, 73, 84, 154, 177, 47, 81, 108, 200, 101, 65]

      def a0l(bid, s, license_b64)
        h = bid.chars.map(&:ord)
        if s
          h += s.chars.map(&:ord)
        end
        dea0qData_(h + A1B, license_b64)
      end

      def dea0qData_(a, license_b64)
        license_bin = Base64.decode64(license_b64).unpack('C*')
        md5 = Digest::MD5.hexdigest((a + license_bin.slice(8, 8)).pack('C*'))
        l = md5.chars.each_slice(2).map do |x, y|
          Integer(x + y, 16)
        end
        a0gBin(license_bin[16 .. -1], l).pack('U*')
      end

      def a0gBin(a, b)
        h = a0Fbin(b)
        d = 0
        e = 0
        a.size.times.map do |k|
          e = (e + 1) % 256
          d = (d + h[e]) % 256
          h[e], h[d] = h[d], h[e]
          c = (h[e] + h[d]) % 256
          a[k] ^ h[c]
        end
      end

      def a0Fbin(a)
        e = []
        d = []
        256.times do |b|
          e[b] = b
        end
        256.times do |b|
          d[b] = a[b % a.size]
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
