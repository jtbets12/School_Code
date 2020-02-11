package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.example.appscreenlayout.R;
import com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URI;
import java.net.URISyntaxException;


import java.util.Observable;
import java.util.Observer;

import static com.example.appscreenlayout.Screens.HubWorld.getCurr;
import static com.example.appscreenlayout.Screens.HubWorld.getEXP;
import static com.example.appscreenlayout.Screens.HubWorld.getModel;
import static com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay.d;
import static com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay.getInstance;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Shop extends AppCompatActivity{

    private int balance, priceItemOne, priceItemtwo, priceItemThree, priceItemFour;
    private Button pItemone;
    private Button pItemtwo;
    private Button pItemthree;
    private Button pItemfour;
    private Button freshBalance;
    private Editable stringBalance;
    private static int initBalance = 500;
    private WebsocketQueueAndUnitedPlay connection = getInstance();

    /**
     * @EditText your EditText
     */
    private EditText yourEditText;

    /**
     *
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shop);
        balance = getCurr();     // initial balance
        priceItemOne = 0;
        priceItemtwo =  0;
        priceItemThree = 300;
        priceItemFour = 400;
       // stringBalance = Integer.toString(balance);

        pItemone= findViewById(R.id.purchaseItemOne);
        pItemone.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkOutOne();
            }
        });
        pItemtwo= findViewById(R.id.purchaseItemTwo);
        pItemtwo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkOutTwo();
            }
        });
        pItemthree= findViewById(R.id.purchaseItemThree);
        pItemthree.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkOutThree();
            }
        });
        pItemfour= findViewById(R.id.purchaseItemFour);
        pItemfour.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkOutFour();
            }
        });
        freshBalance= findViewById(R.id.refresh);
        freshBalance.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                afterTextChanged(stringBalance);
            }
        });


        yourEditText = (EditText) findViewById(R.id.currencyBalance);
        yourEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void afterTextChanged(Editable s) {
                yourEditText.setText("$" + balance+  yourEditText.getText().toString());
            }
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {}
        });


    }

    /**
     * afterTextChanged
     * @param s
     */
    public void afterTextChanged(Editable s) {
        yourEditText.setText("$" + balance+  yourEditText.getText().toString());
    }

    /**
     * return balance
     * @return
     */
    public int getBalance(){
        return balance;
    }

    /**
     *
     * @return
     */
    public static int getinitBalance(){
        return initBalance;
    }


    private void checkOutOne() {
        if (balance < priceItemOne){
            dialogFailed();
            Toast.makeText(this, "You do not have enough balance", Toast.LENGTH_SHORT).show();
        }
        else if (balance >= priceItemOne){
            balance =- priceItemOne;
            JSONObject shopChange = new JSONObject();
            try {
                shopChange.put("currency", balance);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("exp", getEXP());
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("playerModel", 2);
                HubWorld.changeModel(2);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            connection.setPlayerInfo(shopChange);
            dialogCompleted();
            
            Toast.makeText(this, "Purchase success", Toast.LENGTH_SHORT).show();
        }

    }

    private void checkOutTwo() {
        if (balance < priceItemtwo){
            dialogFailed();
            Toast.makeText(this, "You do not have enough balance", Toast.LENGTH_SHORT).show();
        }
        else if (balance >= priceItemtwo){
            balance =- priceItemtwo;
            JSONObject shopChange = new JSONObject();
            try {
                shopChange.put("currency", balance);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("exp", getEXP());
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("playerModel", 3);
                HubWorld.changeModel(3);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            connection.setPlayerInfo(shopChange);
            dialogCompleted();
            Toast.makeText(this, "Purchase success", Toast.LENGTH_SHORT).show();
        }
    }

    private void checkOutThree() {
        if (balance < priceItemThree){
            dialogFailed();
            Toast.makeText(this, "You do not have enough balance", Toast.LENGTH_SHORT).show();
        }
        else if (balance >= priceItemThree){
            balance =- priceItemThree;
            JSONObject shopChange = new JSONObject();
            try {
                shopChange.put("currency", balance);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("exp", getEXP());
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("playerModel", getModel());
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            connection.setPlayerInfo(shopChange);
            dialogCompleted();
            Toast.makeText(this, "Purchase success", Toast.LENGTH_SHORT).show();
        }
    }

    private void checkOutFour() {
        if (balance < priceItemFour){
            dialogFailed();
            Toast.makeText(this, "You do not have enough balance", Toast.LENGTH_SHORT).show();
        }
        else if (balance >= priceItemFour){
            balance =- priceItemThree;
            JSONObject shopChange = new JSONObject();
            try {
                shopChange.put("currency", balance);
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("exp", getEXP());
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            try {
                shopChange.put("playerModel", getModel());
            }
            catch(JSONException e){
                e.printStackTrace();
            }
            connection.setPlayerInfo(shopChange);
            dialogCompleted();
            Toast.makeText(this, "Purchase success", Toast.LENGTH_SHORT).show();
        }
    }

    private void dialogCompleted() {
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setIcon(R.mipmap.ic_launcher_round);
        dialog.setTitle("Your purchase is completed");
        dialog.setMessage("Click Yes or No to get back ");
        dialog.setCancelable(false);    //setting to jump to certain screen
        dialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                Toast.makeText(Shop.this, "Yes", Toast.LENGTH_SHORT).show();
            }
        });
        dialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                Toast.makeText(Shop.this, "No", Toast.LENGTH_SHORT).show();
            }
        });

    }

    private void dialogFailed(){

        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setIcon(R.mipmap.ic_launcher_round);
        dialog.setTitle("Your purchase is not completed due to following reason");
        dialog.setMessage("You don't have enough balance to purchase new item. Click Yes or No to get back ");
        dialog.setCancelable(false);    //setting to jump to certain screen
        dialog.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                Toast.makeText(Shop.this, "Yes", Toast.LENGTH_SHORT).show();
            }
        });
        dialog.setNegativeButton("No", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                Toast.makeText(Shop.this, "No", Toast.LENGTH_SHORT).show();
            }
        });


    }


}
