package com.example.appscreenlayout.Screens;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import com.example.appscreenlayout.R;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class FriendsList extends AppCompatActivity implements friendlistView{

    private ListView friends_list;
    private Button btn_back;


    @Override

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_friends_list);
        friends_list = findViewById(R.id.friends_list);
        btn_back = findViewById(R.id.btn_back);
        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent a = new Intent(getBaseContext(), HubWorld.class);
                startActivity(a);
            }
        });
        friends_list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String item = (String) friends_list.getItemAtPosition(position);
            }
        });
    }
}
