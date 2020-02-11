import vb6.clustercore.Crypto;

import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;

import org.junit.Test;

public class CryptoTest {
	@Test
	public void testCreateNewKey() {
		/* Verify a key string can be generated without throwing any exceptions. */
		System.out.println("Generated random secure key: " + Crypto.createNewKey(""));
	}
	
	@Test
	public void testVerifyExistingKey() {
		String pw = "test_password_123";
		String keystr = Crypto.createNewKey(pw);
		
		assertTrue(Crypto.verifyExistingKey(keystr,  pw));
	}
	
	@Test
	public void testCreateNewToken() {
		System.out.println("Generated random token: " + Crypto.createNewToken(0L));
	}
}
