package com.example.appscreenlayout.app;

import android.graphics.Canvas;
import android.provider.ContactsContract;
import android.view.MotionEvent;

import org.json.JSONObject;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public abstract class Object {
    protected float x, y;
    private int z = 0;
    private boolean should_destroy;
    private ObjectContainer parent_container;
    private String object_type;

    void init(JSONObject params) {}   /* Called on object init. */
    void update(float dt) {}          /* Called on every update, <dt> is the elapsed seconds since the last update */
    void draw(Canvas canvas) {}       /* Called during render, should draw the object to <dest> */
    void destroy() {}                 /* Called right before the object is removed from the parent ObjectContainer */
    void msg (JSONObject data) {}     /* Called arbitrarily by other objects or subsystems */
    boolean motion (MotionEvent evt) { return false; }  /* Called when MotionEvents are generated. If returns true, then "captures" the event and no other objects receive it. */
    void sessionready() {}            /* Called when all the players have joined the session and are ready to receive messages. */

    /**
     *
     * @return
     */
    /* Query if the object is about to be destroyed. */
    public boolean getShouldDestroy() {
        return should_destroy;
    }

    /**
     *
     */
    /* Ask for this object to be destroyed on the next update. */
    public void requestDestroy() {
        should_destroy = true;
    }

    /**
     *
     * @param parent
     * @param x
     * @param y
     * @param type
     */
    /* Internal function used by ObjectContainer to initialize fields */
    public void initialize(ObjectContainer parent, int x, int y, String type) {
        this.parent_container = parent;
        this.x = x;
        this.y = y;
        this.object_type = type;
    }

    /**
     *
     * @return
     */
    /* Get the object type as a string. */
    public String getObjectType() {
        return object_type;
    }

    /**
     *
     * @return
     */
    /* Get the object's parent container. */
    public ObjectContainer getParentContainer() {
        return parent_container;
    }

    public void putZ(int i){z=i;}


    public int getZ(){ return z;}
}


