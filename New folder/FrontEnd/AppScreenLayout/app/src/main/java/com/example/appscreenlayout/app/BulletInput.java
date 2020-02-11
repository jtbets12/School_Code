package com.example.appscreenlayout.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.Log;
import android.view.MotionEvent;

import com.example.appscreenlayout.R;

import org.json.JSONObject;

import java.util.logging.Logger;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public class BulletInput extends Object{
    private final float MOVE_BOUNDARY_LEFT = 0.55f;
    private final float MOVE_BOUNDARY_RIGHT = 1f;
    private final float MOVE_BOUNDARY_TOP = 0.05f;
    private final float MOVE_BOUNDARY_BOTTOM = 0.95f;

    private boolean ready; /* True iff the joystick is ready for inputs. */

    /* Pointer to the player object. */
    private Player player_handle;

    /* Move boundaries expressed in actual pixels. Set on the first draw. */
    private int move_boundary_left, move_boundary_right, move_boundary_top, move_boundary_bottom;

    /* Paints for drawing different elements */
    private Paint paint_area;
    private Paint fill;

    /*Bullet Image*/

    /**
     *
     * @param params
     */
    @Override
    public void init(JSONObject params) {
        player_handle = null; /* The player may not exist yet. We locate it in the update(). */

        paint_area = new Paint();
        paint_area.setColor(0x220000FF); /* Translucent dark blue */

        fill = new Paint();
        fill.setStyle(Paint.Style.FILL);
        fill.setColor(0xAA555555); /* Dark translucent gray */
        fill.setStrokeWidth(10.0f);
    }

    /**
     *
     * @param dt
     */
    @Override
    public void update(float dt) {
        /* Locate the player object if we haven't yet. */
        if (player_handle == null) {
            player_handle = (Player) getParentContainer().findByType("player");
        }
    }

    /**
     *
     * @param evt
     * @return
     */
    @Override
    public boolean motion (MotionEvent evt) {
        /* We only want to catch the motion events in specific regions of the screen. */
        switch(evt.getActionMasked()){
            case MotionEvent.ACTION_DOWN:
                if (evt.getX() >= move_boundary_left && evt.getX() <= move_boundary_right && evt.getY() >= move_boundary_top && evt.getY() <= move_boundary_bottom) {
                    player_handle.createBullet();
                    return true;
                }
            case MotionEvent.ACTION_POINTER_DOWN:
                int pointer = evt.getPointerCount() - 1;

                if (evt.getX(pointer) >= move_boundary_left && evt.getX(pointer) <= move_boundary_right && evt.getY(pointer) >= move_boundary_top && evt.getY(pointer) <= move_boundary_bottom) {
                    player_handle.createBullet();
                    return true;
                }
        }
        return false;
    }

    /**
     *
     * @param dest
     */
    @Override
    public void draw(Canvas dest) {
        move_boundary_left = (int) (MOVE_BOUNDARY_LEFT * dest.getWidth());
        move_boundary_right = (int) (MOVE_BOUNDARY_RIGHT * dest.getWidth());
        move_boundary_top = (int) (MOVE_BOUNDARY_TOP * dest.getHeight());
        move_boundary_bottom = (int) (MOVE_BOUNDARY_BOTTOM * dest.getHeight());
    }
}
