package vb6.clustercore;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/*
 * The AuthService provides an API for creating and verifying user sessions.
 */
@Service
public class AuthService {
	@Autowired
	private UserRepository user_repo;
	
	public String createSession(User u) {
		String new_tok = Crypto.createNewToken(u.getId().longValue());
		
		u.setToken(new_tok);
		user_repo.save(u);
		
		return new_tok;
	}

	public Optional<User> verifySession(String tok) {
		System.out.println("Verifying session token : " + tok);
		
		/* Grab the id from the beginning of the token */
		Integer id = Integer.parseInt(tok.split(":")[0]);
		Optional<User> dest = user_repo.findById(id);
		
		if (!dest.isPresent()) {
			System.out.println("verifySession: couldn't find user associated with ID " + id);
			return dest; /* No such user */
		}
		
		if (dest.get().getToken().equals(tok)) {
			System.out.println("verifySession: verified good token for user ID " + id);
			return dest;
		} else {
			System.out.println("verifySession: invalid token for user ID " + id + " : expected token " + dest.get().getToken() + " , got " + tok);
			return Optional.empty(); /* Bad token */
		}
	}
}