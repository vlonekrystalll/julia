using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function find_marker!(robot)
    max_num_steps = 1
    side = Nord
    while !ismarker(robot)
        find_marker_along!(robot, side, max_num_steps)
        side = left(side)
        find_marker_along!(robot, side, max_num_steps)
        max_num_steps += 1
        side = left(side)
    end
end

function find_marker_along!(robot, side, max_num_steps)
    num_steps = 0
    while num_steps < max_num_steps && !ismarker(robot)
        move!(robot, side)
        num_steps += 1
    end
end

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

find_marker!(r)