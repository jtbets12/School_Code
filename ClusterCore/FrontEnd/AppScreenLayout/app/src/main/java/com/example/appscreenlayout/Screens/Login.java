package com.example.appscreenlayout.Screens;

import android.content.Intent;
import android.os.Bundle;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.example.appscreenlayout.R;
import com.example.appscreenlayout.app.AppController;

import androidx.appcompat.app.AppCompatActivity;

import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Login extends AppCompatActivity implements loginView {


    private Button but_back;
    private Button but_reset;
    private Button but_login;
    private EditText txt_pass;
    private EditText txt_user;
    private static String VerifiedUser;
    private String thisString;
    private static String verifiedToken;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        but_back = findViewById(R.id.but_back);
        but_login = findViewById(R.id.but_login);
        but_reset = findViewById(R.id.but_reset);
        txt_pass = findViewById(R.id.txt_pass);
        txt_user = findViewById(R.id.txt_user);

        but_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                back_Main();
            }
        });
        but_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LoginRequest();
            }
        });
        but_reset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openReset();
            }
        });
        //super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_main);

      /*  ConstraintLayout constraintLayout = findViewById(R.id.layout);
        AnimationDrawable animationDrawable = (AnimationDrawable) constraintLayout.getBackground();
        animationDrawable.setEnterFadeDuration(2000);
        animationDrawable.setExitFadeDuration(4000);
        animationDrawable.start();*/
    }

    private void LoginRequest() {

        String password = txt_pass.getText().toString();
        final String username = txt_user.getText().toString();

        String url = String.format("http://coms-309-vb-6.misc.iastate.edu:8080/login?username=%1$s&password=%2$s", username, password);

        String tag_json_obj = "json_obj_req";

        StringRequest Send =  new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                //Toast.makeText(getApplicationContext(), response, Toast.LENGTH_SHORT).show();
                JSONObject resp = null;
                try {
                    resp = new JSONObject(response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                verifiedToken = getToken(resp);
                if(getStatus(resp))
                {
                    VerifiedUser = username;
                    Intent a = new Intent(getBaseContext(), HubWorld.class);
                    startActivity(a);
                }
                else{
                    Toast.makeText(getApplicationContext(), getToken(resp), Toast.LENGTH_SHORT).show();
                }
            }
        },  new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(getApplicationContext(), error.toString(), Toast.LENGTH_SHORT).show();
            }});




        AppController.getInstance().addToRequestQueue(Send, tag_json_obj);
    }

    /**
     * JUMP TO MAIN SCREEN
     */
    public void back_Main(){
        Intent a = new Intent(this, MainActivity.class);
        startActivity(a);
    }


    public void openReset(){
        Intent a = new Intent(this, ResetPassword.class);
        startActivity(a);
    }

    public boolean getStatus(JSONObject response)
    {
        return response.optBoolean("status");
    }

    public String getToken(JSONObject response) {
        return response.optString("message");
    }


    public static String getVerifiedUser(){
        return VerifiedUser;
    }

    public static String grabToken(){
        return verifiedToken;
    }

}
