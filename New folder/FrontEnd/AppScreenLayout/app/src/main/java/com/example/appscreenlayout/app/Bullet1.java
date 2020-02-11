package com.example.appscreenlayout.app;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;

public class Bullet1 {

    int a;
    int b;
    boolean trigger = false;
    private boolean destroy = false;

    public void update(int dt, int x, int y){
        if (trigger){
            b = b+10;
        }
        else{
            a = x;
            b = y;
            trigger = true;
        }

        if (b > 2000){
            destroy();
        }
    }

    public void draw(Canvas canvas){
        Paint paint = new Paint();
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(Color.GREEN);

        canvas.drawCircle(a,b,60, paint);
    }

    public void destroy(){
        destroy = true;
    }
}
