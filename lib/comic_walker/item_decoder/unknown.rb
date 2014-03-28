require 'comic_walker/cipher'

module ComicWalker
  class ItemDecoder
    module Unknown
      module_function

      # @param [Array<Fixnum>] key
      # @param [Array<Fixnum>] data Encrypted data
      # @return [Array<Fixnum>]
      def prepare(key, data)
        s = Cipher.gen_rc4_table(key)
        data.map.with_index do |b, i|
          b ^ s[i % 256]
        end
      end

      # @param [Array<Fixnum>] key
      # @param [Integer] bsize block size?
      # @param [Array<Fixnum>] data Encrypted data
      # @return [Array<Fixnum>] Chunked decrypted data
      def decrypt(key, bsize, data)
        s = []
        0.step(data.size-1, bsize) do |i|
          s << data[i]
        end

        c = Cipher.decrypt_rc4(key, s)
        # s.size == c.size

        0.step(data.size-1, bsize) do |i|
          data[i] = c.shift
        end
        data
      end

      # @param [Array<Fixnum>] key
      # @param [Integer] hsize header size?
      # @param [Array<Fixnum>] data Encrypted data
      # @return [Array<Fixnum>] data
      def finish(key, hsize, data)
        hsize = [hsize, data.size].min
        Cipher.decrypt_rc4(key, data.slice(0, hsize)).each.with_index do |x, i|
          data[i] = x
        end
        data
      end

      # Calculate moves.
      # @param [Integer] width Width of the image
      # @param [Integer] height Height of the image
      # @param [Integer] rect_width Width of the sub-image
      # @param [Integer] rect_height Height of the sub-image
      # @param [Integer] pattern pattern? integer ranging from 1 to 4
      # @return [Array<Hash>] List of hash that represents a move
      def calculate_moves(width, height, rect_width, rect_height, pattern)
        wcnt = width / rect_width
        hcnt = height / rect_height
        width %= rect_width
        height %= rect_height
        moves = []
        w_t0 = wcnt - (43*pattern)%wcnt
        w_t1 =
          if w_t0 % wcnt == 0
            (wcnt - 4) % wcnt
          else
            w_t0
          end
        h_t0 = hcnt - 47 * pattern % hcnt;
        h_t1 =
          if h_t0 % hcnt == 0
            (hcnt - 4) % hcnt
          else
            h_t0;
          end

        if width > 0 && height > 0
          x = w_t1 * rect_width
          y = h_t1 * rect_height
          moves.push(srcX: x, srcY: y, destX: x, destY: y, width: width, height: height)
        end

        if height > 0
          wcnt.times do |j|
            l = calcXCoordinateXRest_(j, wcnt, pattern)
            k = calcYCoordinateXRest_(l, w_t1, h_t1, hcnt, pattern)
            destX = calcPositionWithRest_(l, w_t1, width, rect_width)
            destY = k * rect_height
            srcX = calcPositionWithRest_(j, w_t1, width, rect_width)
            srcY = h_t1 * rect_height
            moves.push(srcX: srcX, srcY: srcY, destX: destX, destY: destY, width: rect_width, height: height)
          end
        end
        if width > 0
          hcnt.times do |i|
            k = calcYCoordinateYRest_(i, hcnt, pattern)
            l = calcXCoordinateYRest_(k, w_t1, h_t1, wcnt, pattern)
            destX = l * rect_width
            destY = calcPositionWithRest_(k, h_t1, height, rect_height)
            srcX = w_t1 * rect_width
            srcY = calcPositionWithRest_(i, h_t1, height, rect_height)
            moves.push(srcX: srcX, srcY: srcY, destX: destX, destY: destY, width: width, height: rect_height)
          end
        end
        wcnt.times do |j|
          hcnt.times do |i|
            p = (j + 29 * pattern + 31 * i) % wcnt
            k = (i + 37 * pattern + 41 * p) % hcnt
            q = p >= calcXCoordinateYRest_(k, w_t1, h_t1, wcnt, pattern) ? width : 0
            m = k >= calcYCoordinateXRest_(p, w_t1, h_t1, hcnt, pattern) ? height : 0
            destX = p * rect_width + q
            destY = k * rect_height + m
            srcX = j * rect_width + (j >= w_t1 ? width : 0)
            srcY = i * rect_height + (i >= h_t1 ? height : 0)
            moves.push(srcX: srcX, srcY: srcY, destX: destX, destY: destY, width: rect_width, height: rect_height)
          end
        end
        moves
      end

      # @param [Integer] a
      # @param [Integer] f
      # @param [Integer] b
      # @param [Integer] e
      # @return [Integer]
      def calcPositionWithRest_(a, f, b, e)
        a * e + (a >= f ? b : 0)
      end

      # @param [Integer] a
      # @param [Integer] f
      # @param [Integer] b
      # @return [Integer]
      def calcXCoordinateXRest_(a, f, b)
        (a + 61 * b) % f
      end

      # @param [Integer] a
      # @param [Integer] f
      # @param [Integer] b
      # @param [Integer] e
      # @param [Integer] d
      # @return [Integer]
      def calcYCoordinateXRest_(a, f, b, e, d)
        c = 1 == d % 2
        if a < f ? c : !c
          e = b
          f = 0
        else
          e -= b
          f = b
        end
        (a + 53*d + 59*b) % e + f
      end

      # @param [Integer] a
      # @param [Integer] f
      # @param [Integer] b
      # @param [Integer] e
      # @param [Integer] d
      # @return [Integer]
      def calcXCoordinateYRest_(a, f, b, e, d)
        c = 1 == d % 2
        if a < b ? c : !c
          e -= f
          b = f
        else
          e = f
          b = 0
        end
        (a + 67*d + f + 71) % e + b
      end

      # @param [Integer] a
      # @param [Integer] f
      # @param [Integer] b
      # @return [Integer]
      def calcYCoordinateYRest_(a, f, b)
        (a + 73*b) % f
      end
    end
  end
end
