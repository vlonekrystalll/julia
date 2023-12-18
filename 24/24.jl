using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function half_dist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        no_delayed_action!(robot, side)
        move!(robot, inverse(side))
    end
end

function no_delayed_action!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        half_dist!(robot, side)
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

half_dist!(r, Nord)