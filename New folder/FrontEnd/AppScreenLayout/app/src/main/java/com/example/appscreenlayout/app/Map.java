package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.provider.ContactsContract;

import com.example.appscreenlayout.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.logging.Logger;

public class Map extends Object {
    private final int MOVE_SPEED = 400;
    private final int MIN_X      = 200;
    private final int MAX_X      = 1000;
    private final int WIDTH      = 300;
    private final int HEIGHT     = 300;
    private final int MAX_HEALTH = 200;
    private final int BULLET_FIRE_RATE = 2; /* Shots fired per second */
    private final int BULLET_FIRE_COUNT = 2; /* Bullets fired per shot */
    private final float BULLET_SPREAD = 1.0f; /* Bullet spread, higher is less accurate */

    private final float BULLET_TIMER_MAX = 1.0f / BULLET_FIRE_RATE;
    private final float HEALTHBAR_TIME = 3.0f;
    private final int HEALTHBAR_WIDTH = 20;
    private final int HEALTHBAR_Y_OFFSET = 20 + HEIGHT;

    private float bullet_timer = 0.0f;
    private float health_counter = 0.0f;

    private Paint healthpaint;
    private Paint damagepaint;

    private Player player;

    private int health;
    private Bitmap bm;

    private boolean right; /* Is the boss moving right? */
    private Paint fill;

    @Override
    public void init(JSONObject params) {
        putZ(-1);

        right = true;

        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.RED);

        health = MAX_HEALTH;

        bm = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.map);
        bm = Bitmap.createScaledBitmap(bm, 1440, 5000, true);

        healthpaint = new Paint();
        healthpaint.setStyle(Paint.Style.FILL);
        healthpaint.setColor(Color.GREEN);
        damagepaint = new Paint();
        damagepaint.setStyle(Paint.Style.FILL);
        damagepaint.setColor(Color.RED);
    }

    @Override
    public void update(float dt) {
        //Do nothing
    }

    @Override
    public void draw(Canvas canvas) {
        canvas.drawBitmap(bm,x,y,fill);
    }
}
