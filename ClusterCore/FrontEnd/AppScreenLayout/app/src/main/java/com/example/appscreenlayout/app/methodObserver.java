package com.example.appscreenlayout.app;

import java.util.ArrayList;

import javax.security.auth.Subject;


public class methodObserver implements Observer {

    private Subject event;
    private static int observerIDTracker = 0;
    private int observerID;


    private methodObserver(Subject event){
        this.event = event;
        this.observerID = observerIDTracker++;
        System.out.println("New Observer " + this.observerID);
    }

    public void update(String player){
        printUser();
    }

    public void printUser(){
        System.out.println(observerID + com.example.appscreenlayout.app.event.getVerifiedUser() + "you will be success");

    }

}
