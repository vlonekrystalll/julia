using HorizonSideRobots
# include("functions.jl")
r=Robot("untitled.sit",animate=true)

function numsteps_mark_along!(robot, direct)
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
    num_steps += 1
    end
    return num_steps
end

function along!(robot, direct, num_steps)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

function mark_kross!(robot)
    for side in (Nord, West, Sud, Ost)
        num_steps = numsteps_mark_along!(robot, side) 
        along!(robot, inverse(side), num_steps)
    end
    putmarker!(robot)
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

mark_kross!(r)