package net.gimite.hellman
{
	/**
	 * @author Reco
	 * 
	 * a mechanism served for symmetric-key encryption
	 */
	public interface KeyExchange
	{
		/**
		 * encrypt the secret key created locally (and always randomly) as a public key
		 * ready to be transfered to the remote server. 
		 */
		function getPublicKey():String;
		
		/**
		 * create a shared key with the local secret key and the public key received
		 * from the remote server.
		 */
//		function getSharedKey(pub:*):*;
		
		/**
		 * create an encrypt key by processing the shared key by means of encryption 
		 * or/and hashing, encoding.
		 */
		function getEncryptKey(pub:* = null):String;
	}
}
