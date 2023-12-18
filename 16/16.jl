using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function shuttle!(stop_condition, r, direct1)
    k = 1
    while stop_condition(r, Nord)
        along!(r, direct1, k)
        direct1 = inverse(direct1)
        k += 1
    end
end

function along!(robot, direct, num_steps)
    for _ in 1:num_steps
        move!(robot, direct)
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

shuttle!(isborder, r, Ost)