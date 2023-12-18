using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function num_borders_line2(r, side)
    state = 0
    num_borders = 0
    while try_move!(r, side)
        if state == 0
            if isborder(r, Nord)
                state = 1
            end
        elseif state == 1
            if !isborder(r,Nord)
                state = 2
            end
        else 
            if !isborder(r, Nord)
                state = 0 
                num_borders += 1
            end
        end
    end
    return num_borders 
    
end

function num_borders2!(r, side) 
    num_borders = 0
    while !isborder(r, Nord) || !isborder(r, Ost)
        num_borders += num_borders_line2(r, side)
        side = inverse(side)
        if !isborder(r, Nord)
            move!(r,Nord)
        end
    end
    return num_borders
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
print(num_borders2!(r,Ost))
move_to_angle!(r)
back!(r, road)