package com.example.appscreenlayout.Connection;

import com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import java.io.IOException;
/**
 * @Author VB_6
 * @Project Clustercore
 */
import java.io.ObjectOutputStream;
import java.net.URI;
import java.net.URISyntaxException;

import static com.example.appscreenlayout.app.WebsocketQueueAndUnitedPlay.d;

public class UnitedPlay {


        ObjectOutputStream toQueue;

    //{
    //    try {
    //        toQueue = new ObjectOutputStream(WebsocketQueueAndUnitedPlay.connect);
    //    } catch (IOException e) {
    //        e.printStackTrace();
    //    }
    //}

        public static WebSocketClient Socket;

        static {
                try {
                        Socket = new WebSocketClient(new URI("http://coms-309-vb-6.misc.iastate.edu:8080/game"), d[0]) {
                                @Override
                                public void onOpen(ServerHandshake serverHandshake) {
                                        Socket.send("Hello World!");
                                }

                                @Override
                                public void onMessage(String s) {
                                        //Toast.makeText(, s, Toast.LENGTH_SHORT).show();
                                }

                                @Override
                                public void onClose(int i, String s, boolean b) {

                                }

                                @Override
                                public void onError(Exception e) {

                                }
                        };
                }
                catch (URISyntaxException e) {
                        e.printStackTrace();
                }


        }
}
