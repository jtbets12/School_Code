package com.example.appscreenlayout.Screens;

import android.content.Intent;
import android.os.Bundle;

import com.example.appscreenlayout.R;
import com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay;

import androidx.appcompat.app.AppCompatActivity;

import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Random;


import static com.example.appscreenlayout.Screens.BasicLevel.getMP;
import static com.example.appscreenlayout.Screens.HubWorld.changeCurr;
import static com.example.appscreenlayout.Screens.HubWorld.changeEXP;
import static com.example.appscreenlayout.Screens.HubWorld.getCurr;
import static com.example.appscreenlayout.Screens.HubWorld.getEXP;
import static com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay.getInstance;


public class Debriefing extends AppCompatActivity implements debriefingView {

    private Button but_Hub;
    private TextView currency;
    private TextView experience;
    private TextView Victory;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_debriefing);

        but_Hub = findViewById(R.id.but_Hub);
        currency = findViewById(R.id.currency);
        experience = findViewById(R.id.experience);
        Victory =  findViewById(R.id.Title);
        if(getMP()){
            getInstance().leaveSession();
        }
        if(BasicLevel.getVictory()) {
            Victory.setText("Victory Royale");
        }
        else{
            Victory.setText("Defeat");
        }


        Random expMore = new Random();
        Random moneyMore = new Random();

        int addMoney;
        int addEXP;

        if(getMP()){
            addMoney = 100 + moneyMore.nextInt(100) + getCurr();

            addEXP = 100 + expMore.nextInt(100) + getEXP();
        }
        else {
            addMoney = 50 + moneyMore.nextInt(50) + getCurr();

            addEXP = 50 + expMore.nextInt(50) + getEXP();
        }

        currency.setText("Currency:"+addMoney);
        experience.setText("Experience:"+addEXP);
        JSONObject newPlayerinfo = new JSONObject();
        try {
            newPlayerinfo.put("currency", addMoney);
            changeCurr(addMoney);
        }
        catch(JSONException e){
            e.printStackTrace();
        }
        try {
            newPlayerinfo.put("exp", addEXP);
            changeEXP(addEXP);
        }
        catch(JSONException e){
            e.printStackTrace();
        }
        try {
            newPlayerinfo.put("playerModel", HubWorld.getModel());
        }
        catch(JSONException e){
            e.printStackTrace();
        }
        getInstance().setPlayerInfo(newPlayerinfo);

        but_Hub.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                backToHub();
            }
        });
    }
    private void backToHub() {
        Intent a = new Intent(getBaseContext(), HubWorld.class);
        startActivity(a);
    }
}
