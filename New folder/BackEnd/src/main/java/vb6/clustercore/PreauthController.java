package vb6.clustercore;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import vb6.clustercore.LoginRegisterResponse;
import vb6.clustercore.UserRepository;
import vb6.clustercore.AuthService;

/*
 * The preauth controller handles all requests from clients that have not been authorized yet.
 * This includes login and register requests.
 */

@RestController
public class PreauthController {
	@Autowired
	private UserRepository user_repo;
	
	@Autowired
	private AuthService auth_control;
	
	private final String INVALID_VALUE = "<invalid>";
	
	/*
	 * Handle register requests.
	 * Walks through existing Users and ensures there is no clashing information, then
	 * generates a new auth key and saves a row to the database.
	 */
	
	@RequestMapping("/register")
	public LoginRegisterResponse register(@RequestParam(value="username", defaultValue=INVALID_VALUE) String username,
								  @RequestParam(value="password", defaultValue=INVALID_VALUE) String password,
								  @RequestParam(value="email", defaultValue=INVALID_VALUE) String email) {
		
		if (username.equals(INVALID_VALUE) || password.equals(INVALID_VALUE) || email.equals(INVALID_VALUE)) {
			return new LoginRegisterResponse(false, "Invalid request!");
		}
		
		/* Check for conflicting names or emails */
		for (User cur : user_repo.findAll()) {
			if (cur.getUsername().equals(username)) {
				return new LoginRegisterResponse(false, "Username is already taken!");
			} else if (cur.getEmail().equals(email)) {
				return new LoginRegisterResponse(false, "Email is already registered!");
			}
		}
		
		/* Generate a new User entry */
		User u = new User();
		u.setUsername(username);
		u.setAuthkey(Crypto.createNewKey(password));
		u.setEmail(email);
		
		user_repo.save(u);
		
		return new LoginRegisterResponse(true, "Account created!");
	}
	
	/*
	 * TODO: login requests
	 * 
	 * Login requests can be handled very similar to register requests.
	 * The correct User row needs to be located in the database, then the password needs to be tested
	 * against the saved key using Crypto.verifyExistingKey().
	 * 
	 * The handler should return a LoginRegisterResponse indicating the status of the login.
	 * 
	 * If the login fails, the status should be false and the 'message' field can describe why the login failed.
	 * 
	 * If the login is successful, a new session needs to be created for the user with AuthService:createSession().
	 * The new session token can be sent back to the user in the 'message' field.
	 */
	
	@RequestMapping("/login")
	public LoginRegisterResponse login(@RequestParam(value="username", defaultValue=INVALID_VALUE) String username,
			  @RequestParam(value="password", defaultValue=INVALID_VALUE) String password){
		
		if (username.equals(INVALID_VALUE) || password.equals(INVALID_VALUE)) {
			return new LoginRegisterResponse(false, "Missing username or password.");
		}
		
		/* Check for user name and matching password*/
		for (User cur : user_repo.findAll()) {
			if (cur.getUsername().equals(username)) {
				if (Crypto.verifyExistingKey(cur.getAuthkey(), password)){
					String token = auth_control.createSession(cur);
					return new LoginRegisterResponse(true, token);
				}
				else{
					return new LoginRegisterResponse(false,"Incorrect Password.");
				}
			}
		}
		return new LoginRegisterResponse(false,"Username does not exist.");
	}
	
}
