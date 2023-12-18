using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit",animate=true)

function mark_all!(r)
    putmarker!(r)
    side1=Ost
    while !isborder(r,Nord)
        numsteps_mark_along!(r, side1)
        side1 = inverse(side1)
        move!(r, Nord)
        putmarker!(r)
    end
    numsteps_mark_along!(r, side1)
end

function road2angle!(r,direct1,direct2)
    steps=[]
    while !isborder(r,direct1) || !isborder(r,direct2)
        pushfirst!(steps,(num_steps_along!(r,direct1),direct1))
        pushfirst!(steps,(num_steps_along!(r,direct2),direct2))
    end
    return steps
end

function num_steps_along!(robot, direct)
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function numsteps_mark_along!(robot, direct)
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
    num_steps += 1
    end
    return num_steps
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

function along!(robot, direct)
    while !isborder(robot, direct)
        move!(robot, direct)
    end
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

road=road2angle!(r,Sud,West)
mark_all!(r)
along!(r,Sud)
along!(r,West)
back!(r,road)