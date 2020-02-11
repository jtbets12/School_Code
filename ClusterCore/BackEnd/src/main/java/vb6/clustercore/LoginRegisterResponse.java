package vb6.clustercore;

public class LoginRegisterResponse {
	private boolean status;
	private String message;
	
	public LoginRegisterResponse(boolean status, String message) {
		this.status = status;
		this.message = message;
	}
	
	public boolean getStatus() {
		return status;
	}
	
	public String getMessage() {
		return message;
	}
}