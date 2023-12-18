using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function num_borders!(r, direct1, direct2) 
    num_borders = 0
    borders = 0
    while !isborder(r, direct1)
        while !isborder(r, direct2)
            numsteps_along!(r, direct2, 1)
            if isborder(r, direct1)
                borders += 1
            end
            if !isborder(r, direct1)
                if borders != 0
                    num_borders += 1
                    borders = 0
                end
            end
        end
        if !isborder(r,direct1)
            move!(r, direct1)
        end
        direct2 = inverse(direct2)
    end
    return num_borders
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
    else
        return Ost
    end
end

function try_move!(robot, direct)
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

function move_to_angle!(r)
    steps=[]
    while !isborder(r,Sud) || !isborder(r,West)
        pushfirst!(steps,(num_steps_along!(r,Sud),Sud))
        pushfirst!(steps,(num_steps_along!(r,West),West))
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
print(num_borders!(r, Nord, Ost))
move_to_angle!(r)
back!(r, road)
