package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import com.example.appscreenlayout.R;
import com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import static com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay.getInstance;



/**
 * @Author VB_6
 * @Project Clustercore
 */
public class HubWorld extends AppCompatActivity {

    private static Activity mContext;
    private Button btn;
    private Button btn2;
    private Button btn3;
    private Button btn_send;
    private EditText txt_message;
    private ListView chat_box;
    private Button btn_Q;
    private WebsocketQueueAndUnitedPlay connection = getInstance();
    private static ArrayList<String> chatMSGs = new ArrayList<>();
    private static ArrayAdapter<String> chatADAPTER;

    private static JSONObject PlayerInfo;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_hub_world);

        connection.getPlayerInfo();

        btn_send = findViewById(R.id.but_send);
        txt_message = findViewById(R.id.txt_message);
        chat_box = findViewById(R.id.chat_box);

        chatADAPTER = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, chatMSGs);
        chat_box.setAdapter(chatADAPTER);
        
        btn = (findViewById(R.id.but_shop));
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openActivity();
            }
        });

        btn2 = (findViewById(R.id.but_friends));
        btn2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openFriends();
            }
        });

        btn3 = (findViewById(R.id.button2));
        btn3.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                openLevel();
            }
        });
        
        btn_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendMessage();
            }
        });

        btn_Q = findViewById(R.id.btn_Q);
        btn_Q.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toQueue();
            }
        });

        mContext = this;

    }


    private void toQueue(){

        //String QueueAuth = "{\"type\":\"auth\",\"token\":\""+getToken()+"\"}";
        connection.joinQueue();
    }

    private void sendMessage() {
        String token = getToken();
        String message = txt_message.getText().toString();

        connection.sendGlobalChat(message);
    }

    /**
     * Jump to shop screen
     */
    public void openActivity(){
        Intent a = new Intent(getBaseContext(), Shop.class);
        startActivity(a);
    }

    /**
     * jump to FriendsList
     */
    public void openFriends(){
        Intent a = new Intent(getBaseContext(), FriendsList.class);
        startActivity(a);
    }

    /**
     * jump to BasicLevel screen
     */
    public void openLevel(){
        Intent a = new Intent(getBaseContext(), BasicLevel.class);
        startActivity(a);
    }

    public static void QueueReadyLetsGame(boolean GamerTime){
        BasicLevel.isMultiplayer(GamerTime);
        while(getInstance().getSessionReady()){}
        Intent a = new Intent(mContext, BasicLevel.class);
        mContext.startActivity(a);
    }

    /**
     * return User information
     * @return
     */
    public String getUser(){
        return Login.getVerifiedUser();
    }

    public String getToken() { return Login.grabToken();}

    public static void addChat(final String msg, final String msg1){
        mContext.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                chatMSGs.add(msg1 + ": " + msg);
                chatADAPTER.notifyDataSetChanged();
                System.out.println("hi");
            }
        });
    }

    public static void getInfo(JSONObject info){
        PlayerInfo = info;
    }

    public static void changeCurr(int curr) {
            try{
                PlayerInfo.put("currency", curr);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }

    public static void changeEXP(int EXP) {
        try{
            PlayerInfo.put("exp", EXP);
        }
        catch(JSONException e){
            e.printStackTrace();
        }
    }

    public static void changeModel(int Model) {
        try{
            PlayerInfo.put("playerModel", Model);
        }
        catch(JSONException e){
            e.printStackTrace();
        }
    }

    public static int getModel(){
        try {
            return PlayerInfo.getInt("playerModel");
        }
        catch(JSONException e){
            e.printStackTrace();
            return 1;
        }
    }

    public static int getCurr(){
        try {
            return PlayerInfo.getInt("currency");
        }
        catch(JSONException e){
            e.printStackTrace();
            return 0;
        }
    }

    public static int getEXP(){
        try {
            return PlayerInfo.getInt("exp");
        }
        catch(JSONException e){
            e.printStackTrace();
            return 0;
        }
    }

    public static JSONObject getPlayerInfo(){
        return PlayerInfo;
    }
}
