package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.provider.ContactsContract;

import com.example.appscreenlayout.R;
import com.example.appscreenlayout.Screens.BasicLevel;
import com.example.appscreenlayout.app.Object;
import com.example.appscreenlayout.app.Player;
import com.example.appscreenlayout.app.PlayerBullet;
import com.example.appscreenlayout.app.ZombieBullet;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.logging.Logger;

import static com.example.appscreenlayout.Screens.BasicLevel.getMP;


/**
 * @Author VB_6
 * @Project Clustercore
 */
public class Boss extends Object {
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

    static boolean endSession = false;

    @Override
    public void init(JSONObject params) {
        endSession = false;
        right = true;

        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(Color.RED);

        health = MAX_HEALTH;

        bm = BitmapFactory.decodeResource(getParentContainer().getContext().getResources(), R.drawable.taranis);
        bm = Bitmap.createScaledBitmap(bm, 300, 300, true);

        healthpaint = new Paint();
        healthpaint.setStyle(Paint.Style.FILL);
        healthpaint.setColor(Color.GREEN);
        damagepaint = new Paint();
        damagepaint.setStyle(Paint.Style.FILL);
        damagepaint.setColor(Color.RED);
    }


    @Override
    public void update(float dt) {
        if (this.player == null) {
            this.player = (Player) getParentContainer().findByType("player");
        }

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

        bullet_timer += dt;

        if (bullet_timer > BULLET_TIMER_MAX) {
            bullet_timer = 0; /* Reset timer */

            float base_angle = -3.141f / 2.0f;

             /* Create some bullets, aim them at the player or straight down */
            if (this.player != null) {
                int player_center_x = (int) this.player.x + this.player.WIDTH / 2;
                int player_center_y = (int) this.player.y + this.player.HEIGHT / 2;
                int center_x = (int) this.x + this.WIDTH / 2;
                int center_y = (int) this.y + this.HEIGHT / 2;

                base_angle = (float) Math.atan2(player_center_y - center_y, player_center_x - center_x);
            }

            base_angle = (float) Math.PI / 2.0f;

            for (int i = 0; i < BULLET_FIRE_COUNT; ++i) {
                float bullet_direction = (float) (base_angle + Math.random() * BULLET_SPREAD * 2 - BULLET_SPREAD);

                try {
                    getParentContainer().createObject("bullet", (int) x + WIDTH / 2, (int) y + HEIGHT / 2, new JSONObject().put("direction", bullet_direction));
                } catch (JSONException e) {}
            }
        }

        /* Check for collisions with player bullets. */
        List<Object> bullets = getParentContainer().findAllByType("playerbullet");
        List<Object> zombie_bullets = getParentContainer().findAllByType("zombie_bullet");

        for (Object i : bullets) {
            PlayerBullet b = (PlayerBullet) i;

            /* Check for collisions, update health and destroy bullets */
            if (b.x + b.getBulletWidth() >= this.x && this.x + this.WIDTH >= b.x && b.y + b.getBulletHeight() >= this.y && this.y + this.HEIGHT >= b.y) {
                b.requestDestroy();
                this.health -= b.getDamage();
            }
        }

        for (Object i : zombie_bullets) {
            ZombieBullet b = (ZombieBullet) i;

            if (b.x + b.getBulletWidth() >= this.x && this.x + this.WIDTH >= b.x && b.y + b.getBulletHeight() >= this.y && this.y + this.HEIGHT >= b.y) {
                b.requestDestroy();
                this.health -= 20;
            }
        }

        /* Check for boss death */
        if (this.health <= 0) {
            endSession = true;
            BasicLevel.setVictory();
            requestDestroy();
            if(getMP()){
                BasicLevel.toDebriefing();
            }
            else{
                BasicLevel.toHub();
            }
        }

        this.health_counter += dt;
    }


    @Override
    public void draw(Canvas canvas) {
        canvas.drawBitmap(bm,x,y,fill);

        /* render healthbar */
        int alpha = (int) (255.0f - (255.0f * health_counter / HEALTHBAR_TIME));

        healthpaint.setAlpha(alpha);
        damagepaint.setAlpha(alpha);

        int top = (int) y + HEALTHBAR_Y_OFFSET - HEALTHBAR_WIDTH / 2;
        int bottom = top + HEALTHBAR_WIDTH;
        int current_health = health * WIDTH / MAX_HEALTH;

        canvas.drawRect(x, top, x + current_health, bottom, healthpaint);
        canvas.drawRect(x + current_health, top, x + WIDTH, bottom, damagepaint);
    }


    public static boolean bossDead(){
        return endSession;
    }

}
