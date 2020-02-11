package com.example.appscreenlayout.GameLoop;

import android.content.Context;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Game extends SurfaceView implements SurfaceHolder.Callback {

    private Loop loop;
    private int xpos;
    private int ypos;

    /**
     * Game function
     * @param context
     */
    public Game (Context context) {
        super(context);
        getHolder().addCallback(this);
        loop = new Loop(getHolder(), this, context);
        setFocusable(true);
    }

    /**
     * surfaceCreated function
     * @param holder
     */
    @Override
    public void surfaceCreated(SurfaceHolder holder){
        loop.setRunning(true);
        loop.start();
    }

    /**
     *
     * @param holder
     * @param format
     * @param w
     * @param h
     */
    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int w, int h){

    }

    /**
     *
     * @param holder
     */
    @Override
    public void surfaceDestroyed(SurfaceHolder holder){
        boolean retry = true;
        while (retry) {
            try {
                loop.setRunning(false);
                loop.join();
            }
            catch (InterruptedException a){
                a.printStackTrace();
            }
            retry = false;
        }
    }

    /**
     *
     * @param event
     * @return
     */
    @Override public boolean onTouchEvent (MotionEvent event) {
        /* Pass the event over to the loop, so it can go to the ObjectContainer, and then to the Objects */
        loop.onMotionEvent(event);
        return true;
    }

    public int getXpos() {
        return xpos;
    }

    public int getYpos() {
        return ypos;
    }
}
