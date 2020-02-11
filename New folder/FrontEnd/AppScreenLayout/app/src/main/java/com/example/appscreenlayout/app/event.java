package com.example.appscreenlayout.app;
import android.widget.Toast;

import com.example.appscreenlayout.Screens.Login;
import com.example.appscreenlayout.Screens.Register;
import java.util.ArrayList;
import java.util.List;
import java.util.Observable;
import java.util.Scanner;
import java.util.function.Consumer;
import android.widget.EditText;
import android.widget.Toast;


/*
   event notifier for Type B and Observer Pattern design.
 */
public class event implements Subject {

    private List<String> observers;

    private static String verifiedUser;
    private int a;

    public event(){
        observers = new ArrayList<String>();
    }

    public static String getVerifiedUser() {
        return verifiedUser;
    }

    public void register(String newObserver){
        newObserver = getVerifiedUser();
        observers.add(newObserver);
    }

    public void unregister(String dObserver) {
        int observerIndex = observers.indexOf(dObserver);
        observers.remove(observerIndex);
    }
    public void notifyObserver(){
        for(int i = 0; i <= observers.size(); i++){
           // Toast.makeText( this , "observer"+ verifiedUser +" You will be success", Toast.LENGTH_SHORT).show();
        }
    }

}
