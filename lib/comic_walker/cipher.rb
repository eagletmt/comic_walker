require 'base64'
require 'digest'

module ComicWalker
  module Cipher
    module_function

    BASE_KEY = [173, 43, 117, 127, 230, 58, 73, 84, 154, 177, 47, 81, 108, 200, 101, 65].pack('C*')

    # Decrypt Base64-encoded license object
    # @param [String] bid browser id
    # @param [String] u1 got from cookie
    # @param [String] license_b64 Base64-encoded license object
    # @return [String]
    def decrypt_license(bid, u1, license_b64)
      h = bid.chars.map(&:ord)
      if u1
        h += u1.chars.map(&:ord)
      end
      decrypt_b64(h.pack('C*') + BASE_KEY, license_b64)
    end

    # Decrypt Base64-encoded data
    # @param [String] key key
    # @param [String] b64data Encrypted Base64-encoded data
    # @return [String] Decrypted data
    def decrypt_b64(key, b64data)
      data = Base64.decode64(b64data)
      md5 = Digest::MD5.hexdigest(key + data.byteslice(8, 8))
      l = md5.scan(/.{2}/).map { |xy| Integer(xy, 16) }
      decrypt_rc4(l, data[16 .. -1].unpack('C*')).pack('C*')
    end

    # Decrypt data
    # @param [Array<Fixnum>] key
    # @param [Array<Fixnum>] data
    # @return [Array<Fixnum>] Decrypt data
    def decrypt_rc4(key, data)
      s = gen_rc4_table(key)
      i = 0
      j = 0
      data.map do |x|
        i = (i + 1) & 0xff
        j = (j + s[i]) & 0xff
        s[i], s[j] = s[j], s[i]
        k = s[(s[i] + s[j]) & 0xff]
        x ^ k
      end
    end

    # @param [Array<Fixnum>] key
    # @return [Array<Fixnum>] RC4 table
    def gen_rc4_table(key)
      s = 256.times.to_a
      j = 0
      256.times do |i|
        j = (j + s[i] + key[i % key.size]) & 0xff
        s[i], s[j] = s[j], s[i]
      end
      s
    end
  end
end
