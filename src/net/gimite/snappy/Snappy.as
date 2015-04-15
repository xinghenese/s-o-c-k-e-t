package net.gimite.snappy
{
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.logger.Logger;
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
	
	    private var state:int = State.READY;
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
//	        return calculateChecksum(data, data.position, data.bytesAvailable);
//	    }
	
	    /**
	     * Computes the CRC32C checksum of the supplied data and performs the "mask"
	     * operation on the computed checksum
	     * 
	     * @param data
	     *            The input data to calculate the CRC32C checksum of
	     */
	    public static function calculateChecksum(data:InputByteBuffer, offset:int = 0, length:int = 0):int	//overload with default arguments assignment
	    {
			offset = offset || data.position;
			length = length || data.bytesAvailable;
	        var crc32:Crc32c = new Crc32c(); //Crc32 not implements in AS yet
//	        try
//	        {
//	            crc32.update(data, offset, length);
//	            return maskChecksum(int(crc32.getValue()));
//	        }
//			catch(e:Error)
//			{
//				return 0;
//			}
//	        finally
//	        {
//	            crc32.reset();
//	        }

//			var arr:Array = Crc32c.crc32table(1);
//			for(var i:int = 0, len:int = arr.length; i < len; i++){
//				Logger.log("CRC32_TABLE[" + i + "]: " + int(arr[i]).toString(16));
//			}

//			Logger.info("ENTITY", data.toString());
//			Logger.info("ENTITY", ByteArrayUtil.toArrayString(data));
			crc32.update(data, offset, length);
			var value:int = crc32.getValue();
//			Logger.info("CRC32", value.toString());
//			Logger.info("CRC32", ByteArrayUtil.toByteString(value));
			crc32.reset();
//			Logger.info("MASK_CHECKSUM", (maskChecksum(value)).toString());
//			Logger.info("MASK_CHECKSUM", ByteArrayUtil.toByteString(maskChecksum(value)));
            return maskChecksum(value);
	    }
	
//	    public function decode (bytes:ByteArray):ByteArray
//	    {
//	        var bytesIn:InputByteBuffer = InputByteBuffer(bytes);
//	        var bytesOut:OutputByteBuffer = new OutputByteBuffer(); //OutputByteBuffer not implements in AS yet
//	        decode(bytesIn, bytesOut);
//	        return bytesOut.getBytes();
//	    }
	
	    public function decode(bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer):void
	    {
//			Logger.log('snappy decoding starts');
//			Logger.info('bytesIn', ByteArrayUtil.toArrayString(bytesIn));
	        while (bytesIn.isReadable())
	        {
	            switch (state)
	            {
	                case State.READY:
//						Logger.info('state', State.getState(state));
	                    state = State.READING_PREAMBLE;
	                case State.READING_PREAMBLE:					
//						Logger.info('state', State.getState(state));
	                    var uncompressedLength:int = readPreamble(bytesIn);
//						Logger.info('uncompressedLength', uncompressedLength);
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
	                    bytesOut.ensureWritable(uncompressedLength);
	                    state = State.READING_TAG;
	                case State.READING_TAG:
//						Logger.info('state', State.getState(state));
	                    if (!bytesIn.isReadable())
	                    {
	                        return;
	                    }
	                    tag = bytesIn.readByte();
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
//						Logger.info('state', State.getState(state));
	                    var literalWritten:int = decodeLiteral(tag, bytesIn, bytesOut);
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
//						Logger.info('state', State.getState(state));
	                    var decodeWritten:int;
	                    switch (tag & 0x03)
	                    {
	                        case COPY_1_BYTE_OFFSET:
	                            decodeWritten = decodeCopyWith1ByteOffset(tag, bytesIn, bytesOut, written);
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
	                            decodeWritten = decodeCopyWith2ByteOffset(tag, bytesIn, bytesOut, written);
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
	                            decodeWritten = decodeCopyWith4ByteOffset(tag, bytesIn, bytesOut, written);
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
	
	    public function encode(bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer):void
	    {
	        var length:int = bytesIn.bytesAvailable;
				
	        // Write the preamble length to the output array
	        //将报文长度写入输出数组
	        //采用小端字节序，将报文长度的有效数字依照每组七位分组，除大端组外，其余各组加前缀1，补齐1字节。而大端组前缀为0。最后将各组依从小端到大端的顺序写入输出数组中。
	        for (var i:int = 0;; i++)
	        {
	            var b:int = length >>> i * 7; //依次从后往前取七位数（第一次从末尾第八位开始）
	            if ((b & 0xFFFFFF80) != 0) //若以后每次取到均为0，则退出
	            {
	                bytesOut.writeByte(b & 0x7f | 0x80); //在取得的七位数前加前缀1，补齐1字节，并写入到bytesOut中
	            }
	            else
	            {
	                bytesOut.writeByte(b);
	                break;
	            }
	        }
	
	        var inIndex:int = 0;
	        const baseIndex:int = 0;
	
	        const table:Array = getHashTable(length);//short[] to ByteArray
	        const shift:int = 32 - (int(Math.floor(Math.log(table.length) / Math.log(2)))); //shift = 32 - [log2(length)] = 32 - 14 or 32 - 8
	        var nextEmit:int = inIndex;
	
	        if (length - inIndex >= MIN_COMPRESSIBLE_BYTES)
	        {
	            var nextHash:int = getHash(bytesIn, ++inIndex, shift);
	            outer: while (true)
	            {
	                var skip:int = 32;
	                var candidate:int;
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
	
	                    nextHash = getHash(bytesIn, nextIndex, shift);
	                    candidate = baseIndex + table[hash];
	                    table[hash] = Bytes.toShort(inIndex - baseIndex);
	                } while (bytesIn.getInt(inIndex) != bytesIn.getInt(candidate));
	
	                encodeLiteral(bytesIn, bytesOut, inIndex - nextEmit);
	
	                var insertTail:int;
	                do
	                {
	                    var base:int = inIndex;
	                    var matched:int = 4 + findMatchingLength(bytesIn, candidate + 4, inIndex + 4, length);
	                    inIndex += matched;
	                    var offset:int = base - candidate;
	                    encodeCopy(bytesOut, offset, matched);
	                    bytesIn.setIndex(bytesIn.position + matched);
	                    insertTail = inIndex - 1;
	                    nextEmit = inIndex;
	                    if (inIndex >= length - 4)
	                    {
	                        break outer;
	                    }
	
	                    var prevHash:int = getHash(bytesIn, insertTail, shift);
	                    table[prevHash] = Bytes.toShort(inIndex - baseIndex - 1);
	                    var currentHash:int = getHash(bytesIn, insertTail + 1, shift);
	                    candidate = baseIndex + table[currentHash];
	                    table[currentHash] = Bytes.toShort(inIndex - baseIndex);
	                } while (bytesIn.getInt(insertTail + 1) == bytesIn.getInt(candidate));
	
	                nextHash = getHash(bytesIn, insertTail + 2, shift);
	                ++inIndex;
	            }
	        }
	
	        // If there are any remaining characters, write them out as a literal
	        if (nextEmit < length)
	        {
	            encodeLiteral(bytesIn, bytesOut, length - nextEmit);
	        }
	    }
	
//	    public function encode(bytes:ByteArray):ByteArray
//	    {
//	        var bytesIn:InputByteBuffer = InputByteBuffer(bytes);
//	        var bytesOut:OutputByteBuffer = new OutputByteBuffer();
//	        encode(bytesIn, bytesOut);
//	        return bytesOut.getBytes();
//	    }
	
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
	    static function validateChecksum(expectedChecksum:int, data:InputByteBuffer, offset:int = 0, length:int = 0):void	//overload with default arguments assignment
	    {
			offset = offset || data.position;
			length = length || data.bytesAvailable;
	        const actualChecksum:int = calculateChecksum(data, offset, length);
	        if (actualChecksum != expectedChecksum)
	        {
	            throw new SnappyException("mismatching checksum: " + actualChecksum.toString(16) + " (expected: "
	                    + expectedChecksum.toString(16) + ')');
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
//	        validateChecksum(expectedChecksum, data, data.position, data.bytesAvailable);
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
	        var highestOneBit:int = Bytes.highestOneBit(value);
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
	    private static function decodeCopyWith1ByteOffset(tag:int, bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer, writtenSoFar:int):int
	    {
			tag = Bytes.toByte(tag);
	        if (!bytesIn.isReadable())
	        {
	            return NOT_ENOUGH_INPUT;
	        }
	
	        var initialIndex:int = bytesOut.position;
	        var length:int = 4 + ((tag & 0x01c) >> 2);
	        var offset:int = (tag & 0x0e0) << 8 >> 5 | bytesIn.readUnsignedByte();
	
	        validateOffset(offset, writtenSoFar);
	
	        if (offset < length)
	        {
	            var copies:int = length / offset;
	            for (; copies > 0; copies--)
	            {
	                bytesOut.writeBytes(bytesOut, initialIndex - offset, offset);
	            }
	            if (length % offset != 0)
	            {
	                bytesOut.writeBytes(bytesOut, initialIndex - offset, length % offset);
	            }
	        }
	        else
	        {
	            bytesOut.writeBytes(bytesOut, initialIndex - offset, length);
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
	    private static function decodeCopyWith2ByteOffset(tag:int, bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer, writtenSoFar:int):int
	    {
			tag = Bytes.toByte(tag);
	        if (bytesIn.bytesAvailable < 2)
	        {
	            return NOT_ENOUGH_INPUT;
	        }
	
	        var initialIndex:int = bytesOut.position;
	        var length:int = 1 + (tag >> 2 & 0x03f);
	        var offset:int = Bytes.swapShort(bytesIn.readShort());
	
	        validateOffset(offset, writtenSoFar);
	
	        if (offset < length)
	        {
	            var copies:int = length / offset;
	            for (; copies > 0; copies--)
	            {
	                bytesOut.writeBytes(bytesOut, initialIndex - offset, offset);
	            }
	            if (length % offset != 0)
	            {
	                bytesOut.writeBytes(bytesOut, initialIndex - offset, length % offset);
	            }
	        }
	        else
	        {
	            bytesOut.writeBytes(bytesOut, initialIndex - offset, length);
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
	    private static function decodeCopyWith4ByteOffset(tag:int, bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer, writtenSoFar:int):int
	    {
			tag = Bytes.toByte(tag);
	        if (bytesIn.bytesAvailable < 4)
	        {
	            return NOT_ENOUGH_INPUT;
	        }
	
	        var initialIndex:int = bytesOut.position;
	        var length:int = 1 + (tag >> 2 & 0x03F);
	        var offset:int = Bytes.swapInt(bytesIn.readInt());
	
	        validateOffset(offset, writtenSoFar);
	
	        var inBuf:InputByteBuffer = bytesOut.getBytes() as InputByteBuffer;
	        // bytesOut.markReaderIndex();
	        if (offset < length)
	        {
	            var copies:int = length / offset;
	            for (; copies > 0; copies--)
	            {
	                bytesOut.writeBytes(inBuf, initialIndex - offset, offset);
	            }
	            if (length % offset != 0)
	            {
	                bytesOut.writeBytes(inBuf, initialIndex - offset, length % offset);
	            }
	        }
	        else
	        {
	            bytesOut.writeBytes(inBuf, initialIndex - offset, length);
	        }
	
	        return length;
	    }
	    import flash.utils.ByteArray;
	
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
	    private static function decodeLiteral(tag:int, bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer):int
	    {
			tag = Bytes.toByte(tag);
	        bytesIn.markIndex();
	        var length:int;
	        switch (tag >> 2 & 0x3F)
	        {
	            case 60:
	                if (!bytesIn.isReadable())
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = bytesIn.readUnsignedByte();
	                break;
	            case 61:
	                if (bytesIn.bytesAvailable < 2)
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = Bytes.swapShort(bytesIn.readShort());
	                break;
	            case 62:
	                if (bytesIn.bytesAvailable < 3)
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = Bytes.swapMedium(bytesIn.readUnsignedMedium());
	                break;
	            case 64:
	                if (bytesIn.bytesAvailable < 4)
	                {
	                    return NOT_ENOUGH_INPUT;
	                }
	                length = Bytes.swapInt(bytesIn.readInt());
	                break;
	            default:
	                length = tag >> 2 & 0x3F;
	        }
	        length += 1;
	
	        if (bytesIn.bytesAvailable < length)
	        {
	            bytesIn.resetIndex();
	            return NOT_ENOUGH_INPUT;
	        }
	
	        bytesOut.writeBytes(bytesIn, bytesIn.position, length);
	        bytesIn.setIndex(bytesIn.position + length);
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
	    private static function encodeCopy(bytesOut:OutputByteBuffer, offset:int, length:int):void
	    {
	        while (length >= 68)
	        {
	            encodeCopyWithOffset(bytesOut, offset, 64);
	            length -= 64;
	        }
	
	        if (length > 64)
	        {
	            encodeCopyWithOffset(bytesOut, offset, 60);
	            length -= 60;
	        }
	
	        encodeCopyWithOffset(bytesOut, offset, length);
	    }
	
	    private static function encodeCopyWithOffset(bytesOut:OutputByteBuffer, offset:int, length:int):void
	    {
	        if (length < 12 && offset < 2048)
	        {
	            bytesOut.writeByte(COPY_1_BYTE_OFFSET | length - 4 << 2 | offset >> 8 << 5);
	            bytesOut.writeByte(offset & 0x0ff);
	        }
	        else
	        {
	            bytesOut.writeByte(COPY_2_BYTE_OFFSET | length - 1 << 2);
	            bytesOut.writeByte(offset & 0x0ff);
	            bytesOut.writeByte(offset >> 8 & 0x0ff);
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
	    private static function encodeLiteral(bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer, length:int):void
	    {
	        if (length < 61)
	        {
	            bytesOut.writeByte(length - 1 << 2);
	        }
	        else
	        {
	            var bitLength:int = bitsToEncode(length - 1);
	            var bytesToEncode:int = 1 + bitLength / 8;
	            bytesOut.writeByte(59 + bytesToEncode << 2);
	            for (var i:int = 0; i < bytesToEncode; i++)
	            {
	                bytesOut.writeByte(length - 1 >> i * 8 & 0x0ff);
	            }
	        }
	
	        bytesOut.writeBytes(bytesIn, bytesIn.position, length);
	        bytesIn.setIndex(bytesIn.position + length);
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
	    private static function findMatchingLength(bytesIn:InputByteBuffer, minIndex:int, inIndex:int, maxIndex:int):int
	    {
	        var matched:int = 0;
	
	        while (inIndex <= maxIndex - 4 && bytesIn.getInt(inIndex) == bytesIn.getInt(minIndex + matched))
	        {
	            inIndex += 4;
	            matched += 4;
	        }
	
	        while (inIndex < maxIndex && bytesIn.getByte(minIndex + matched) == bytesIn.getByte(inIndex))
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
	    private static function getHashTable(inputSize:int):Array	//short[] to ByteArray
	    {
	        var htSize:int = 256;
	        while (htSize < MAX_HT_SIZE && htSize < inputSize)
	        {
	            htSize <<= 1;
	        }
	
	        var table:Array = [];	//short[] to ByteArray
	        if(htSize > 256)
			{
				htSize = MAX_HT_SIZE;
			}
			
			for(var i:int = 0; i < htSize; i++)
			{
				table.push(0);
			}
	        
//	        if (htSize <= 256)
//	        {
//	            table = new short[256];
//	        }
//	        else
//	        {
//	            table = new short[MAX_HT_SIZE];
//	        }
	
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
	     *            within the range of our hash table size
	     * @return A 32-bit hash of 4 bytes located at index
	     */
	    private static function getHash(bytesIn:InputByteBuffer, index:int, shift:int):int
	    {
	        return bytesIn.getInt(index) + 0x1e35a7bd >>> shift;
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
	    private static function readPreamble(bytesIn:InputByteBuffer):int
	    {
	        var length:int = 0;
	        var byteIndex:int = 0;
	        while (bytesIn.bytesAvailable)
	        {
//				Logger.info('bytesIn', ByteArrayUtil.toArrayString(bytesIn, false));
	            var current:int = bytesIn.readUnsignedByte();
//				Logger.info('current', current);
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
	        if (offset > Bytes.SHORT_MAX_VALUE)
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