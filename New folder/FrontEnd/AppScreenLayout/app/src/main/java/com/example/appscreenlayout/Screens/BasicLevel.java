package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.WindowManager;

import com.example.appscreenlayout.GameLoop.Game;
import com.example.appscreenlayout.app.Boss;
import com.example.appscreenlayout.app.Player;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class BasicLevel extends AppCompatActivity implements basiclevelView {


    private static Activity mContext;
    private static boolean Multiplayer;
    private static boolean GamersRise;
    private static boolean Victory = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(getWindow().FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(new Game(this));
        /*if(Multiplayer) {
            if (Boss.bossDead()) {
                Victory = true;
                toHub();
            }
            else(Player.getHealth() <= 0){

            }
        }
         else{
                if(Boss.bossDead()){
                    Victory = true;
                    toHub();
                }
        }*/
         mContext = this;
    }

    public static void isMultiplayer(boolean MPTrue){
        Multiplayer = MPTrue;
    }

    public static boolean getMP(){return Multiplayer;}

    public static void toHub(){
        Intent a = new Intent(mContext, HubWorld.class);
        mContext.startActivity(a);
    }

    public static void toDebriefing(){
        Intent a = new Intent(mContext, Debriefing.class);
        mContext.startActivity(a);
    }

    public static boolean getVictory(){ return Victory; }

    public static void setVictory() {Victory = true;
    if(Multiplayer){
        toDebriefing();
    }
    toHub();
    }

    public static void setDefeat()  {
        Victory = false;
        if(Multiplayer){
            toDebriefing();
        }
        toHub();}
}
