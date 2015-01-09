package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class Snappy
	{
		private static const MAX_HT_SIZE:int = 1 << 14;
	    private static const MIN_COMPRESSIBLE_BYTES:int = 15;
	
	    // used as a return value to indicate that we haven't yet read our full
	    // preamble
	    private static const PREAMBLE_NOT_FULL:int = -1;
	    private static const NOT_ENOUGH_INPUT:int = -1;
	
	    // constants for the tag types
	    private static const LITERAL:int = 0;
	    private static const COPY_1_BYTE_OFFSET:int = 1;
	    private static const COPY_2_BYTE_OFFSET:int = 2;
	    private static const COPY_4_BYTE_OFFSET:int = 3;
	
	    private var state:State = State.READY;
	    private var tag:int; //byte to int
	    private var written:int;
	
	    /**
	     * Computes the CRC32C checksum of the supplied data and performs the "mask"
	     * operation on the computed checksum
	     * 
	     * @param data
	     *            The input data to calculate the CRC32C checksum of
	     */
//	    public static function calculateChecksum(data:InputByteBuffer):int //InputByteBuffer not implements in AS yet
//	    {
//	        return calculateChecksum(data, data.getIndex(), data.readableBytes());
//	    }
	
	    /**
	     * Computes the CRC32C checksum of the supplied data and performs the "mask"
	     * operation on the computed checksum
	     * 
	     * @param data
	     *            The input data to calculate the CRC32C checksum of
	     */
	    public static function calculateChecksum(data:InputByteBuffer, offset:int = data.getIndex(), length:int = data.readableBytes()):int	//overload with default arguments assignment
	    {
	        var crc32:Crc32c = new Crc32c(); //Crc32 not implements in AS yet
	        try
	        {
	            crc32.update(data.array(), offset, length);
	            return maskChecksum(int(crc32.getValue()));
	        }
	        finally
	        {
	            crc32.reset();
	        }
	    }
	
	    public function decode (bytes:ByteArray):ByteArray
	    {
	        var _in:InputByteBuffer = new InputByteBuffer(bytes);
	        var _out:OutputByteBuffer = new OutputByteBuffer(); //OutputByteBuffer not implements in AS yet
	        decode(_in, _out);
	        return _out.getBytes();
	    }
	
	    public function decode(_in:InputByteBuffer, _out:OutputByteBuffer):void
	    {
	        while (_in.isReadable())
	        {
	            switch (state)
	            {
	                case State.READY:
	                    state = State.READING_PREAMBLE;
	                case State.READING_PREAMBLE:
	                    var uncompressedLength:int = readPreamble(_in);
	                    if (uncompressedLength == PREAMBLE_NOT_FULL)
	                    {
	                        // We've not yet read all of the preamble, so wait until
	                        // we can
	                        return;
	                    }
	                    if (uncompressedLength == 0)
	                    {
	                        // Should never happen, but it does mean we have nothing
	                        // further to do
	                        state = State.READY;
	                        return;
	                    }
	                    _out.ensureWritable(uncompressedLength);
	                    state = State.READING_TAG;
	                case State.READING_TAG:
	                    if (!_in.isReadable())
	                    {
	                        return;
	                    }
	                    tag = _in.readByte();
	                    switch (tag & 0x03)
	                    {
	                        case LITERAL:
	                            state = State.READING_LITERAL;
	                            break;
	                        case COPY_1_BYTE_OFFSET:
	                        case COPY_2_BYTE_OFFSET:
	                        case COPY_4_BYTE_OFFSET:
	                            state = State.READING_COPY;
	                            break;
	                    }
	                    break;
	                case State.READING_LITERAL:
	                    var literalWritten:int = decodeLiteral(tag, _in, _out);
	                    if (literalWritten != NOT_ENOUGH_INPUT)
	                    {
	                        state = State.READING_TAG;
	                        written += literalWritten;
	                    }
	                    else
	                    {
	                        // Need to wait for more data
	                        return;
	                    }
	                    break;
	                case State.READING_COPY:
	                    var decodeWritten;int;
	                    switch (tag & 0x03)
	                    {
	                        case COPY_1_BYTE_OFFSET:
	                            decodeWritten = decodeCopyWith1ByteOffset(tag, _in, _out, written);
	                            if (decodeWritten != NOT_ENOUGH_INPUT)
	                            {
	                                state = State.READING_TAG;
	                                written += decodeWritten;
	                            }
	                            else
	                            {
	                                // Need to wait for more data
	                                return;
	                            }
	                            break;
	                        case COPY_2_BYTE_OFFSET:
	                            decodeWritten = decodeCopyWith2ByteOffset(tag, _in, _out, written);
	                            if (decodeWritten != NOT_ENOUGH_INPUT)
	                            {
	                                state = State.READING_TAG;
	                                written += decodeWritten;
	                            }
	                            else
	                            {
	                                // Need to wait for more data
	                                return;
	                            }
	                            break;
	                        case COPY_4_BYTE_OFFSET:
	                            decodeWritten = decodeCopyWith4ByteOffset(tag, _in, _out, written);
	                            if (decodeWritten != NOT_ENOUGH_INPUT)
	                            {
	                                state = State.READING_TAG;
	                                written += decodeWritten;
	                            }
	                            else
	                            {
	                                // Need to wait for more data
	                                return;
	                            }
	                            break;
	                    }
	            }
	        }
	    }
	
	    public function encode(_in:InputByteBuffer, _out:OutputByteBuffer):void
	    {
	        var length:int = _in.readableBytes();
	
	        // Write the preamble length to the output array
	        for (var i:int = 0;; i++)
	        {
	            var b:int = length >>> i * 7;
	            if ((b & 0xFFFFFF80) != 0)
	            {
	                _out.writeByte(int(b & 0x7f | 0x80)); //byte to int
	            }
	            else
	            {
	                _out.writeByte(int(b));
	                break;
	            }
	        }
	
	        var inIndex:int = 0;
	        const baseIndex:int = 0;
	
	        const short[] table = getHashTable(length);
	        const shift:int = 32 - (int(Math.floor(Math.log(table.length) / Math.log(2))));
	        var nextEmit:int = inIndex;
	
	        if (length - inIndex >= MIN_COMPRESSIBLE_BYTES)
	        {
	            var nextHash:int = hash(_in, ++inIndex, shift);
	            outer: while (true)
	            {
	                var skip:int = 32;
	                var candidate:int ;
	                var nextIndex:int = inIndex;
	                do
	                {
	                    inIndex = nextIndex;
	                    var hash:int = nextHash;
	                    var bytesBetweenHashLookups:int = skip++ >> 5;
	                    nextIndex = inIndex + bytesBetweenHashLookups;
	
	                    // We need at least 4 remaining bytes to read the hash
	                    if (nextIndex > length - 4)
	                    {
	                        break outer;
	                    }
	
	                    nextHash = hash(_in, nextIndex, shift);
	                    candidate = baseIndex + table[hash];
	                    table[hash] = (short) (inIndex - baseIndex);
	                } while (_in.getInt(inIndex) != _in.getInt(candidate));
	
	                encodeLiteral(_in, inIndex - nextEmit);
	
	                var insertTail:int;
	                do
	                {
	                    var base:int = inIndex;
	                    var matched:int = 4 + findMatchingLength(_in, candidate + 4, inIndex + 4, length);
	                    inIndex += matched;
	                    var offset:int = base - candidate;
	                    encodeCopy(_out, offset, matched);
	                    _in.setIndex(_in.getIndex() + matched);
	                    insertTail = inIndex - 1;
	                    nextEmit = inIndex;
	                    if (inIndex >= length - 4)
	                    {
	                        break outer;
	                    }
	
	                    var prevHash:int = hash(_in, insertTail, shift);
	                    table[prevHash] = (short) (inIndex - baseIndex - 1);
	                    var currentHash:int = hash(_in, insertTail + 1, shift);
	                    candidate = baseIndex + table[currentHash];
	                    table[currentHash] = (short) (inIndex - baseIndex);
	                } while (_in.getInt(insertTail + 1) == _in.getInt(candidate));
	
	                nextHash = hash(_in, insertTail + 2, shift);
	                ++inIndex;
	            }
	        }
	
	        // If there are any remaining characters, write them out as a literal
	        if (nextEmit < length)
	        {
	            encodeLiteral(_in, length - nextEmit);
	        }
	    }
	
	    public function encode(bytes:ByteArray):ByteArray
	    {
	        var _in:InputByteBuffer = new InputByteBuffer(bytes);
	        var _out:OutputByteBuffer = new OutputByteBuffer();
	        encode(_in, _out);
	        return _out.getBytes();
	    }
	
	    public function reset():void
	    {
	        state = State.READY;
	        tag = 0;
	        written = 0;
	    }
	
	    /**
	     * From the spec:
	     * <p/>
	     * "Checksums are not stored directly, but masked, as checksumming data and
	     * then its own checksum can be problematic. The masking is the same as used
	     * in Apache Hadoop: Rotate the checksum by 15 bits, then add the constant
	     * 0xa282ead8 (using wraparound as normal for unsigned integers)."
	     * 
	     * @param checksum
	     *            The actual checksum of the data
	     * @return The masked checksum
	     */
	    static function maskChecksum(checksum:int):int
	    {
	        return (checksum >> 15 | checksum << 17) + 0xa282ead8;
	    }
	
	    /**
	     * Computes the CRC32C checksum of the supplied data, performs the "mask"
	     * operation on the computed checksum, and then compares the resulting
	     * masked checksum to the supplied checksum.
	     * 
	     * @param expectedChecksum
	     *            The checksum decoded from the stream to compare against
	     * @param data
	     *            The input data to calculate the CRC32C checksum of
	     * @throws SnappyException
	     *             If the calculated and supplied checksums do not match
	     */
	    static function validateChecksum(expectedChecksum:int, data:InputByteBuffer, offset:int = data.getIndex(), length:int = data.readableBytes()):void	//overload with default arguments assignment
	    {
	        const actualChecksum:int = calculateChecksum(data, offset, length);
	        if (actualChecksum != expectedChecksum)
	        {
	            throw new SnappyException("mismatching checksum: " + Integer.toHexString(actualChecksum) + " (expected: "
	                    + Integer.toHexString(expectedChecksum) + ')');
	        }
	    }
	
	    /**
	     * Computes the CRC32C checksum of the supplied data, performs the "mask"
	     * operation on the computed checksum, and then compares the resulting
	     * masked checksum to the supplied checksum.
	     * 
	     * @param expectedChecksum
	     *            The checksum decoded from the stream to compare against
	     * @param data
	     *            The input data to calculate the CRC32C checksum of
	     * @throws SnappyException
	     *             If the calculated and supplied checksums do not match
	     */
//	    static function validateChecksum(expectedChecksum:int, data:InputByteBuffer):void
//	    {
//	        validateChecksum(expectedChecksum, data, data.getIndex(), data.readableBytes());
//	    }
	
	    /**
	     * Calculates the minimum number of bits required to encode a value. This
	     * can then in turn be used to calculate the number of septets or octets (as
	     * appropriate) to use to encode a length parameter.
	     * 
	     * @param value
	     *            The value to calculate the minimum number of bits required to
	     *            encode
	     * @return The minimum number of bits required to encode the supplied value
	     */
	    private static function bitsToEncode(value:int):int
	    {
	        var highestOneBit:int = Integer.highestOneBit(value);
	        var bitLength:int = 0;
	        while ((highestOneBit >>= 1) != 0)
	        {
	            bitLength++;
	        }
	
	        return bitLength;
	    }
	
	    /**
	     * Reads a compressed reference offset and length from the supplied input
	     * array, seeks back to the appropriate place in the input array and writes
	     * the found data to the supplied output stream.
	     * 
	     * @param tag
	     *            The tag used to identify this as a copy is also used to encode
	     *            the length and part of the offset
	     * @param in
	     *            The input array to read from
	     * @param out
	     *            The output array to write to
	     * @return The number of bytes appended to the output array, or -1 to
	     *         indicate "try again later"
	     * @throws SnappyException
	     *             If the read offset is invalid
	     */
	    private static function decodeCopyWith1ByteOffset(tag:byte, _in:InputByteBuffer, _out:OutputByteBuffer, writtenSoFar:int):int
	    {
	        if (!_in.isReadable())
	        {
	            return NOT_ENOUGH_INPUT;
	        }
	
	        var initialIndex:int = _out.getIndex();
	        var length:int = 4 + ((tag & 0x01c) >> 2);
	        var offset:int = (tag & 0x0e0) << 8 >> 5 | _in.readUnsignedByte();
	
	        validateOffset(offset, writtenSoFar);
	
	        if (offset < length)
	        {
	            var copies:int = length / offset;
	            for (; copies > 0; copies--)
	            {
	                _out.writeBytes(_out.array(), initialIndex - offset, offset);
	            }
	            if (length % offset != 0)
	            {
	                _out.writeBytes(_out.array(), initialIndex - offset, length % offset);
	            }
	        }
	        else
	        {
	            _out.writeBytes(_out.array(), initialIndex - offset, length);
	        }
	
	        return length;
	    }
	
	    /**
	     * Reads a compressed reference offset and length from the supplied input
	     * array, seeks back to the appropriate place in the input array and writes
	     * the found data to the supplied output stream.
	     * 
	     * @param tag
	     *            The tag used to identify this as a copy is also used to encode
	     *            the length and part of the offset
	     * @param in
	     *            The input array to read from
	     * @param out
	     *            The output array to write to
	     * @return The number of bytes appended to the output array, or -1 to
	     *         indicate "try again later"
	     * @throws SnappyException
	     *             If the read offset is invalid
	     */
	    private static function decodeCopyWith2ByteOffset(tag:byte, _in:InputByteBuffer, _out:OutputByteBuffer, writtenSoFar:int):int
	    {
	        if (_in.readableBytes() < 2)
	        {
	            return NOT_ENOUGH_INPUT;
	        }
	
	        var initialIndex:int = _out.getIndex();
	        var length:int = 1 + (tag >> 2 & 0x03f);
	        var offset:int = Bytes.swapShort(_in.readShort());
	
	        validateOffset(offset, writtenSoFar);
	
	        if (offset < length)
	        {
	            var copies:int = length / offset;
	            for (; copies > 0; copies--)
	            {
	                _out.writeBytes(_out.array(), initialIndex - offset, offset);
	            }
	            if (length % offset != 0)
	            {
	                _out.writeBytes(_out.array(), initialIndex - offset, length % offset);
	            }
	        }
	        else
	        {
	            _out.writeBytes(_out.array(), initialIndex - offset, length);
	        }
	
	        return length;
	    }
	
	    /**
	     * Reads a compressed reference offset and length from the supplied input
	     * array, seeks back to the appropriate place in the input array and writes
	     * the found data to the supplied output stream.
	     * 
	     * @param tag
	     *            The tag used to identify this as a copy is also used to encode
	     *            the length and part of the offset
	     * @param in
	     *            The input array to read from
	     * @param out
	     *            The output array to write to
	     * @return The number of bytes appended to the output array, or -1 to
	     *         indicate "try again later"
	     * @throws SnappyException
	     *             If the read offset is invalid
	     */
	    private static function decodeCopyWith4ByteOffset(tag:byte, _in:InputByteBuffer, _out:OutputByteBuffer, writtenSoFar:int):int
	    {
	        if readableBytes() < 4)
	        {
	            return NOT_ENOUGH_INPUT;
	        }
	
	        var initialIndex:int = _out.getIndex();
	        var length:int = 1 + (tag >> 2 & 0x03F);
	        var offset:int = Bytes.swapIntreadInt());
	
	        validateOffset(offset, writtenSoFar);
	
	        var inBuf:InputByteBuffer = new InputByteBuffer(_out.getBytes());
	        // _out.markReaderIndex();
	        if (offset < length)
	        {
	            var copies:int = length / offset;
	            for (; copies > 0; copies--)
	            {
	                _out.writeBytes(inBuf.array(), initialIndex - offset, offset);
	            }
	            if (length % offset != 0)
	            {
	                _out.writeBytes(inBuf.array(), initialIndex - offset, length % offset);
	            }
	        }
	        else
	        {
	            _out.writeBytes(inBuf.array(), initialIndex - offset, length);
	        }
	
	        return length;
	    }
	
	    /**
	     * Reads a literal from the input array directly to the output array. A
	     * "literal" is an uncompressed segment of data stored directly in the byte
	     * stream.
	     * 
	     * @param tag
	     *            The tag that identified this segment as a literal is also used
	     *            to encode part of the length of the data
	     * @param in
	     *            The input array to read the literal from
	     * @param out
	     *            The output array to write the literal to
	     * @return The number of bytes appended to the output array, or -1 to
	     *         indicate "try again later"
	     */
	    private static function decodeLiteral(tag:byte, _in:InputByteBuffer, _out:OutputByteBuffer):int
	    {
	        _in.markIndex();
	        var length:int;
	        switch (tag >> 2 & 0x3F)
	        {
	            case 60:
	                if (!_in.isReadable())
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = _in.readUnsignedByte();
	                break;
	            case 61:
	                if (_in.readableBytes() < 2)
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = Bytes.swapShort(_in.readShort());
	                break;
	            case 62:
	                if (_in.readableBytes() < 3)
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = Bytes.swapMedium(_in.readUnsignedMedium());
	                break;
	            case 64:
	                if (_in.readableBytes() < 4)
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = Bytes.swapInt(_in.readInt());
	                break;
	            default:
	                length = tag >> 2 & 0x3F;
	        }
	        length += 1;
	
	        if (_in.readableBytes() < length)
	        {
	            _in.resetIndex();
	            return NOT_ENOUGH_INPUT;
	        }
	
	        _out.writeBytes(_in.array(), _in.getIndex(), length);
	        _in.setIndex(_in.getIndex() + length);
	        return length;
	    }
	
	    /**
	     * Encodes a series of copies, each at most 64 bytes in length.
	     * 
	     * @param out
	     *            The output array to write the copy pointer to
	     * @param offset
	     *            The offset at which the original instance lies
	     * @param length
	     *            The length of the original instance
	     */
	    private static function encodeCopy(_out:OutputByteBuffer, offset:int, length:int):void
	    {
	        while (length >= 68)
	        {
	            encodeCopyWithOffset offset, 64);
	            length -= 64;
	        }
	
	        if (length > 64)
	        {
	            encodeCopyWithOffset offset, 60);
	            length -= 60;
	        }
	
	        encodeCopyWithOffset offset, length);
	    }
	
	    private static function encodeCopyWithOffset(_out:OutputByteBuffer, offset:int, length:int):void
	    {
	        if (length < 12 && offset < 2048)
	        {
	            _out.writeByte((byte) (COPY_1_BYTE_OFFSET | length - 4 << 2 | offset >> 8 << 5));
	            _out.writeByte((byte) (offset & 0x0ff));
	        }
	        else
	        {
	            _out.writeByte((byte) (COPY_2_BYTE_OFFSET | length - 1 << 2));
	            _out.writeByte((byte) (offset & 0x0ff));
	            _out.writeByte((byte) (offset >> 8 & 0x0ff));
	        }
	    }
	
	    /**
	     * Writes a literal to the supplied output array by directly copying from
	     * the input array. The literal is taken from the current readerIndex up to
	     * the supplied length.
	     * 
	     * @param in
	     *            The input array to copy from
	     * @param out
	     *            The output array to copy to
	     * @param length
	     *            The length of the literal to copy
	     */
	    private static function encodeLiteral(_in:InputByteBuffer, _out:OutputByteBuffer, length:int):void
	    {
	        if (length < 61)
	        {
	            _out.writeByte((byte) (length - 1 << 2));
	        }
	        else
	        {
	            var bitLength:int = bitsToEncode(length - 1);
	            var bytesToEncode:int = 1 + bitLength / 8;
	            _out.writeByte((byte) (59 + bytesToEncode << 2));
	            for (var i:int = 0; i < bytesToEncode; i++)
	            {
	                _out.writeByte((byte) (length - 1 >> i * 8 & 0x0ff));
	            }
	        }
	
	        _out.writeBytes(_in.array(), _in.getIndex(), length);
	        _in.setIndex(_in.getIndex() + length);
	    }
	
	    /**
	     * Iterates over the supplied input array between the supplied minIndex and
	     * maxIndex to find how long our matched copy overlaps with an
	     * already-written literal value.
	     * 
	     * @param in
	     *            The input array to scan over
	     * @param minIndex
	     *            The index in the input array to start scanning from
	     * @param inIndex
	     *            The index of the start of our copy
	     * @param maxIndex
	     *            The length of our input array
	     * @return The number of bytes for which our candidate copy is a repeat of
	     */
	    private static function findMatchingLength(_in:InputByteBuffer, minIndex:int, inIndex:int, maxIndex:int):int
	    {
	        var matched:int = 0;
	
	        while (inIndex <= maxIndex - 4 && _in.getInt(inIndex) == _in.getInt(minIndex + matched))
	        {
	            inIndex += 4;
	            matched += 4;
	        }
	
	        while (inIndex < maxIndex && _in.getByte(minIndex + matched) == _in.getByte(inIndex))
	        {
	            ++inIndex;
	            ++matched;
	        }
	
	        return matched;
	    }
	
	    /**
	     * Creates an appropriately sized hashtable for the given input size
	     * 
	     * @param inputSize
	     *            The size of our input, ie. the number of bytes we need to
	     *            encode
	     * @return An appropriately sized empty hashtable
	     */
	    private static function short[] getHashTable(int inputSize)
	    {
	        var htSize:int = 256;
	        while (htSize < MAX_HT_SIZE && htSize < inputSize)
	        {
	            htSize <<= 1;
	        }
	
	        short[] table;
	        if (htSize <= 256)
	        {
	            table = new short[256];
	        }
	        else
	        {
	            table = new short[MAX_HT_SIZE];
	        }
	
	        return table;
	    }
	
	    /**
	     * Hashes the 4 bytes located at index, shifting the resulting hash into the
	     * appropriate range for our hash table.
	     * 
	     * @param in
	     *            The input array to read 4 bytes from
	     * @param index
	     *            The index to read at
	     * @param shift
	     *            The shift value, for ensuring that the resulting value is
	     *            withing the range of our hash table size
	     * @return A 32-bit hash of 4 bytes located at index
	     */
	    private static function hash(_in:InputByteBuffer, index:int, shift:int):int
	    {
	        return _in.getInt(index) + 0x1e35a7bd >>> shift;
	    }
	
	    /**
	     * Reads the length varint (a series of bytes, where the lower 7 bits are
	     * data and the upper bit is a flag to indicate more bytes to be read).
	     * 
	     * @param in
	     *            The input array to read the preamble from
	     * @return The calculated length based on the input array, or 0 if no
	     *         preamble is able to be calculated
	     */
	    private static function readPreamble(_in:InputByteBuffer):int
	    {
	        var length:int = 0;
	        var byteIndex:int = 0;
	        while (_in.isReadable())
	        {
	            var current:int = _in.readUnsignedByte();
	            length |= (current & 0x7f) << byteIndex++ * 7;
	            if ((current & 0x80) == 0)
	            {
	                return length;
	            }
	
	            if (byteIndex >= 4)
	            {
	                throw new SnappyException("Preamble is greater than 4 bytes");
	            }
	        }
	
	        return 0;
	    }
	
	    /**
	     * Validates that the offset extracted from a compressed reference is within
	     * the permissible bounds of an offset (4 <= offset <= 32768), and does not
	     * exceed the length of the chunk currently read so far.
	     * 
	     * @param offset
	     *            The offset extracted from the compressed reference
	     * @param chunkSizeSoFar
	     *            The number of bytes read so far from this chunk
	     * @throws SnappyException
	     *             if the offset is invalid
	     */
	    private static function validateOffset(offset:int, chunkSizeSoFar:int):void
	    {
	        if (offset > Short.MAX_VALUE)
	        {
	            throw new SnappyException("Offset exceeds maximum permissible value");
	        }
	
	        if (offset <= 0)
	        {
	            throw new SnappyException("Offset is less than minimum permissible value");
	        }
	
	        if (offset > chunkSizeSoFar)
	        {
	            throw new SnappyException("Offset exceeds size of chunk");
	        }
	    }
		
//		private final class State
//		{
//			public static const READY:int = 0;
//			public static const READING_PREAMBLE:int = 1;
//			public static const READING_TAG:int = 2;
//			public static const READING_LITERAL:int = 3;
//			public static const READING_COPY:int = 4;
//		}
	}
}
