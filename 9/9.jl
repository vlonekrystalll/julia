using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function chess!(r, num_steps)
    direct = Ost
    while !isborder(r, Nord) || !isborder(r, Ost)
        numsteps_along!(r,direct,num_steps % 2)
        mark_line_through1!(r, direct)
        if try_move!(r,Nord)
            direct = inverse(direct)
        end
    end
end

function mark_line_through1!(r, direct)
    putmarker!(r)
    while !isborder(r, direct)
        try_move!(r,direct)
        if try_move!(r,direct)
            putmarker!(r)
        end
    end
end

function try_move!(robot, direct)
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

function numsteps_along!(robot, direct, max_num_steps)
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        num_steps +=1
    end
    return num_steps
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

function num_steps!(r,road)
    num_steps = 0 
    for x in road
        num_steps += x[1]
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


function move_to_angle!(r)
    steps=[]
    while !isborder(r,Sud) || !isborder(r,West)
        pushfirst!(steps,(num_steps_along!(r,Sud),Sud))
        pushfirst!(steps,(num_steps_along!(r,West),West))
    end
    return steps
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

road = move_to_angle!(r)
num_steps = num_steps!(r, road)
chess!(r,num_steps)
move_to_angle!(r)
back!(r,road)