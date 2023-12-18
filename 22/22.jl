using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        along!(robot, side)
        if numsteps_along!(robot, inverse(side), 2) != 2
            return false
        end
    end
    return true
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

along!(r, Ost)
# print(along!(r, Ost))