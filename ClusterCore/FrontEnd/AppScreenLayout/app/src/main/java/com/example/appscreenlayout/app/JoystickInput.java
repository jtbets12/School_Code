package com.example.appscreenlayout.app;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.MotionEvent;

import org.json.JSONObject;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public class JoystickInput extends Object {
    /*
     * Boundary constants for the movement joystick.
     * Represented as ratios of the screen. 0.1 for the left boundary means-
     * 10% from the left to the right of the screen.
     */
    private final float MOVE_BOUNDARY_LEFT = 0.05f;
    private final float MOVE_BOUNDARY_RIGHT = 0.45f;
    private final float MOVE_BOUNDARY_TOP = 0.05f;
    private final float MOVE_BOUNDARY_BOTTOM = 0.95f;

    private boolean ready; /* True iff the joystick is ready for inputs. */

    /* Move boundaries expressed in actual pixels. Set on the first draw. */
    private int move_boundary_left, move_boundary_right, move_boundary_top, move_boundary_bottom;

    /* Location of an initial movement press */
    private float move_initial_x, move_initial_y;

    /* Current movement pointer location */
    private float move_current_x, move_current_y;

    /* True iff the user is currently interacting with the joystick */
    private boolean move_activated;

    /* Pointer to the player object. */
    private Player player_handle;

    /* Paints for drawing different elements */
    private Paint paint_area;
    private Paint paint_move_joystick;

    /**
     *
     * @param params
     */
    @Override
    public void init(JSONObject params) {
        player_handle = null; /* The player may not exist yet. We locate it in the update(). */

        paint_area = new Paint();
        paint_area.setColor(0x220000FF); /* Translucent dark blue */

        paint_move_joystick = new Paint();
        paint_move_joystick.setStyle(Paint.Style.FILL);
        paint_move_joystick.setColor(0xAA555555); /* Dark translucent gray */
        paint_move_joystick.setStrokeWidth(10.0f);
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

        if (!ready) return false; /* No boundaries yet. Ignore events for now. */

        switch (evt.getAction()) {
            case MotionEvent.ACTION_DOWN:
                /* If within the joystick boundary, start tracking movement. */
                if (evt.getX() <= move_boundary_left) break;
                if (evt.getX() >= move_boundary_right) break;
                if (evt.getY() <= move_boundary_top) break;
                if (evt.getY() >= move_boundary_bottom) break;

                move_initial_x = move_current_x = evt.getX();
                move_initial_y = move_current_y = evt.getY();
                move_activated = true;

                return true;
            case MotionEvent.ACTION_MOVE:
                if (!move_activated) break;

                /* Compute the new movement vector */
                move_current_x = evt.getX();
                move_current_y = evt.getY();

                /* If we have a player, notify it of the movement. */
                if (player_handle != null) {
                    player_handle.updateMoveInput(true, (int) (move_current_x - move_initial_x), (int) (move_current_y - move_initial_y));
                }

                return true;
            case MotionEvent.ACTION_UP:
                /* Deactivate the movement joystick if it is activated. */
                if (move_activated) {
                    move_activated = false;
                }

                /* Notify the player. */
                if (player_handle != null) {
                    player_handle.updateMoveInput(false, 0, 0);
                }

                return true;
        }

        return false;
    }

    /**
     *
     * @param dest
     */
    @Override
    public void draw(Canvas dest) {
        if (!ready) {
            /* Compute actual boundaries for the joystick, now that we have a Canvas */
            move_boundary_left = (int) (MOVE_BOUNDARY_LEFT * dest.getWidth());
            move_boundary_right = (int) (MOVE_BOUNDARY_RIGHT * dest.getWidth());
            move_boundary_top = (int) (MOVE_BOUNDARY_TOP * dest.getHeight());
            move_boundary_bottom = (int) (MOVE_BOUNDARY_BOTTOM * dest.getHeight());

            ready = true; /* After the first draw, the joystick is ready. */
        }

        /* Get the camera location. */
        float cx = ObjectContainer.getInstance().getCameraX() - dest.getWidth() / 2;
        float cy = ObjectContainer.getInstance().getCameraY() - dest.getHeight() / 2;

        /* Draw the move joystick if it is live. */
        if (move_activated) {
            dest.drawCircle(move_initial_x + cx, move_initial_y + cy, 45, paint_move_joystick);
            dest.drawCircle(move_current_x + cx, move_current_y + cy, 30, paint_move_joystick);
            dest.drawLine(move_initial_x + cx, move_initial_y + cy, move_current_x + cx, move_current_y + cy, paint_move_joystick);
        }
    }
}
