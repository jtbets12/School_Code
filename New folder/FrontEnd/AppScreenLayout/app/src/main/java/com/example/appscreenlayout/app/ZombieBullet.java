package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.Log;

import com.example.appscreenlayout.R;

import org.json.JSONException;
import org.json.JSONObject;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public class ZombieBullet extends Object {
    private final int MOVE_SPEED = 800;
    private final int MIN_X      = 200;
    private final int MAX_X      = 1000;
    private final int WIDTH = 50;
    private final int HEIGHT = 100;
    private float BULLET_COUNT = 0;
    private final float ROT_SPEED = 720;
    private float movex;
    private float movey;

    private final int DEFAULT_DAMAGE = 20;
    private int damage = DEFAULT_DAMAGE;

    private Paint fill;
    private float angle;
    private float bulletAngle;

    private Bitmap bm;

    /**
     * initialize Json
     * @param params
     */
    @Override
    public void init(JSONObject params) {

        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.GREEN);

        bm = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.leaf);
        bm = Bitmap.createScaledBitmap(bm, WIDTH, HEIGHT, true);

        try {
            bulletAngle = ((Double) params.get("angle")).floatValue();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void msg(JSONObject params){
    }

    /**
     * viod function
     * @param dt
     */
    @Override
    public void update(float dt) {
        if (x < 0 || x > 5000 || y < -4000 || y>8000) {
            requestDestroy();
        }
        else {
            x += dt * MOVE_SPEED*Math.cos(bulletAngle);
            y += dt * MOVE_SPEED*Math.sin(bulletAngle);
        }

        angle += ROT_SPEED * dt;
    }

    /**
     * void function to draw Canvas
     * @param canvas
     */
    @Override
    public void draw(Canvas canvas) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(angle);
        canvas.drawBitmap(bm,-WIDTH / 2,-HEIGHT / 2,fill);
        canvas.restore();
    }

    public int getBulletWidth(){return WIDTH;}

    public int getBulletHeight(){return HEIGHT;}

}