package com.example.appscreenlayout.app;

import java.util.Observer;

public interface Subject {
    public void register(String newObserver);
    public void unregister(String dObserver);
    public void notifyObserver();
}
