using HorizonSideRobots
include("functions.jl")
r = Robot("untitled.sit", animate = true)

function opposite!(r, road)
    direct = road[1][2]
    first_direct = 1
    second_direct = 1
    for x in 1:2
        while first_direct <= length(road)
            numsteps_along!(r, inverse(direct), road[first_direct][1])
            first_direct += 2
        end
        putmarker!(r)
        along!(r,inverse(direct))
        direct = right(inverse(direct))
        first_direct = 2
    end
    direct = road[1][2]
    along!(r,direct)
    while second_direct <= length(road)
        numsteps_along!(r, inverse(direct), road[second_direct][1])
        second_direct += 2
    end
    putmarker!(r)
    along!(r,direct)
    direct = right(inverse(direct))
    along!(r,direct)  
    second_direct = 2
    while second_direct <= length(road)
        numsteps_along!(r, inverse(direct), road[second_direct][1])
        second_direct += 2
    end
    putmarker!(r)
    along!(r,direct)
end

function numsteps_along!(robot, direct, max_num_steps)
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        num_steps +=1
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
    else # side == West
        return Ost
    end
end


function along!(robot, direct)
    while !isborder(robot, direct)
        move!(robot, direct)
    end
end

function try_move!(robot, direct)
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

function back!(r,road)
    for steps in road
        along!(r,inverse(steps[2]),steps[1])
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

function num_steps_along!(robot, direct)
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end

function perimeter!(r)
    road2angle!(r, Sud, West)
    side = [Nord, Ost, Sud, West]
    for side1 in 1:4
        mark_along!(r, side[side1])
    end
end

function mark_along!(r, direct)
    while !isborder(r, direct)
        putmarker!(r)
        move!(r, direct)
    end
end


road = road2angle!(r, West, Sud)
# perimeter!(r)
opposite!(r, road)
back!(r, road)