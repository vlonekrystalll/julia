using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function findspace!(r, direct1, direct2)
    k = 1
    while isborder(r,direct2)
        numsteps_along!(r, direct1, k)
        direct1 = inverse(direct1)
        k += 1
    end
end

function numsteps_along!(robot, direct, max_num_steps)
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        num_steps +=1
    end
    return num_steps
end

function try_move!(robot, direct)
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
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

findspace!(r, Ost, Nord)