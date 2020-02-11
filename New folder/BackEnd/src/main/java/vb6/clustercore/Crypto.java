package vb6.clustercore;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/*
 * This class implements all of the needed cryptography for the backend, both at runtime and for storage.
 */
public class Crypto {
	/* Password KDF configuration */
	private final static int SALT_LEN = 16;
	private final static int KDF_ITERATIONS = 1000;
	private final static int KDF_SIZE = 256;
	
	/* Array to help conversion from byte[] => hex */
	private static final char[] HEX_ARRAY = "0123456789ABCDEF".toCharArray();
	
	/* -- EXTERNAL FUNCTIONS -- use these! */
	
	/*
	 * createNewKey(password)
	 * 
	 * Generates a new secure key and salt for a password. The string returned should be stored in the database.
	 * If something goes wrong during key generation, a message will be printed to the log and this function will return null.
	 */
	public static String createNewKey(String password) {
		try {
			return genDerivedKey(KDF_ITERATIONS, password, genSalt());
		} catch (Exception e) {
			System.out.println("Unexpected exception occurred during key derivation: " + e.getMessage());
			e.printStackTrace();
			
			return null;
		}
	}
	
	/*
	 * verifyExistingKey(keystr, password)
	 * 
	 * Verifies that a password matches a stored key string.
	 * <keystr> should be pulled from the database (generated from createNewKey()) and <password> should be the attempted password.
	 * 
	 * Returns true if the password matches the key, or false if something went wrong.
	 */
	public static boolean verifyExistingKey(String keystr, String password) {
		String[] key_elems = keystr.split(":");
		
		if (key_elems.length != 3) {
			/* Key string is invalid. */
			return false;
		}
		
		/* Parse out the salt and iterations. */
		int iters = Integer.parseInt(key_elems[0]);
		byte[] salt = decodeHex(key_elems[1]);
		
		/* Try and generate a new key. */
		
		try {
			String test_key = genDerivedKey(iters, password, salt);
			
			if (test_key.equals(keystr)) {
				return true; /* Key string matches. Verified! */
			}
		} catch (Exception e) {
			System.out.println("Unexpected exception occurred during key derivation: " + e.getMessage());
			e.printStackTrace();
		}
		
		return false;
	}
	
	/*
	 * createNewToken() creates a new session token for a user.
	 * This just generates a random string encoded along with the user ID.
	 */
	public static String createNewToken(Long user_id) {
		try {
			return user_id + ":" + encodeHex(genSalt());
		} catch (Exception e) {
			System.out.println("Unexpected exception generating token: " + e.getMessage());
			return user_id + ":" + "SADFACE";
		}
	}
	
	/* -- INTERNAL FUNCTIONS -- */
	
	/*
	 * Generate a random salt using SHA-1 CSPRNG
	 */
	private static byte[] genSalt() throws NoSuchAlgorithmException {
		SecureRandom rng = new SecureRandom();
		byte[] salt = new byte[SALT_LEN];
		rng.nextBytes(salt);
		return salt;
	}
	
	/*
	 * Generate derived key string from password and salt.
	 */
	private static String genDerivedKey(int iterations, String password, byte[] salt) throws NoSuchAlgorithmException, InvalidKeySpecException {
		char[] pw_chars = password.toCharArray();
		
		PBEKeySpec kspec = new PBEKeySpec(pw_chars, salt, iterations, KDF_SIZE);
		SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
		byte[] hash_data = skf.generateSecret(kspec).getEncoded();
		
		return iterations + ":" + encodeHex(salt) + ":" + encodeHex(hash_data);
	}
	
	/*
	 * Encode bytes into a hexadecimal string.
	 */
	private static String encodeHex(byte[] data) {
		char[] output = new char[data.length * 2];
		
		for (int i = 0; i < data.length; ++i) {
			/* grab nybbles from each byte */
			
			int val = data[i] & 0xFF;
			output[i * 2] = HEX_ARRAY[val >>> 4];
			output[i * 2 + 1] = HEX_ARRAY[val & 0xF];
		}
		
		return new String(output);
	}
	
	/*
	 * Decode bytes from a hexadecimal string.
	 */
	private static byte[] decodeHex(String hex) {
		int len = hex.length();
		byte[] output = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			output[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4) |
								   (Character.digit(hex.charAt(i + 1), 16)));
		}
		
		return output;
	}
}
