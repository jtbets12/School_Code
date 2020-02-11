package com.example.appscreenlayout.app;

import android.util.Log;
import android.widget.Toast;

import com.example.appscreenlayout.Screens.HubWorld;

import androidx.appcompat.app.AppCompatActivity;
import com.example.appscreenlayout.Screens.Login;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_6455;
import org.java_websocket.handshake.ServerHandshake;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;


import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.UUID;


/**
 * @Author VB_6
 * @Project Clustercore
 */
public class WebsocketQueueAndUnitedPlay extends AppCompatActivity {
    public static Draft[] d = {new Draft_6455()};


    /* Current session ID. Is non-negative when the player is in a session. */
    private int current_session_id = -1;

    /* Current queue state */
    private boolean player_in_queue;
    private ArrayList<String> current_queue;
    private String username;
    private boolean session_is_ready;

    /* Singleton instance field */
    private static WebsocketQueueAndUnitedPlay instance;

    private WebSocketClient CCSocket;

    /**
     * Singleton instance getter. Initializes the connection if it is not already.
     * @return Singleton instance.
     */
    public static WebsocketQueueAndUnitedPlay getInstance() {
        if (instance == null) {
            instance = new WebsocketQueueAndUnitedPlay();
        }

        return instance;
    }

    /**
     * Connecting to WebSocketClient
     */
    private WebsocketQueueAndUnitedPlay()
    {
        URI GameConnection = null;
        String obj_js = "wb_cnct";
        JSONObject connect = null;

        current_queue = new ArrayList<>();
        player_in_queue = false;
        session_is_ready = false;

        try {
            GameConnection = new URI("http://coms-309-vb-6.misc.iastate.edu:8080/game");
        }
        catch(URISyntaxException e){
                Log.d("URI:","Unexpected URL error");
        }

        Log.d("Websocket", "Creating WebSccketClient : " + GameConnection.toString());

            CCSocket = new WebSocketClient(GameConnection) {

                @Override
                public void onOpen(ServerHandshake serverHandshake) {
                    Log.d("Websocket", "Connection completed");
                    JSONObject sendData = new JSONObject();

                    try{
                        sendData.put("type", "auth");
                    }
                    catch(JSONException e){
                        Log.e("QueueJoin:", "Unexpected JSON exception: " + e.getMessage());
                    }
                    try{
                        sendData.put("token", Login.grabToken());
                    }
                    catch(JSONException e){
                        Log.e("QueueJoin:", "Unexpected JSON exception: " + e.getMessage());
                    }

                    writeObject(sendData);
                }

                @Override
                public void onMessage(String s) {
                    Log.d("Websocket", "Received from server: " + s);
                    /* Make sure that the message is valid JSON and has a type. */
                    try {
                        JSONObject message_json = new JSONObject(s);
                        String message_type = message_json.getString("type");

                        /* OK! pass the message to the top-level handler */
                        handleMessage(message_type, message_json);
                    } catch (JSONException e) {
                        Log.e("Websocket", "Invalid message from server: " + e.getMessage());
                        return;
                    }
                }


                @Override
                public void onClose(int i, String s, boolean b) {
                    Log.d("WebSocket", "Connection closed: " + s);
                }

                @Override
                public void onError(Exception e) {
                    System.out.print("WebSocket Error>>>>>");
                    e.printStackTrace(System.out);
                }
            };

        int attempt = 0;

        connectToWebsocket();
        if(CCSocket.isOpen()){
            //CCSocket.send(Login.grabToken());
        }
        else if(attempt < 5)
        {
            connectToWebsocket();
            attempt++;
        }


        /*try {
            connect = new JSONObject(obj_js);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        verifiedToken = getToken(connect);

        if (verifyStatus(connect)) {
            Intent a = new Intent(getBaseContext(), BasicLevel.class);
            startActivity(a);
        }*/
    }

    /**
     * Top-level message handler. All valid messages received from the server containing a type are
     * passed here.
     *
     * @param type Message type string.
     * @param body Complete message body.
     */
    public void handleMessage(String type, JSONObject body) throws JSONException {
        /* Authorization OK */
        if (type.equals("authok")) {
            Log.d("Websocket", "Client authorized! Username: " + body.getString("username"));
            username = body.getString("username");
        }

        if (type.equals("error")) {
            Toast.makeText(getApplicationContext(), "body", Toast.LENGTH_SHORT).show();
        }

        /* Handle session state changes */
        if (type.equals("sessionstate")) {
            int session_id = body.getInt("sessionid");
            String state = body.getString("state");

            if (state.equals("joined")) {
                Log.d("Websocket", "Server confirmed session " + session_id + " joined");
                current_session_id = session_id;
            } else if (state.equals("left")) {
                Log.d("Websocket", "Server confirmed session " + session_id + " left");
            }
        }

        /* Handle session ready message */
        if (type.equals("sessionready")) {
            /* Send the ready message! */
            //ObjectContainer.getInstance().sendSessionReady();
            session_is_ready = true;
        }

        /* Dispatch session messages if we are in the session */
        if (type.equals("session")) {
            int session_id = body.getInt("sessionid");

            if (session_id == current_session_id) {
                JSONObject payload = body.getJSONObject("payload");
                String payload_type = payload.getString("type");

                handleSessionMessage(payload_type, payload);
            }
        }

        /* Check queue state */
        if (type.equals("queuestate")) {
            /* Parse users */

            JSONArray users = body.getJSONArray("users");

            current_queue = new ArrayList<>();
            player_in_queue = false;

            for (int i = 0; i < users.length(); ++i) {
                if (users.getString(i).equals(username)) {
                    player_in_queue = true;
                }

                current_queue.add(users.getString(i));
            }

            Log.d("Websocket", "Recevied queue state with " + users.length() + " users");
        }

        /* Check queue ready */
        if (type.equals("queueready")) {
            HubWorld.QueueReadyLetsGame(true);

            int sid = body.getInt("sessionid");

            Log.d("Websocket", "Received queue ready to join session " + sid);

            joinSession(sid);
            session_is_ready = false;
        }

        if(type.equals("globalchat")){
            HubWorld.addChat(body.getString("Message"), body.getString("Username"));
        }

        if(type.equals("getinfo")){
            JSONObject info = body.getJSONObject("info");
            HubWorld.getInfo(info);
        }
    }

    /**
     * Handles a message sent from other clients in the same session.
     *
     * @param payload_type Payload type field.
     * @param payload Complete payload object.
     */
    public void handleSessionMessage(String payload_type, JSONObject payload) throws JSONException {
        Log.d("Websocket", "Received session message: " + payload.toString());

        /* Handle messages sent to objects */
        if (payload_type.equals("msgobject")) {
            ObjectContainer.getInstance().msgObject(payload.getString("uuid"), payload.getJSONObject("body"));
        } else if (payload_type.equals("createobject")) {
            String object_type = payload.getString("object_type");
            String uuid = payload.getString("uuid");
            JSONObject params = payload.getJSONObject("params");
            int x = payload.getInt("x");
            int y = payload.getInt("y");

            ObjectContainer.getInstance().createObjectWithID(object_type, x, y, params, uuid);
        }
    }

    /**
     * Sends a JSON object to a particular object.
     * The object is passed as a parmater to the msg() virtual method.
     * @param object_id UUID to send to.
     * @param body Object to write.
     */
    public void sendToObject(String object_id, JSONObject body) {
        JSONObject message = new JSONObject();
        try {
            message.put("type", "msgobject");
            message.put("body", body);
            message.put("uuid", object_id);

            writeToSession(message);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }
    }

    /**
     * Tries to join the client to a game session.
     * The current session is not set until the join is confirmed.
     * If the client is already in a session then the current session is left.
     *
     * @param session_id Session ID to join.
     */
    public void joinSession(int session_id) {
        if (getInSession()) {
            leaveSession();
        }

        JSONObject join_request = new JSONObject();

        try {
            join_request.put("type", "joinsession");
            join_request.put("sessionid", session_id);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }

        writeObject(join_request);
    }

    /**
     * Leaves the current session. Immediately unsets the current session id,
     * without waiting for confirmation from the server.
     */
    public void leaveSession() {
        if (!getInSession()) {
            Log.e("Websocket", "Cannot leave session: not in a session!");
            return;
        }

        JSONObject leave_request = new JSONObject();

        try {
            leave_request.put("type", "leavesession");
            leave_request.put("sessionid", current_session_id);

            writeObject(leave_request);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
        }

        current_session_id = -1;
        session_is_ready = false;
    }

    /**
     * Writes a message to the current session.
     * @param payload Message to send.
     */
    public void writeToSession(JSONObject payload) {
        if (!getInSession()) {
            Log.e("Websocket", "Cannot write to session: not in a session!");
            return;
        }

        JSONObject message = new JSONObject();

        try {
            message.put("type", "session");
            message.put("sessionid", current_session_id);
            message.put("payload", payload);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
        }

        writeObject(message);
    }

    /**
     * Creates a remote object and generates a unique ID to control it.
     * @param object_type Object type to create.
     * @param params JSON to pass to the init() function.
     * @return The generated ID which can be used to control the new object.
     */
    public String createRemoteObject(String object_type, int x, int y, JSONObject params) {
        JSONObject create_request = new JSONObject();

        if (params == null) {
            params = new JSONObject();
        }

        String uuid = UUID.randomUUID().toString();

        try {
            create_request.put("type", "createobject");
            create_request.put("object_type", object_type);
            create_request.put("params", params);
            create_request.put("uuid", uuid);
            create_request.put("x", x);
            create_request.put("y", y);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return null;
        }

        writeToSession(create_request);
        return uuid;
    }

    /**
     * Joins the client to the queue. Ignores request if client already in the queue.
     */
    public void joinQueue() {
        JSONObject queue_request = new JSONObject();

        try {
            queue_request.put("type", "joinqueue");
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }

        writeObject(queue_request);
    }

    /**
     * Drops the client from the queue.
     */
    public void leaveQueue() {
        JSONObject queue_request = new JSONObject();

        try {
            queue_request.put("type", "leavequeue");
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }

        writeObject(queue_request);
        player_in_queue = false;
    }

    /**
     * Checks if the player is currently in the queue.
     */
    public boolean getInQueue() {
        return player_in_queue;
    }

    /**
     * Gets a list of players currently waiting in the queue.
     */
    public ArrayList<String> getQueue() {
        return current_queue;
    }

    /**
     * Gets whether all the players in the current session are ready.
     */
    public boolean getSessionReady() {
        return session_is_ready;
    }

    /**
     * Gets whether the client is currently in a game session.
     * @return true if the client is in a session.
     */
    public boolean getInSession() {
        return current_session_id >= 0;
    }

    /**
     * Writes a JSON object to the server.
     *
     * @param obj object to send.
     */
    public void writeObject(JSONObject obj) {
        CCSocket.send(obj.toString());
    }

    /*public boolean verifyStatus(JSONObject response)
    {
        return response.optBoolean("get Status");
    }
    public String getToken(JSONObject response) {
        return response.optString("message");
    }*/

    /*public static String grabToken(){
        return verifiedToken;
    }*/

    public void connectToWebsocket(){
        Log.d("Connection", "Attempting connection..");

        try{
            if(CCSocket.connectBlocking())
            {
                Log.d("Connection", "Connection successful!");
            }
            else{
                Log.e("Connection", "Connection is failing");
            }
        }
        catch(InterruptedException e){
            Log.d("Connection","InterruptedException");
        }
    }

    public void setPlayerInfo(JSONObject Info) {
        JSONObject set_request = new JSONObject();

        try {
            set_request.put("type", "setinfo");
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }

        try {
            set_request.put("info", Info);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }

        writeObject(set_request);
    }

    public void getPlayerInfo() {
        JSONObject Player_request = new JSONObject();

        try {
            Player_request.put("type", "getinfo");
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
        }

        writeObject(Player_request);
    }

    public void sendGlobalChat(String chat) {
        JSONObject chat_message = new JSONObject();

        System.out.println("type");

        try {
            chat_message.put("type", "globalchat");
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }

        try {
            chat_message.put("Message", chat);
        } catch (JSONException e) {
            Log.e("Websocket", "Unexpected JSON exception: " + e.getMessage());
            return;
        }
        writeObject(chat_message);
    }
}
