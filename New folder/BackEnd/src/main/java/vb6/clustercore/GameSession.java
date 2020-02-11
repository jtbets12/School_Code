package vb6.clustercore;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.web.socket.WebSocketSession;

import com.google.gson.JsonObject;

public class GameSession {
	private ArrayList<ClientConnection> sessions;
	private int id;
	private int full;
	
	public GameSession(int id, int full) {
		sessions = new ArrayList<>();
		this.id = id;
		this.full = full;
	}
	
	/**
	 * Adds a connection to the session. If there is a conflicting username,
	 * the conneciton is ignored and an error is sent to the client.
	 * 
	 * @param s Connection to add.
	 */
	public void add(ClientConnection s) {
		/* Check there are no conflicting players */
		if (getByUsername(s.getUsername()) != null) {
			s.writeError("Already joined to session!");
			return;
		}
		
		sessions.add(s);
		s.write(makeStateMessage("joined"));
		
		if (sessions.size() == full) {
			JsonObject ready_message = new JsonObject();
			
			ready_message.addProperty("type", "sessionready");
			ready_message.addProperty("sessionid", id);
			
			System.out.println("Session is ready! Notifying " + full + " clients.");
			
			/* Send a ready message to all of the clients */
			for (ClientConnection conn : sessions) {
				conn.write(ready_message);
			}
		}
	}
	
	/**
	 * Drops a client from the session. If no connection with a matching username can be found,
	 * the request is ignored and an error is sent to the client.
	 * 
	 * @param s Connection requesting the drop.
	 */
	public void drop(ClientConnection s) {
		/* Check the player is in the session */
		ClientConnection target_conn = getByUsername(s.getUsername());
		
		if (target_conn == null) {
			s.writeError("Not currently in session!");
			return;
		}
		
		sessions.remove(target_conn);
		s.write(makeStateMessage("left"));
	}
	
	/**
	 * Handles messages sent to a particular session. Relays the message to all clients within the session.
	 * 
	 * @param s Sender connection.
	 * @param msg Session message.
	 */
	public void handleSessionMessage(ClientConnection s, JsonObject msg) {
		/* Session messages just get relayed to other clients within the session */
		for (ClientConnection i : sessions) {
			if (i == s) continue;
			
			i.write(msg);
		}
	}
	
	/**
	 * Gets the ID for this session.
	 * 
	 * @return session id
	 */
	public int getId() {
		return id;
	}
	
	/**
	 * Gets a client connection from this session by username.
	 * If not found, returns null.
	 * 
	 * @param username Username to search for.
	 * @return matching ClientConnection, or null if not found.
	 */
	public ClientConnection getByUsername(String username) {
		for (ClientConnection conn : sessions) {
			if (conn.getUsername().equals(username)) {
				return conn;
			}
		}
		
		return null;
	}
	
	/**
	 * Generates a JSON session state change message to send to clients
	 * when they join or leave the session.
	 * 
	 * @param state
	 * @return
	 */
	private JsonObject makeStateMessage(String state) {
		JsonObject out = new JsonObject();
		
		out.addProperty("type", "sessionstate");
		out.addProperty("sessionid", getId());
		out.addProperty("state",  state);
		
		return out;
	}
}
