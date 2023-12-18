using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit",animate=true)

function perimeter!(r)
    road2angle!(r, Sud, West)
    side = [Nord, Ost, Sud, West]
    for side1 in 1:4
        mark_along!(r, side[side1])
    end
end

function road2angle!(r,direct1,direct2)
    steps=[]
    while !isborder(r,direct1) || !isborder(r,direct2)
        pushfirst!(steps,(num_steps_along!(r,direct1),direct1))
        pushfirst!(steps,(num_steps_along!(r,direct2),direct2))
    end
    return steps
end

function mark_along!(r, direct)
    while !isborder(r, direct)
        putmarker!(r)
        move!(r, direct)
    end
end

function num_steps_along!(robot, direct)
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function back!(r,road)
    for steps in road
        along!(r,inverse(steps[2]),steps[1])
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

steps = road2angle!(r, West, Sud)
perimeter!(r)
back!(r,steps)