package com.example.appscreenlayout.Screens;

import android.os.Bundle;

import org.json.JSONObject;

public interface loginView {

    public void back_Main();
    public boolean getStatus(JSONObject response);
    public String getToken(JSONObject response);

}
