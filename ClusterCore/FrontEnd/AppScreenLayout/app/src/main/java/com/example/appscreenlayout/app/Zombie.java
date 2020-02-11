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
public class Zombie extends Object{

    private final int WIDTH            = 200;
    private final int HEIGHT           = 200;

    private Paint fill;

    private float x;
    private float y;
    private int angle;

    /*Bitmaps*/
    Bitmap bmr;
    Bitmap bmbr;
    Bitmap bml;
    Bitmap bmbl;
    Bitmap cur;

    /**
     *
     * @param params
     */
    @Override
    public void init(JSONObject params) {
        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.BLACK);
        fill.setStrokeWidth(12.0f);

        this.initializeBitmaps();
    }

    /**
     *
     * @param params
     */
    @Override
    public void msg(JSONObject params){
        try {
            x = (float) params.getDouble("x");
            y = (float) params.getDouble("y");
            angle = params.getInt("angle");

            Log.d("Zombie", "Updating zombie!");
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * @param dt
     */
    @Override
    public void update(float dt){

    }

    /**
     *
     * @param canvas
     */
    @Override
    public void draw(Canvas canvas){
        if (angle == 1){
            canvas.drawBitmap(bmbr,x,y,fill);
        }
        else if (angle == 2){
            canvas.drawBitmap(bmbl,x,y,fill);
        }
        else if (angle == 3){
            canvas.drawBitmap(bmr,x,y,fill);
        }
        else if (angle == 4){
            canvas.drawBitmap(bml,x,y,fill);
        }
        else{
            canvas.drawBitmap(bml,x,y,fill);
        }
    }

    /*Bitmap Initializer*/
    private void initializeBitmaps(){
        bmr = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esus);
        bmr = Bitmap.createScaledBitmap(bmr, WIDTH, HEIGHT, true);
        bml = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusl);
        bml = Bitmap.createScaledBitmap(bml, WIDTH, HEIGHT, true);
        bmbr = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusb);
        bmbr = Bitmap.createScaledBitmap(bmbr, WIDTH, HEIGHT, true);
        bmbl = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusbl);
        bmbl = Bitmap.createScaledBitmap(bmbl, WIDTH, HEIGHT, true);
        cur = bmr;
    }
}
