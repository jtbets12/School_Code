package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

import com.example.appscreenlayout.GameLoop.Loop;
import com.example.appscreenlayout.R;
import com.example.appscreenlayout.Screens.BasicLevel;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;
import com.example.appscreenlayout.GameLoop.*;

import static com.example.appscreenlayout.Screens.BasicLevel.getMP;


/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Player extends Object {
    private final float MOVE_ACCEL     = 40.0f;
    private final float MOVE_SPEED_MAX = 300.0f;
    public final int WIDTH            = 200;
    public final int HEIGHT           = 200;
    private final float HEALTHBAR_SPEED = 40; /* Health bar animation speed */
    public int health;
    public int MAX_HEALTH = 200;
    public float healthcounter;
    public float health_anim = 0;
    private final float HEALTHBAR_TIME = 3.0f;
    private final int HEALTHBAR_WIDTH = 20;
    private final int HEALTHBAR_Y_OFFSET = -20;
    private int translateCounter = 0;
    private int translateSaveUp = 0;
    private int translateSaveDown = 0;
    private boolean lock;
    public int angle;

    private Paint fill;
    private Paint healthpaint;
    private Paint damagepaint;

    private boolean moving; /* Moving enabled */
    private boolean healthchange = false;
    private boolean dead; /* Is the player dead? */
    private float move_dx, move_dy; /* Move velocity vector */
    private boolean endSession;

    String zombie_uuid;

    Bitmap bmr;
    Bitmap bml;
    Bitmap bmbr;
    Bitmap bmbl;
    Bitmap cur;

    /**
     * initialize Jason
     * @param params
     */
    @Override
    public void init(JSONObject params) {
        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.BLACK);
        fill.setStrokeWidth(12.0f);

        healthpaint = new Paint();
        healthpaint.setStyle(Paint.Style.FILL);
        healthpaint.setColor(Color.GREEN);
        damagepaint = new Paint();
        damagepaint.setStyle(Paint.Style.FILL);
        damagepaint.setColor(Color.RED);

        dead = false; /* Start alive */

        /*Set health*/
        health = 200;
        health_anim = health;

        /*Get player model*/
        int model = 1;
        try {
            model = ((int) params.get("playerModel"));
        } catch (JSONException e) {}

        /*Create relevant bitmaps*/
        this.initializeBitmaps(model);

        lock = false;

        zombie_uuid = WebsocketQueueAndUnitedPlay.getInstance().createRemoteObject("zombie", (int) x, (int) y, null);
    }

    /**
     * Called when the session is ready and others are ready to receive our zombies.
     */
    @Override
    public void sessionready() {
        /* Create the remote zombie and hold onto the UUID. */
        //zombie_uuid = WebsocketQueueAndUnitedPlay.getInstance().createRemoteObject("zombie", (int) x, (int) y, null);
    }

    /**
     *
     * @param dt
     */
    @Override
    public void update(float dt) {
        Canvas current = Loop.getCanvas();
        if (moving) {
            if((!(this.move_dx > 0 && x == current.getWidth()))&&(!(this.move_dx < 0 && x == 0))){
                x += dt * this.move_dx;
            }
            if((!(this.move_dy > 0 && y == current.getHeight()))&&(!(this.move_dy < 0 && y == 0))){
                y += dt * this.move_dy;
            }
        }


        /*Add to health counter*/
        healthcounter = healthcounter + dt;

        /* Animate healthbar if needed */
        if (health_anim > health) {
            health_anim -= dt * HEALTHBAR_SPEED;
        }

        if (health_anim < health) {
            health_anim += dt * HEALTHBAR_SPEED;
        }

        /* Update the remote zombie class */
        if (zombie_uuid != null) {
            JSONObject zombie_update = new JSONObject();

            try {
                zombie_update.put("x", x);
                zombie_update.put("y", y);
                zombie_update.put("angle", angle);
            } catch (JSONException e) {
                return;
            }

            WebsocketQueueAndUnitedPlay.getInstance().sendToObject(zombie_uuid, zombie_update);
        }

        getParentContainer().setCamera(x + WIDTH / 2, y + HEIGHT / 2);
    }

    /**
     *
     * @param canvas
     */
    @Override
    public void draw(Canvas canvas) {
        //canvas.drawRect(x, y, x + WIDTH, y + HEIGHT, fill);
        if (move_dx > 0 && move_dy < 0){
            canvas.drawBitmap(bmbr,x,y,fill);
            cur = bmr;
            angle = 1;
        }
        else if (move_dx < 0 && move_dy < 0){
            canvas.drawBitmap(bmbl,x,y,fill);
            cur = bml;
            angle = 2;
        }
        else if (move_dx > 0 && move_dy > 0){
            canvas.drawBitmap(bmr,x,y,fill);
            cur = bmbr;
            angle = 3;
        }
        else if (move_dx < 0 && move_dy > 0){
            canvas.drawBitmap(bml,x,y,fill);
            cur = bmbl;
            angle = 4;
        }
        else{
            canvas.drawBitmap(cur,x,y,fill);
        }



        /* If we're moving, show a little pointer with the direction. */
        if (moving) {
            canvas.drawLine(x + WIDTH / 2, y + HEIGHT / 2, x + WIDTH / 2 + move_dx, y + HEIGHT / 2 + move_dy, fill);
        }

        /*Draw health bar*/
        if (healthchange){
            int healthbar_width = (int) ((WIDTH * health) / MAX_HEALTH);
            int alpha = 255 - Math.min(255, (int) (512.0f * healthcounter / HEALTHBAR_TIME));

            int top = (int) y + HEALTHBAR_Y_OFFSET - HEALTHBAR_WIDTH / 2;
            int bottom = top + HEALTHBAR_WIDTH;


            healthpaint.setAlpha(alpha);
            damagepaint.setAlpha(alpha);
            canvas.drawRect(x, top, x + healthbar_width, bottom, healthpaint);
            canvas.drawRect(x + healthbar_width, top, x + WIDTH, bottom, damagepaint);

            if (healthcounter > HEALTHBAR_TIME){
                healthchange = false;
                healthcounter = 0;
            }
        } else {
            healthcounter = 0;
        }

        /* Check for player collisions with boss bullets */
        this.playerCollision(getParentContainer().findAllByType("bullet"));
    }

    /**
     *
     * @param moving
     * @param dx
     * @param dy
     */
    /* Called from the JoystickInput class when the user activates the move joystick. */
    public void updateMoveInput(boolean moving, int dx, int dy) {
        this.moving = moving;

        if (this.moving) {
            /* Get the vector's velocity and direction. */
            float magnitude = (float) Math.sqrt(dx * dx + dy * dy);
            float vel = MOVE_ACCEL * magnitude;

            if (vel > MOVE_SPEED_MAX) {
                vel = MOVE_SPEED_MAX;
            }

            if (magnitude == 0){
                this.move_dx = 0;
                this.move_dy = 0;
            }
            else{
                this.move_dx = (dx / magnitude) * vel;
                this.move_dy = (dy / magnitude) * vel;
            }
        }
    }

    /**
     * Return health
     * @return
     */
    public int getHealth(){
        return health;
    }

    /**
     * Call if collision occurs
    */
    public void healthChange(){
        healthchange = true;
    }

    /**
     * Collision logic with player and boss bullets
     * @param objects
     */
    private void playerCollision(ArrayList<Object> objects){
        Iterator i = objects.iterator();
        while (i.hasNext()){
                Bullet bullet = (Bullet) i.next();
                if (bullet.x <= this.x + this.WIDTH && bullet.x + bullet.getBulletWidth() >= this.x && bullet.y + bullet.getBulletHeight() >= this.y && bullet.y <= this.y + this.HEIGHT) {
                    /* Destroy the bullet. */
                    bullet.requestDestroy();

                    /* Decrement player health. */
                    this.health = this.health - bullet.getDamage();

                    if (this.health <= 0){

                        dead = true;
                        BasicLevel.setDefeat();
                        requestDestroy();
                        if(getMP()){
                            BasicLevel.toDebriefing();
                        }
                        else{
                            BasicLevel.toHub();
                        }

                    }

                    this.healthChange();
                }

        }

    }

    /**
     * Creates player bullet
     */
    public void createBullet(){
        if (dead) return; /* Dead players don't shoot bullets */

        float movex;
        float movey;

        float magnitude = (float) Math.sqrt(move_dx*move_dx+move_dy*move_dy);

        if (magnitude == 0){
            movex = 0;
            movey = 0;
        }
        else{
            movex = (move_dx / magnitude);
            movey = (move_dy / magnitude);
        }

        JSONObject job = new JSONObject();
        try {
            job.put("movex", movex);
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            job.put("movey",movey);
        } catch (Exception e) {
            e.printStackTrace();
        }

        getParentContainer().createObject("playerbullet",(int) x + WIDTH / 2, (int) y + HEIGHT / 2,job);
    }

    /*Bitmap Initializer*/
    private void initializeBitmaps(int model){

        if (model == 1){
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

        else if (model == 2){
            bmr = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esus1);
            bmr = Bitmap.createScaledBitmap(bmr, WIDTH, HEIGHT, true);
            bml = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusl1);
            bml = Bitmap.createScaledBitmap(bml, WIDTH, HEIGHT, true);
            bmbr = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusb1);
            bmbr = Bitmap.createScaledBitmap(bmbr, WIDTH, HEIGHT, true);
            bmbl = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusbl1);
            bmbl = Bitmap.createScaledBitmap(bmbl, WIDTH, HEIGHT, true);
            cur = bmr;
        }

        else if (model == 3){
            bmr = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esus2);
            bmr = Bitmap.createScaledBitmap(bmr, WIDTH, HEIGHT, true);
            bml = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusl2);
            bml = Bitmap.createScaledBitmap(bml, WIDTH, HEIGHT, true);
            bmbr = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusb2);
            bmbr = Bitmap.createScaledBitmap(bmbr, WIDTH, HEIGHT, true);
            bmbl = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.esusbl2);
            bmbl = Bitmap.createScaledBitmap(bmbl, WIDTH, HEIGHT, true);
            cur = bmr;
        }
    }
}
