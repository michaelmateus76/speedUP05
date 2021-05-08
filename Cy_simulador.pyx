#cython: language_level=3, boundscheck=False, wraparound=False, nonecheck=False
cimport cython

#!/usr/bin/env python3

cdef extern from "math.h":
    double sqrt(double x) nogil
    long double cos(double theta) nogil
    long double sin(double theta) nogil
    long double atan2(double dy, double dx) nogil

# The gravitational constant G
cdef float G = 6.67428e-11

# Assumed scale: 100 pixels = 1AU.
cdef float AU = (149.6e6 * 1000)  # 149.6 million km, in meters.
#cdef float SCALE = 250/AU

#class Body(Turtle):
cdef class Body():
    """Subclass of Turtle representing a gravitationally-acting body.

    Extra attributes:
    mass : mass in kg
    vx, vy: x, y velocities in m/s
    px, py: x, y positions in m
    """

    cdef public double vx, vy, px, py, mass, theta, fx, fy
    cdef public str name

    def __init__(self):

        self.name = 'Body'
        self.mass = 0.0
        self.vx =  0.0
        self.vy =  0.0
        self.px = 0.0
        self.py = 0.0
        self.theta = 0.0
        self.fx = 0.0
        self.fy = 0.0

    @cython.cdivision(True)
    cdef tuple attraction(Body self, Body other):
        """(Body): (fx, fy)

        Returns the force exerted upon this body by the other body.
        """
        # Report an error if the other object is the same as this one.
        if self is other:
            raise ValueError("Attraction of object %r to itself requested"
                             % self.name)

        # Compute the distance of the other body.
        sx, sy = self.px, self.py
        ox, oy = other.px, other.py
        dx = (ox - sx)
        dy = (oy - sy)
        d = sqrt(dx ** 2 + dy ** 2)

        # Report an error if the distance is zero; otherwise we'll
        # get a ZeroDivisionError exception further down.
        if d == 0:
            raise ValueError("Collision between objects %r and %r"
                             % (self.name, other.name))

        # Compute the force of attraction
        f = G * self.mass * other.mass / (d ** 2)

        # Compute the direction of the force.
        self.theta = atan2(dy, dx)
        self.fx = cos(self.theta) * f
        self.fy = sin(self.theta) * f
        
        return self.fx, self.fy

@cython.cdivision(True)
def loop(list bodies):
    """([Body])

    Never returns; loops through the simulation, updating the
    positions of all the provided bodies.
    """
    cdef int timestep = 24 * 3600  # One day
    '''
    for body in bodies:
        body.penup()
        body.hideturtle()
    '''
    cdef int step = 1
    '''365 days in order to complete earth's cycle'''

    cdef double total_fx, total_fy, fx, fy

    cdef dict force

    cdef Body body, other

    while (step <= 365 * 1000):
        #update_info(step, bodies)
        step += 1

        force = {}
        for body in bodies:
            # Add up all of the forces exerted on 'body'.
            total_fx = total_fy = 0.0
            for other in bodies:
                # Don't calculate the body's attraction to itself
                if body is other:
                    continue
                fx, fy = body.attraction(other)
                total_fx += fx
                total_fy += fy

            # Record the total force exerted.
            force[body] = (total_fx, total_fy)

        # Update velocities based upon on the force.
        for body in bodies:
            fx, fy = force[body]
            
            body.vx += fx / body.mass * timestep
            body.vy += fy / body.mass * timestep

            # Update positions
            body.px += body.vx * timestep
            body.py += body.vy * timestep
           # body.goto(body.px * SCALE, body.py * SCALE)
            #body.dot(3)