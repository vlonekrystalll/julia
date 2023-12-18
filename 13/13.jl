using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

mutable struct ChessRobot
    robot::Robot
    x::Int
    y::Int
end

function HorizonSideRobots.isborder(robot::ChessRobot, side::HorizonSide)
    return isborder(robot.robot, side)
end

function HorizonSideRobots.move!(robot::ChessRobot, side::HorizonSide)
    if (robot.x + robot.y) % 2 == 0
        putmarker!(robot.robot)
    end
    move!(robot.robot, side)
    if side == Nord
        robot.y += 1
    elseif side == West
        robot.x -= 1
    elseif side == Sud
        robot.y -= 1
    elseif side == Ost
        robot.x += 1
    end
end

function along!(robot::ChessRobot, direct)::Nothing
    while !isborder(robot, direct)
        move!(robot, direct)
    end
end

function snake!(r, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Ost,Nord))
    while !isborder(r, move_side) || !isborder(r, next_row_side)
        along!(r, move_side)
        if !isborder(r, next_row_side)
            move!(r, next_row_side)
            move_side = inverse(move_side)
        end
    end
end

function move_to_angle!(r)
    steps=[]
    while !isborder(r,Sud) || !isborder(r,West)
        pushfirst!(steps,(num_steps_along!(r,Sud),Sud))
        pushfirst!(steps,(num_steps_along!(r,West),West))
    end
    return steps
end

function num_steps_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function num_steps!(r,road)
    num_steps = 0 
    for x in road
        num_steps += x[1]
    end
    return num_steps
end

function along!(robot, direct, num_steps)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

function back!(r,road)
    for steps in road
        along!(r,inverse(steps[2]),steps[1])
    end
end

function inverse(side)
    if side == Nord
        return Sud
    elseif side == Sud
        return Nord
    elseif side == Ost
        return West
    else
        return Ost
    end
end

chess_robot = ChessRobot(r, 0, 0)
road = move_to_angle!(r)
num_steps = num_steps!(r, road)
along!(r, Ost, num_steps % 2)
snake!(chess_robot)
move_to_angle!(r)
back!(r,road)