package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.example.appscreenlayout.R;
import com.example.appscreenlayout.app.AppController;


import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class ResetPassword extends AppCompatActivity implements resetpasswordsView {

    private Button but_back;
    private Button but_send;
    private EditText txt_email;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_reset_password);
        but_back = findViewById(R.id.but_back);
        but_send = findViewById(R.id.but_send);
        txt_email = findViewById(R.id.txt_email);
        but_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                back_Login();
            }
        });
        but_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PasswordChangeRequest();
            }
        });
    }

    /**
     * jump to login screen
     */
    public void back_Login(){
        Intent a = new Intent(this, Login.class);
        startActivity(a);
    }

    private void PasswordChangeRequest() {
        String email = txt_email.toString();

        String url = "http://coms-309-vb-6.misc.iastate.edu/login";
        String tag_json_obj = "json_obj_req";

        Map<String, String> params = new HashMap<>();
        params.put("email", email);
        JSONObject jsonObject = new JSONObject(params);
        JsonObjectRequest Send =  new JsonObjectRequest(Request.Method.POST, url, jsonObject, new Response.Listener<JSONObject>(){
            @Override
            public void onResponse(JSONObject response)
            {
                //Toast.makeText(getApplicationContext(), "Connected", Toast.LENGTH_SHORT).show();
                Toast.makeText(getApplicationContext(), response.toString(), Toast.LENGTH_SHORT).show();
                //Intent a = new Intent(getBaseContext(), Login.class);
                //startActivity(a);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(getApplicationContext(), error.toString(), Toast.LENGTH_SHORT).show();
            }
        });
        AppController.getInstance().addToRequestQueue(Send, tag_json_obj);
    }
}
