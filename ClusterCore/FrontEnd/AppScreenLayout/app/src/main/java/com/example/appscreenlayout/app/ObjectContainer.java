package com.example.appscreenlayout.app;

import android.content.Context;
import android.graphics.Canvas;
import android.util.Log;
import android.view.MotionEvent;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 * @Author VB_6
 * @Project Clustercore
 */
public class ObjectContainer {
    private ArrayList<Object> objects;
    private ArrayList<Object> templist;
    private Context context;
    private Canvas canvas;
    private HashMap<String,Object> map;

    private float camera_x;
    private float camera_y;

    private static ObjectContainer current_container;

    private class SortByZ implements Comparator<Object> {
        public int compare(Object a, Object b) {
            return a.getZ() - b.getZ();
        }
    }

    public static ObjectContainer getInstance() {
        if (current_container == null) {
            Log.e("ObjectContainer", "getInstance() called before ObjectContainer was initialized!");
        }

        return current_container;
    }

    public ObjectContainer(Context ctx) {
        objects = new ArrayList<>();
        templist = new ArrayList<>();
        map = new HashMap<>();

        camera_x = 0;
        camera_y = 0;

        current_container = this;
        this.context = ctx;
    }

    /*
     * Create a new object of type <type> at (<x>, <y>), and pass <params> to the init() function.
     * Supported type names:
     * "player" => Player
     * "boss"   => Boss
     */

    /**
     * multiple functions class to set object in game
     * @param type
     * @param x
     * @param y
     * @param params
     * @param context
     */
    public Object createObject(String type, int x, int y, JSONObject params) {
        Object new_object;

        /* Initialize the correct object subclass, or stop if the type is bad */
        if (type.equals("player")) {
            new_object = new Player();
        } else if (type.equals("boss")) {
            new_object = new Boss();
        }
        else if (type.equals("zombie")) {
            new_object = new Zombie();
        } else if (type.equals("bullet")){
            new_object = new Bullet();
        }
          else if (type.equals("playerbullet")){
            new_object = new PlayerBullet();
        }else if (type.equals("zombie_bullet")){
            new_object = new ZombieBullet();
        }
          else if (type.equals("map")) {
            new_object = new Map();
        }
          else if (type.equals("bulletinput")){
            new_object = new BulletInput();
        }
          else if (type.equals("joystickinput")) {
            new_object = new JoystickInput();
        }
          else {
            Logger.getGlobal().warning("createObject: Unknown object type " + type + ", ignoring");
            return null;
        }
          //Add camera

        /* Initialize the appropriate fields in the object */
        new_object.initialize(this, x, y, type);

        /* Add the object to the temporary */
        templist.add(new_object);
        //objects.add(new_object);

        /* Allow null params, but sneak in and replace it with a blank json object */
        if (params == null) {
            params = new JSONObject();
        }

        /* Call the per-object init handler */
        new_object.init(params);

        /* TEMPORARY: log the creation of the object */
        Logger.getGlobal().log(Level.FINE, "Created object of type " + type + " at (" + x + ", " + y + ")");

        /*Allow for Objects to get Context*/
        this.context = context;

        return new_object;
    }

    public void createObjectWithID(String type, int x, int y, JSONObject params, String id) {
        Object o = createObject(type,x,y,params);
        map.put(id,o);

        Log.d("ObjectContainer", "Created remote object of type " + type + " with UUID " + id);
    }

    /**
     * Update all objects in the container by <dt> seconds.
     * @param dt
     */
    public void update(float dt) {

        /* Check if new objects have been added since last update, add to objects if so*/
        if (!templist.isEmpty()){
            for (int i = 0; i < templist.size() ; i++){
                objects.add(templist.get(i));
            }
            templist.clear();
        }

        Iterator i = objects.iterator();

        /* Use explicit iterators so we can remove objects while iterating */
        while (i.hasNext()) {
            Object cur = (Object) i.next();
            cur.update(dt);

            /* Destroy objects as needed */
            if (cur.getShouldDestroy()) {
                cur.destroy();
                i.remove();
            }
        }

    }

    /**
     * Render all objects in the container to <dest>
     * @param dest
     */
    public void draw(Canvas dest) {
        /* Offset objects by the camera. */
        dest.save();
        dest.translate(-camera_x + dest.getWidth() / 2, -camera_y + dest.getHeight() / 2);

        /* No removing here, so we can do a faster iteration */
        for (Object i : objects) {
            i.draw(dest);
        }
        objects.get(2).draw(dest);

        dest.restore();

        Collections.sort(objects, new SortByZ());
    }

    /**
     * Get the number of currently alive objects
     * @return
     */
    public int getNumObjects() {
        return objects.size();
    }

    /**
     * Find a single object by type. If there is more than one then this function returns the first found.
     * @param type
     * @return
     */
    public Object findByType(String type) {
        for (Object i : objects) {
            if (i.getObjectType().equals(type)) {
                return i;
            }
        }

        return null;
    }

    /**
     * Finds all objects of a certain type.
     * @param type
     * @return
     */
    public ArrayList<Object> findAllByType(String type) {
        ArrayList<Object> out = new ArrayList<>();

        for (Object i : objects) {
            if (i.getObjectType().equals(type)) {
                out.add(i);
            }
        }

        return out;
    }

    /**
     * Pass a MotionEvent to the Object motion() handlers
     * @param evt
     */
    public void onMotionEvent(MotionEvent evt) {
        for (Object i : objects) {
            if (i.motion(evt)) break;
        }
    }

    /**
     * return context
     * @return
     */
    public Context getContext(){
        return context;
    }

    public Object getObjectByID(String id) {
        return map.get(id);
    }

    /**
     * Writes a message to an object by UUID. If the object is
     * not found, the message is ignored and an error is printed.
     * @param uuid Object ID to send to
     * @param body JSON body to pass
     */
    public void msgObject(String uuid, JSONObject body) {
        Object target = getObjectByID(uuid);

        if (target == null) {
            Log.e("ObjectContainer", "Unknown object ID " + uuid + "!");
            return;
        }

        target.msg(body);
    }

    /**
     * Set the camera location.
     * @param x X offset
     * @param y Y offset
     */
    public void setCamera(float x, float y) {
        camera_x = x;
        camera_y = y;
    }

    /**
     * Notify the objects that the session is ready.
     */
    public void sendSessionReady() {
        for (Object cur : objects) {
            cur.sessionready();
        }
    }

    public float getCameraX() {
        return camera_x;
    }

    public float getCameraY() {
        return camera_y;
    }
}
