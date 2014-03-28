require 'base64'
require 'digest'
require 'openssl'

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
      l = md5.scan(/.{2}/).map { |xy| Integer(xy, 16) }.pack('C*')
      decrypt_rc4(l, data[16 .. -1])
    end

    # Decrypt data
    # @param [String] key
    # @param [String] data
    # @return [String] Decrypt data
    def decrypt_rc4(key, data)
      dec = OpenSSL::Cipher.new('RC4')
      dec.decrypt
      dec.key = key
      dec.update(data) + dec.final
    end
  end
end
