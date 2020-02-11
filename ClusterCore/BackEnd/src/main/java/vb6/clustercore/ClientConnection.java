package vb6.clustercore;

import java.io.IOException;

import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.google.gson.JsonObject;

/* The ClientConnection acts as a wrapper around the WebSocketSession */
public class ClientConnection {
	private WebSocketSession session;
	private boolean authed;
	private String token;
	private String username;
	
	public ClientConnection(WebSocketSession s) {
		this.session = s;
		this.authed = false;
		this.username = "<unauthenticated>";
		this.token = "<unauthenticated>";
	}
	
	public void write(JsonObject obj) {
		try {
			this.session.sendMessage(new TextMessage(obj.toString()));
		} catch (IOException e) {
			System.out.println("Error writing to " + getRemote() + " : " + e.getMessage());
			close();
		}
	}
	
	public void close() {
		try {
			this.session.close();
		} catch (IOException e) {
			System.out.println("Error closing session with " + getRemote() + " : " + e.getMessage());
		}
	}
	
	public String getRemote() {
		return this.session.getRemoteAddress().toString();
	}
	
	public boolean equals(WebSocketSession s) {
		return s == session;
	}
	
	public boolean getAuthed() {
		return authed;
	}
	
	public String getUsername() {
		return username;
	}
	
	public String getToken() {
		return token;
	}
	
	public void setAuth(String user, String tok) {
		username = user;
		token = tok;
		authed = true;
	}
	
	public void writeError(String msg) {
		JsonObject obj = new JsonObject();
		
		obj.addProperty("type", "error");
		obj.addProperty("message", msg);
		
		write(obj);
	}
}
