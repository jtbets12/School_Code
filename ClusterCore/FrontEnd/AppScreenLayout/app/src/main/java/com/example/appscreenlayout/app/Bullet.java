package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

import com.example.appscreenlayout.R;

import org.json.JSONException;
import org.json.JSONObject;

public class Bullet extends Object {
    private final int MOVE_SPEED = 600;
    private final int MIN_X      = 200;
    private final int MAX_X      = 1000;
    private final int WIDTH = 50;
    private final int HEIGHT = 100;
    private float BULLET_COUNT = 0;
    private final int DEFAULT_DAMAGE = 20;

    private int damage = DEFAULT_DAMAGE;
    private float direction = 0.0f;

    private Paint fill;

    private Bitmap bm;

    @Override
    public void init(JSONObject params) {

        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.GREEN);

        bm = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.bolt);
        bm = Bitmap.createScaledBitmap(bm, WIDTH, HEIGHT, true);

        try {
            direction = ((Double) params.get("direction")).floatValue();
            damage = params.getInt("damage");
        } catch (JSONException e) {}
    }

    /**
     *
     * @param dt
     */
    @Override
    public void update(float dt) {
        /* Destroy if outside of the world */
        if (y > 0) {
            requestDestroy();
        }

        /* Move in the correct direction */
        this.x += dt * Math.cos(this.direction) * MOVE_SPEED;
        this.y += dt * Math.sin(this.direction) * MOVE_SPEED;
    }

    /**
     *
     * @param canvas
     */
    @Override
    public void draw(Canvas canvas) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate((float) Math.toDegrees(this.direction));
        canvas.drawBitmap(bm,-WIDTH / 2,-HEIGHT / 2, fill);
        canvas.restore();
    }

    public int getDamage() {
        return damage;
    }

    public int getBulletWidth(){return WIDTH;}

    public int getBulletHeight(){return HEIGHT;}

}
