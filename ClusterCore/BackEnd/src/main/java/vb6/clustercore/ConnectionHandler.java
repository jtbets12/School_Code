package vb6.clustercore;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;

@Component
public class ConnectionHandler implements WebSocketHandler {
	
	/*@Autowired
	AuthService auth_control;*/
	
	GameController game_controller;
	List<ClientConnection> connections = new ArrayList<>();
	
	public ConnectionHandler() {
		game_controller = new GameController();
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("Accepted connection from " + session.getRemoteAddress());
		connections.add(new ClientConnection(session));
	}

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {		
		ClientConnection conn = getConnection(session);
		
		if (conn == null) return;
		
		JsonObject msg = null;
		String msg_type = null;
		
		/* Parse message contents */
		//System.out.println("Received from " + conn.getUsername() + ": " + message.getPayload().toString());
		
		try {
			msg = new JsonParser().parse(message.getPayload().toString()).getAsJsonObject();
		} catch (Exception e) {
			System.out.println("Malformed JSON in client message: " + e.getMessage());
			conn.writeError("Invalid message format.");
			return;
		}
		
		/* Grab message type */
		try {
			msg_type = msg.get("type").getAsString();
		} catch (Exception e) {
			conn.writeError("Message missing type!");
			return;
		}
		
		/* If the connection is authed, pass it to the GameController */
		if (conn.getAuthed()) {
			game_controller.handleMessage(conn, msg_type, msg);
			return;
		}
		
		/* Check if the msg is an auth */
		if (msg_type.equals("auth")) {
			/* Check there is a token */
			try {
				System.out.println("Checking message contains token.");
				String tok = msg.get("token").getAsString();
				
				System.out.println("Testing token: " + tok);
				
				/* HACK DON'T LOOK */
				AuthService auth_control = ApplicationContextHolder.getContext().getBean(AuthService.class);
				
				Optional<User> auth_result = auth_control.verifySession(tok);
				
				System.out.println("Tested token: present = " + auth_result.isPresent());
				/* Check that auth went well, or kill the connection */
				if (!auth_result.isPresent()) {
					conn.writeError("Authentication failed.");
					return;
				}
				
				System.out.println("Auth OK. Sending back message");
				
				/* Auth succeeded! Let the client know and set the token */
				JsonObject auth_response = new JsonObject();
				
				auth_response.addProperty("type", "authok");
				auth_response.addProperty("username", auth_result.get().getUsername());
				
				System.out.println("Writing OK response.");
				conn.write(auth_response);
				
				System.out.println("Authenticated user " + auth_result.get().getUsername());
				
				/* Set connection flags */
				conn.setAuth(auth_result.get().getUsername(), tok);
				
				/* Add connection to the game controller */
				game_controller.addClient(conn);
				return;
			} catch (Exception e) {
				conn.writeError("Invalid authentication request: " + e.getMessage());
				e.printStackTrace();
				return;
			}
		} else {
			conn.writeError("You must authenticate to send messages.");
		}
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		System.out.println("Transport error: " + exception.getMessage());
		
		ClientConnection conn = getConnection(session);
		if (conn == null) return;
		
		dropConnection(conn);	
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		System.out.println("Connection closed: " + session.getRemoteAddress().toString());

		ClientConnection conn = getConnection(session);
		if (conn == null) return;
		
		dropConnection(conn);
	}

	@Override
	public boolean supportsPartialMessages() {
		return false;
	}
	
	public ClientConnection getConnection(WebSocketSession s) {
		for (ClientConnection i : connections) {
			if (i.equals(s)) {
				return i;
			}
		}
		
		return null;
	}
	
	public void dropConnection(ClientConnection conn) {
		game_controller.dropClient(conn);
		connections.remove(conn);
	}
}
