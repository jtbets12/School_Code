package vb6.clustercore;

import java.util.ArrayList;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/* GameController handles all requests relating to game code */
public class GameController {
	private ArrayList<GameSession> sessions;
	private ArrayList<ClientConnection> connections;
	
	@Autowired
	private UserRepository user_repo;
	
	private final int QUEUE_SIZE = 2;
	
	private ArrayList<String> current_queue;
	private int next_session_id = 1;
	
	public GameController() {
		sessions = new ArrayList<>();
		connections = new ArrayList<>();
		
		sessions.add(new GameSession(0, -1));
		current_queue = new ArrayList<>();
	}
	
	/**
	 * Adds a client to the game controller connection list.
	 * 
	 * @param conn Connection to add.
	 */
	public void addClient(ClientConnection conn) {
		if (findByUsername(conn.getUsername()) != null) {
			conn.writeError("Another login is already active!");
			conn.close();
			return;
		}
		
		connections.add(conn);
		System.out.println("GameController: accepted client " + conn.getUsername());
	}
	
	/**
	 * Message handler function for all JSON messages sent over websocket.
	 * 
	 * @param conn Sender connection handle
	 * @param msg_type Message type string
	 * @param msg Full message body
	 */
	public void handleMessage(ClientConnection conn, String msg_type, JsonObject msg) {
		if (!hasConnection(conn)) {
			conn.writeError("Session has been closed.");
			conn.close();
			return;
		}
		
		if (msg_type.equals("joinsession")) {
			/* Join a player to a session */
			if (!msg.has("sessionid")) {
				conn.writeError("Missing session id!");
				return;
			}
			
			GameSession target = getSession(msg.get("sessionid").getAsInt());
			
			if (target == null) {
				conn.writeError("Invalid session.");
				return;
			}
			
			target.add(conn);
		} else if (msg_type.equals("leavesession")) {
			/* Join a player to a session */
			if (!msg.has("sessionid")) {
				conn.writeError("Missing session id!");
				return;
			}
			
			GameSession target = getSession(msg.get("sessionid").getAsInt());
			
			if (target == null) {
				conn.writeError("Invalid session.");
				return;
			}
			
			target.drop(conn);
		} else if (msg_type.equals("session")) {
			/* Dispatch session message to the correct session */
			
			if (msg.has("sessionid")) {
				int id = msg.get("sessionid").getAsInt();
				
				GameSession s = getSession(id);
				
				if (s == null) {
					conn.writeError("Invalid session ID.");
					conn.close();
					return;
				}
				
				s.handleSessionMessage(conn, msg);
			}
		} else if (msg_type.equals("joinqueue")) {
			/* Add player to the queue if not already in the queue. */
			for (String name : current_queue) {
				if (conn.getUsername().equals(name)) {
					/* Username already in queue, ignore */
					conn.writeError("Already in queue!");
					return;
				}
			}
			
			/* Add player to queue. */
			current_queue.add(conn.getUsername());
			
			writeQueueState();
			
			/* If the queue is ready, send a queue ready message */
			if (current_queue.size() >= QUEUE_SIZE) {
				JsonObject queue_ready = new JsonObject();
				
				queue_ready.addProperty("type", "queueready");
				queue_ready.addProperty("sessionid",  next_session_id);
				
				/* Create the session for the players to join */
				sessions.add(new GameSession(next_session_id, QUEUE_SIZE));
				
				System.out.println("Queue ready! Sending clients to session " + next_session_id);
				
				for (String name : current_queue) {
					ClientConnection u = findByUsername(name);
					u.write(queue_ready);
					
					System.out.println("Sending queue ready message to " + name);
				}
				
				/* Increment the next session id and wipe the queue. */
				next_session_id++;
				current_queue.clear();
			}
		} else if (msg_type.equals("leavequeue")) {
			/* Drop a player from the queue */
			String target_name = null;
			
			for (String name : current_queue) {
				if (conn.getUsername().equals(name)) {
					target_name = name;
				}
			}
			
			if (target_name == null) {
				conn.writeError("Not in queue!");
				return;
			}
			
			current_queue.remove(target_name);
		} else if (msg_type.equals("globalchat")) {
			System.out.println("chat: " + conn.getUsername() + " : " + msg.toString());
			
			msg.addProperty("Username",  conn.getUsername());
			
			/* Allchat message, relay to all other clients */
			for (ClientConnection cur : connections) {
				cur.write(msg);
			}
		} else if (msg_type.equals("getinfo")) {
			/* Grab the player information and send it back. */
			for (User i : user_repo.findAll()) {
				if (i.getUsername().equals(conn.getUsername())) {
					/* Found! */
					JsonObject resp = new JsonObject();
					
					try {
						resp.add("info", new JsonParser().parse(i.getInfo()).getAsJsonObject());
					} catch (Exception e) {
						System.out.println("Unexpected JSON read error getting player info: " + e.getMessage());
						conn.writeError("Unexpected JSON error");
						return;
					}
					
					resp.addProperty("type", "getinfo");
					conn.write(resp);
					
					return;
				}
			}
		} else if (msg_type.equals("setinfo")) {
			if (!msg.has("info") ) {
				conn.writeError("Missing info field, cannot set player info");
				return;
			}
			
			for (User i : user_repo.findAll()) {
				if (i.getUsername().equals(conn.getUsername())) {
					i.setInfo(msg.get("info").toString());
					System.out.println("Updated player info for " + conn.getUsername());
				}
			}
		}
	}
	
	/**
	 * Drops a client from the game controller.
	 * 
	 * @param conn Connection to drop.
	 */
	public void dropClient(ClientConnection conn) {
		connections.remove(conn);
		System.out.println("GameController: dropped client " + conn.getUsername());
	}
	
	/**
	 * Locates a client connection by username.
	 * 
	 * @param uname Username to search for.
	 * @return ClientConnection with matching username, or null if not found.
	 */
	public ClientConnection findByUsername(String uname) {
		for (ClientConnection i : connections) {
			if (i.getUsername().equals(uname)) {
				return i;
			}
		}
		
		return null;
	}
	
	/**
	 * Checks if a specific connection is connected to the controller.
	 * 
	 * @param conn Connection to check.
	 * @return true iff <conn> is in the session.
	 */
	public boolean hasConnection(ClientConnection conn) {
		return connections.contains(conn);
	}
	
	/**
	 * Gets a session by ID. Returns null if not found.
	 * 
	 * @param id Session id
	 * @return GameSession with matching id, or null if not found.
	 */
	public GameSession getSession(int id) {
		for (GameSession i : sessions) {
			if (i.getId() == id) {
				return i;
			}
		}
		
		return null;
	}
	
	/**
	 * Sends the state of the queue to all players within it.
	 * The state of the queue only contains the names of all the players in the queue.
	 */
	private void writeQueueState() {
		/* Generate queue state message */
		JsonArray userlist = new JsonArray();
		
		for (String name : current_queue) {
			userlist.add(name);
		}
		
		JsonObject queue_state = new JsonObject();
		queue_state.addProperty("type", "queuestate");
		queue_state.add("users",  userlist);
		
		/* Write queue state to all queue usernames */
		for (String name : current_queue) {
			ClientConnection u = findByUsername(name);
			u.write(queue_state);
		}
	}
 }