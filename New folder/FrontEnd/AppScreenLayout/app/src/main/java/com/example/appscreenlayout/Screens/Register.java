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

import java.util.HashMap;
import java.util.Map;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Register extends AppCompatActivity implements registerView {

    private Button but_create;
    private Button but_back;
    private EditText txt_conPass;
    private EditText txt_email;
    private EditText txt_pass;
    private EditText txt_user;
    private boolean capital = false;
    private boolean lowercase = false;
    private boolean emailG = false;
    private boolean userG = false;
    private boolean passL = false;
    private boolean passCon = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        txt_email = findViewById(R.id.txt_email);
        but_create = findViewById(R.id.but_create);
        txt_conPass = findViewById(R.id.txt_conPass);
        txt_pass = findViewById(R.id.txt_pass);
        txt_user = findViewById(R.id.txt_user);
        but_back = findViewById(R.id.but_back);
        but_back.setOnClickListener(new View.OnClickListener()  {
            @Override
            public void onClick(View view) {
                back_Main();
            }
        });
        but_create.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String user = txt_user.getText().toString().trim();
                String password = txt_pass.getText().toString().trim();
                String conPass = txt_conPass.getText().toString().trim();
                String email = txt_email.getText().toString().trim();
                pass_Confirm(user, password, conPass, email);
            }
        });

    }

    /**
     * confirming if username and passwords are true,
     * @param user
     * @param password
     * @param conPass
     * @param email
     */
    public void pass_Confirm(String user, String password, String conPass, String email) {

        if(user.isEmpty()) {
            Toast.makeText(this, "Username field is empty", Toast.LENGTH_SHORT).show();
            userG = false;
        }
        else{
            userG = true;
        }
        if(email.isEmpty()){
            Toast.makeText(this, "email field is empty", Toast.LENGTH_SHORT).show();
            emailG = false;
        }
        else{
            emailG = true;
        }
        if (!password.equals(conPass)) {
            Toast.makeText(this, "Passwords do not match", Toast.LENGTH_SHORT).show();
            passCon = false;
        }
        else{
            passCon = true;
        }
        if(password.length() < 10)
        {
            Toast.makeText(this, "Password is less than 10 characters", Toast.LENGTH_SHORT).show();
            passL = false;
        }
        else{
            passL = true;
        }
        for(int i = 0; i <= password.length()-1; i++){
            if(Character.isUpperCase(password.charAt(i))){
                capital = true;
            }
            if(Character.isLowerCase(password.charAt(i))) {
                lowercase = true;
            }
        }
        if(!capital){
            Toast.makeText(this, "no capital letters found", Toast.LENGTH_SHORT).show();
        }
        if(!lowercase){
            Toast.makeText(this, "no lowercase letters found", Toast.LENGTH_SHORT).show();
        }
        if(emailG && userG && capital && lowercase && passCon && passL) {
            Registration(user, password, email);
        }
    }

    /**
     * To register new user, communicated with database by Json
     * @param username
     * @param password
     * @param email
     */
    public void Registration(String username, String password, String email)
    {

        //String url = "http://coms-309-vb-6.misc.iastate.edu:8080/register";

        String url = String.format("http://coms-309-vb-6.misc.iastate.edu:8080/register?username=%1$s&password=%2$s&email=%3$s", username, password, email);



        String tag_json_obj = "json_obj_req";

        Map<String, String> params = new HashMap<>();
        params.put("username", username);
        params.put("password", password);
        params.put("email", email);

        StringRequest Send =  new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Toast.makeText(getApplicationContext(), response, Toast.LENGTH_SHORT).show();
            }
        },  new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(getApplicationContext(), error.toString(), Toast.LENGTH_SHORT).show();
            }});

        AppController.getInstance().addToRequestQueue(Send, tag_json_obj);
    }

    /**
     * Jump to Main screen
     */
    public void back_Main(){
        Intent a = new Intent(this, MainActivity.class);
        startActivity(a);
    }


}
