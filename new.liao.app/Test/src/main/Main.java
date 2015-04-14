package main;

import java.util.Arrays;

import socket.SnappySocket;

public class Main {

	public static void main(String[] args)
	{
		SnappySocket socket = new SnappySocket();
		
		String strRawData = "<HSK pbk=\"XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA=\"></HSK>";
		byte[] bsRawData = strRawData.getBytes();
		
		
		byte[] bytesIn = {
				0, 0, 0, -44, -1, 6, 0, 0, 115, 78, 97, 80, 112, 89, -58, 0, 0, 0, -128, 
				-12, 44, -104, -66, 1, -16, -67, 60, 72, 83, 75, 32, 112, 98, 107, 61, 34, 
				88, 72, 66, 120, 101, 118, 109, 111, 56, 108, 65, 101, 51, 52, 120, 77, 56, 
				55, 106, 69, 43, 51, 100, 89, 120, 102, 69, 79, 104, 110, 106, 113, 116, 47, 
				67, 97, 50, 73, 52, 80, 90, 107, 57, 83, 111, 114, 71, 53, 118, 43, 110, 115, 
				52, 100, 98, 69, 110, 50, 118, 79, 111, 85, 108, 102, 83, 99, 70, 66, 73, 65, 
				104, 116, 48, 98, 121, 108, 120, 105, 105, 66, 113, 50, 55, 121, 51, 73, 97, 
				48, 56, 97, 68, 69, 89, 113, 101, 54, 98, 47, 120, 56, 117, 117, 66, 71, 102, 
				82, 109, 117, 65, 99, 57, 79, 84, 52, 101, 76, 70, 101, 74, 115, 114, 109, 109, 
				122, 68, 122, 68, 116, 84, 73, 111, 87, 72, 80, 110, 82, 118, 57, 86, 48, 52, 
				53, 111, 73, 75, 86, 110, 82, 78, 53, 103, 105, 114, 120, 57, 109, 117, 112, 
				104, 104, 76, 47, 65, 86, 83, 80, 81, 51, 108, 71, 65, 61, 34, 62, 60, 47, 72, 
				83, 75, 62
		};
		
		log("Original");
		info("Raw", "ByteString", strRawData);
		info("Raw", "ByteArray", Arrays.toString(bsRawData));
		log();
		
		byte[] bytesOut = null;
		try {
			bytesOut = socket.encode(bsRawData);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally{
			log("Result");
			info("Encode", "ByteString", new String(bytesOut));
			info("Encode", "ByteArray", Arrays.toString(bytesOut));
			log();
		}
		
		if (bytesOut != null)
		{
			byte[] bytesDecode = null;			
			try {
				bytesDecode = socket.decode(bytesOut);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			finally{
				log("Result");
				info("Decode", "ByteString", new String(bytesDecode));
				info("Decode", "ByteArray", Arrays.toString(bytesDecode));
				log();
			}
		}
		
		
	}
	
	private static void info(String type1, String type2, String msg)
	{
		System.out.print("[" + type1 + "-" + type2 + "]\t" + msg + "\n");
	}
	
	private static void info(String type, String msg)
	{
		System.out.print("[" + type + "]\t" + msg + "\n");
	}
	
	private static void log(){
		log("");
	}
	
	private static void log(String msg)
	{
		System.out.print(msg + "\n");
	}
	
}
