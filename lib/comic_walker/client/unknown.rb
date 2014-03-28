require 'base64'
require 'digest'
require 'openssl'

module ComicWalker
  class Client
    module Unknown
      module_function

      A1B = [173, 43, 117, 127, 230, 58, 73, 84, 154, 177, 47, 81, 108, 200, 101, 65]

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
        decrypt_b64(h + A1B, license_b64)
      end

      # Decrypt Base64-encoded data
      # @param [Array<Fixnum>] key key?
      # @param [String] b64data Base64-encoded data
      # @return [String]
      def decrypt_b64(key, b64data)
        data = Base64.decode64(b64data).unpack('C*')
        md5 = Digest::MD5.hexdigest((key + data.slice(8, 8)).pack('C*'))
        l = md5.scan(/.{2}/).map { |xy| Integer(xy, 16) }
        decrypt_data(data[16 .. -1], l)
      end

      # Decrypt data
      # @param [Array<Fixnum>] data
      # @param [Array<Fixnum>] key
      # @return [String] Decrypt data
      def decrypt_data(data, key)
        dec = OpenSSL::Cipher.new('RC4')
        dec.decrypt
        dec.key = key.pack('C*')
        dec.update(data.pack('C*')) + dec.final
      end
    end
  end
end
