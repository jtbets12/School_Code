/*
 * movement.c
 *
 *  Created on: Feb 5, 2019
 *      Author: gmrueger
 */
#include "movement.h"


void move_forward(oi_t *sensor, int millimeters) {

    int sum = 0;

    oi_setWheels(525,500); //move forward full speed

    while(sum < millimeters) {
        oi_update(sensor);
        sum += sensor -> distance;
    }

    oi_setWheels(0,0); //stop
    oi_free(sensor);
}

void turn_right(oi_t *sensor, int degrees)  {
    int sum = degrees;

    oi_setWheels(-515,480);

    while(sum > 0) {
        oi_update(sensor);
        sum += sensor -> angle;
    }

    oi_setWheels(0,0); //stop
    oi_free(sensor);
}

void turn_left(oi_t *sensor, int degrees)   {
    int sum = 0;

    oi_setWheels(515, -480);

    while(sum < degrees) {
       oi_update(sensor);
       sum += sensor -> angle;
    }

    oi_setWheels(0,0); //stop
    oi_free(sensor);
}

void move_forward_collision(oi_t *sensor, int millimeters) {

    int sum = 0;

     //move forward full speed

    while(sum < millimeters) {
        oi_setWheels(190,200);
        oi_update(sensor);
        if(sensor -> bumpRight == 1) {
            oi_setWheels(0,0);
            move_backward(sensor, -150);
            oi_init(sensor);

            oi_setWheels(0,0);
            turn_left(sensor, 70);
            oi_init(sensor);

            oi_setWheels(0,0);
            move_forward(sensor, 250);
            oi_init(sensor);

            oi_setWheels(0,0);
            turn_right(sensor, -70);
            oi_init(sensor);

            oi_setWheels(0,0);
            sum -= 150;
        }
        else if(sensor -> bumpLeft == 1)    {
            oi_setWheels(0,0);
            move_backward(sensor, -150);
            oi_init(sensor);

            oi_setWheels(0,0);
            turn_right(sensor, -70);
            oi_init(sensor);

            oi_setWheels(0,0);
            move_forward(sensor, 250);
            oi_init(sensor);

            oi_setWheels(0,0);
            turn_left(sensor, 70);
            oi_init(sensor);

            oi_setWheels(0,0);
            sum -= 150;
        }

        sum += sensor -> distance;
    }

    oi_setWheels(0,0); //stop
    oi_free(sensor);
}

int move_forward_cliff(oi_t *sensor, int millimeters) {

    int sum = 0;
    int cliff = 0;

     //move forward full speed

    while((sum < millimeters) && (cliff != 1)) {
        oi_setWheels(190,200);
        oi_update(sensor);
        if((sensor -> cliffRightSignal < 1500) || (sensor -> cliffRightSignal > 2700)) {
            oi_setWheels(0,0);
            move_backward(sensor, -150);
            oi_init(sensor);
            oi_setWheels(0,0);
            cliff = 1;
            turn_left(sensor, 45);
            return 3;
        }
        else if((sensor -> cliffLeftSignal < 1500) || (sensor -> cliffLeftSignal > 2700))    {
            oi_setWheels(0,0);
            move_backward(sensor, -150);
            oi_init(sensor);
            oi_setWheels(0,0);
            cliff = 1;
            turn_right(sensor, 45);
            return 0;
        }
        else if((sensor -> cliffFrontRightSignal < 1500) || (sensor -> cliffFrontRightSignal > 2700)) {
            oi_setWheels(0,0);
            move_backward(sensor, -150);
            oi_init(sensor);
            oi_setWheels(0,0);
            cliff = 1;
            turn_left(sensor, 45);
            return 2;
        }
        else if((sensor -> cliffFrontLeftSignal < 1500) || (sensor -> cliffFrontLeftSignal > 2700))    {
            oi_setWheels(0,0);
            move_backward(sensor, -150);
            oi_init(sensor);
            oi_setWheels(0,0);
            cliff = 1;
            turn_right(sensor, 45);
            return 1;
        }
        else if(sensor -> bumpRight == 1) {
            oi_setWheels(0,0);
            move_backward(sensor, 100);
            oi_init(sensor);
            return 5;
        }
        else if(sensor -> bumpLeft == 1)    {
            oi_setWheels(0,0);
            move_backward(sensor, 100);
            oi_init(sensor);
            return 6;
        }

        sum += sensor -> distance;
    }

    oi_setWheels(0,0); //stop
    oi_free(sensor);
    return 4;
}

void move_backward(oi_t *sensor, int millimeters)   {
    int sum = millimeters;

    oi_setWheels(-210, -200);

    while(sum > 0) {
        oi_update(sensor);
        sum += sensor -> distance;
    }

    oi_setWheels(0,0); //stop
    oi_free(sensor);
}
