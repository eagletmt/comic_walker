module ComicWalker
  class ItemDecoder
    module Unknown
      module_function

      # @param [String] Base64-encoded encrypted data
      # @return [Array<Array<Fixnum>>] Chunked encrypted data
      def a5R(a)
        a.scan(/.{1,65536}/).map do |chunk|
          Base64.decode64(chunk).unpack('C*')
        end
      end

      # @param [Array<Array<Fixnum>>] Chunked encrypted data
      # @param [String] key1 key?
      # @param [String] key2 key?
      # @param [String] key3 key?
      # @param [Integer] bsize block size?
      # @param [Integer] hsize size?
      # @return [Array<Array<Fixnum>>] Chunked decrypted data
      def dea0q_(chunks, key1, key2, key3, bsize, hsize)
        offset = 0
        chunks.each do |chunk|
          a0f(key3, chunk, offset)
          offset += chunk.size
        end

        s = []
        i = 0
        chunks.each do |chunk|
          while i < chunk.size
            s << chunk[i]
            i += bsize
          end
          i -= chunk.size
        end

        c = a0g(s, key2)
        i = 0
        j = 0
        chunks.each do |chunk|
          while i < chunk.size
            chunk[i] = c[j]
            j += 1
            i += bsize
          end
          i -= chunk.size
        end
        a0e(key1, chunks[0], hsize)
        chunks
      end

      # @param [String] key
      # @param [Array<Fixnum>] chunk Encrypted data slice
      # @return [nil] Modify the given chunk
      def a0e(key, chunk, hsize)
        hsize = [hsize, chunk.size].min
        ary1 = Array.new(hsize)
        hsize.times do |i|
          ary1[i] = chunk[i]
        end
        ary2 = a0g(ary1, key)
        hsize.times do |i|
          chunk[i] = ary2[i]
        end
      end

      # @param [Array<Fixnum>] ary binary data?
      # @param [String] key key?
      # @return [Array<Fixnum>]
      def a0g(ary, key)
        ary1 = Array.new(ary.size)
        tbl = a0F(key)
        d = 0
        e = 0
        ary.size.times do |i|
          e = (e + 1) % 256
          d = (d + tbl[e]) % 256
          tbl[e], tbl[d] = tbl[d], tbl[e]
          c = (tbl[e] + tbl[d]) % 256
          ary1[i] = ary[i] ^ tbl[c]
        end
        ary1
      end

      # @param [String] key key?
      # @param [Array<Fixnum>] buf Encrypted data slice
      # @param [Integer] offset offset?
      # @return [nil] Modify the given buf
      def a0f(key, buf, offset)
        d = a0F(key)
        buf.size.times do |i|
          buf[i] ^= d[(i + offset) % 256]
        end
      end

      # @param [String] key key?
      # @return [Array<Fixnum>] Some table
      def a0F(key)
        e = []
        d = []
        256.times do |i|
          e[i] = i
        end
        256.times do |i|
          d[i] = key[i % key.size].ord
        end
        a = 0
        256.times do |i|
          a = (a + e[i] + d[i]) & 0xff
          e[i], e[a] = e[a], e[i]
        end
        e
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
