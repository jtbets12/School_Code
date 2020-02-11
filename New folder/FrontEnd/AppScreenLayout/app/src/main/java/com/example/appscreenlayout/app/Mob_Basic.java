package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

import com.example.appscreenlayout.R;

import org.json.JSONObject;

public class Mob_Basic extends Object {
    private final int MOVE_SPEED = 30;
    private final int MIN_X      = 100;
    private final int MAX_X      = 500;
    private final int WIDTH      = 50;
    private final int HEIGHT     = 50;
    private float BULLET_COUNT = 0;
    private Bitmap bm_mob;

    private boolean right; /* Is the boss moving right? */
    private Paint fill;

    @Override
    public void init(JSONObject params) {
        right = true;

        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.RED);

        bm_mob = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.test);
        bm_mob = Bitmap.createScaledBitmap(bm_mob, 50, 50, true);
    }

    @Override
    public void update(float dt) {
        /* Move the boss by MOVE_SPEED pixels per second */
        if (right) {
            x += dt * MOVE_SPEED;

            if (x >= MAX_X) {
                right = false;
            }
        } else {
            x -= dt * MOVE_SPEED;

            if (x <= MIN_X) {
                right = true;
            }
        }
        BULLET_COUNT = BULLET_COUNT + dt;
        if (BULLET_COUNT > 2){
            getParentContainer().createObject("bullet",(int) x, (int) y,null);
            BULLET_COUNT = 0;
        }
    }

    @Override
    public void draw(Canvas canvas) {
        canvas.drawBitmap(bm_mob,x,y,fill);
    }
}


