package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.example.appscreenlayout.R;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class MainActivity extends AppCompatActivity implements mainactivityView {

    private Button but_reg;
    private Button but_log;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        but_reg = findViewById(R.id.but_reg);
        but_log = findViewById(R.id.but_log);
        but_log.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openLogin();
            }
        });
        but_reg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openRegister();
            }
        });
    }

    /**
     * Jump to Login screen
     */
    public void openLogin(){
        Intent b = new Intent(this, Login.class);
        startActivity(b);
    }

    /**
     * Jump to Register screen
     */
    public void openRegister(){
        Intent a = new Intent(this, Register.class);
        startActivity(a);
    }

}
