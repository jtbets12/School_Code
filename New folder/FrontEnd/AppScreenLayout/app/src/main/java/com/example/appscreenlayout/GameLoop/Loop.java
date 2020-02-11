 package com.example.appscreenlayout.GameLoop;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.MotionEvent;
import android.view.SurfaceHolder;

import com.example.appscreenlayout.GameLoop.Game;
import com.example.appscreenlayout.Screens.HubWorld;
import com.example.appscreenlayout.app.ObjectContainer;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Loop extends Thread {
    private final int FPS_DIVISIONS = 4; /* Precision of FPS calculator. Larger updates more often but less precise. */
    private final int FPS_MAX_NS = 1000000000 / FPS_DIVISIONS;
    private final float FPS_TEXT_SIZE = 32.0f;

    private float current_fps; /* Current FPS. Updated every (1/FPS_DIVISIONS) seconds. */

    private SurfaceHolder holder;
    private Game game;
    private boolean running;
    private static Canvas canvas;
    private int healthval = 1440;
    private Paint fps_paint;

    private ObjectContainer container;

    /**
     * game loop
     * @param surfaceHolder
     * @param game
     * @param context
     */
    public Loop(SurfaceHolder surfaceHolder, Game game, Context context) {
        super();
        this.holder = surfaceHolder;
        this.game = game;

        this.container = ObjectContainer.getInstance();

        /* Initialize FPS rendering paint */
        fps_paint = new Paint();
        fps_paint.setColor(Color.BLACK);
        fps_paint.setTextSize(FPS_TEXT_SIZE);

        container = new ObjectContainer(context);

        /* Create map */


        /* Create a joystick input */
        container.createObject("joystickinput", 0, 0, null);
        container.createObject("bulletinput", 0, 0, null);

        /* Create a player */
        container.createObject("player", 300, 1000, HubWorld.getPlayerInfo());
        container.createObject("map",0,-2500,null);

        /* Create a test boss */
        container.createObject("boss", 100, -2400, null);
        container.createObject("bm_mob", 50, 50, null);

    }

    /**
     * run loop
     */
    @Override
    public void run() {
        /* Frame counter and nanosecond counter for FPS calculation */
        long fps_current_ns = 0, fps_current_frame = 0;

        /* Nanosecond time points used for delta time. */
        long next_time_ns, last_time_ns, delta_time_ns;

        /*
         * The first delta time will always be 0 -- but this is OK, the next frame will
         * have the correct time difference.
         */
        next_time_ns = last_time_ns = System.nanoTime();

        while (running) {
            /* Update time points */
            next_time_ns = System.nanoTime();
            delta_time_ns = next_time_ns - last_time_ns;
            last_time_ns = next_time_ns;

            /* Compute delta time in seconds */
            float delta_time_s = delta_time_ns / 1000000000.0f;

            /* Update game objects */
            container.update(delta_time_s);

            canvas = null;

            try {
                canvas = this.holder.lockCanvas();
                synchronized (holder){
                    // Main Loop Code
                    clearCanvas();

                    /* Render objects */
                    container.draw(canvas);

                    /* Render FPS text in corner */
                    canvas.drawText("FPS: " + current_fps, 10, canvas.getHeight() - 30, fps_paint);
                }
            }

            catch (Exception a) {
                a.printStackTrace();
            }

            finally {
                if (canvas != null){
                    try{
                        holder.unlockCanvasAndPost(canvas);
                    } catch (Exception a){
                        a.printStackTrace();
                    }
                }
            }

            /* Calculate FPS */
            ++fps_current_frame;
            fps_current_ns += delta_time_ns;

            if (fps_current_ns >= FPS_MAX_NS) {
                /* Compute new FPS value. */
                current_fps = fps_current_frame / (fps_current_ns / 1000000000.0f);

                /* Reset frame counter and timer. */
                fps_current_frame = 0;
                fps_current_ns = 0;
            }
        }

    }

    /**
     * set running to isRunning
     * @param isRunning
     */
    public void setRunning (boolean isRunning){
        running = isRunning;
    }

    /**
     * updateCanvas and parameter settings
     */
    public void updateCanvas (){
        canvas.drawColor(Color.WHITE);
        Paint paint = new Paint();
        paint.setStyle(Paint.Style.FILL);
        canvas.drawCircle(game.getXpos(),game.getYpos()-1000,30, paint);
        /*Rect rect = new Rect(200,200,400,400);
        canvas.drawRect(rect,paint);*/

        if (200 < game.getXpos() & game.getXpos() < 400 & game.getYpos()-1000 < 400 & game.getYpos()-1000 > 200){
            canvas.drawColor(Color.RED);
            healthval -= 10;
        }

        Paint paint1 = new Paint();
        paint1.setStyle(Paint.Style.FILL);
        paint1.setColor(Color.GREEN);
        Rect health = new Rect(0, 2500,healthval,2960);
        canvas.drawRect(health,paint1);
    }

    /**
     * void function to clear Canvas
     */
    public void clearCanvas() {
        canvas.drawColor(Color.WHITE);
    }

    /**
     *
     * @param evt
     */
    public void onMotionEvent(MotionEvent evt) {
        /* Pass motion events down to objects. */
        container.onMotionEvent(evt);
    }

    public static Canvas getCanvas(){return canvas;}

}
