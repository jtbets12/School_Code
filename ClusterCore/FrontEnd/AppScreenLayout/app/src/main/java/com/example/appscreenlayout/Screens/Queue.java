package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.example.appscreenlayout.R;

import java.util.ArrayList;


/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Queue extends AppCompatActivity implements queueView {

    private ListView Queue_Members;
    private ArrayAdapter<String> adapter;
    private ArrayList<String> Members = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_queue);

        Queue_Members = findViewById(R.id.Queue_Members);

        adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, Members);
        Queue_Members.setAdapter(adapter);

        Members.add(Login.getVerifiedUser());
        adapter.notifyDataSetChanged();

        String QueueAuth = "{\"type\":\"auth\",\"token\":\""+getToken()+"\"}";


        //if()
        //Members.add()
    }

    public String getToken(){return Login.grabToken();}

}
