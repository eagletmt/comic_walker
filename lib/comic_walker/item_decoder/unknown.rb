module ComicWalker
  class ItemDecoder
    module Unknown
      module_function

      # @param [String] Base64-encoded encrypted data
      # @param [String] key3 key?
      # @return [Array<Array<Fixnum>>] Chunked encrypted data
      CHUNK_SIZE = 65536 / 4 * 3
      def split_encrypted_data(a, key3)
        bytes = Base64.decode64(a).unpack('C*')
        func1(key3, bytes).each_slice(CHUNK_SIZE).to_a
      end

      # @param [Array<Array<Fixnum>>] Chunked encrypted data
      # @param [Integer] bsize block size?
      # @return [Array<Array<Fixnum>>] Chunked decrypted data
      def decrypt(chunks, key, bsize)
        s = []
        chunks.each do |chunk|
          0.step(chunk.size-1, bsize) do |i|
            s << chunk[i]
          end
        end

        c = func2(s, key)
        # s.size == c.size

        chunks.each do |chunk|
          0.step(chunk.size-1, bsize) do |i|
            chunk[i] = c.shift
          end
        end
        chunks
      end

      # @param [String] key
      # @param [Array<Fixnum>] chunk Encrypted data slice
      # @param [Integer] hsize header size?
      # @return [nil] Modify the given chunk
      def func3(key, chunk, hsize)
        hsize = [hsize, chunk.size].min
        func2(chunk.slice(0, hsize), key).each.with_index do |x, i|
          chunk[i] = x
        end
      end

      # @param [Array<Fixnum>] ary binary data?
      # @param [String] key key?
      # @return [Array<Fixnum>]
      def func2(ary, key)
        # RC4?
        tbl = gen_table(key)
        i = 0
        j = 0
        ary.map do |x|
          i = (i + 1) % 256
          j = (j + tbl[i]) % 256
          tbl[i], tbl[j] = tbl[j], tbl[i]
          c = (tbl[i] + tbl[j]) % 256
          x ^ tbl[c]
        end
      end

      # @param [String] key key?
      # @param [Array<Fixnum>] bytes Encrypted data
      # @return [Array<Fixnum>]
      def func1(key, bytes)
        d = gen_table(key)
        bytes.map.with_index do |b, i|
          b ^ d[i % 256]
        end
      end

      # @param [String] key key?
      # @return [Array<Fixnum>] Some table
      def gen_table(key)
        key = key.unpack('C*')
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
