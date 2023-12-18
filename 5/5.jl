using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function findborder!(r, direct1, direct2)
    while !isborder(r, direct1)
        while !isborder(r, direct2)
            numsteps_along!(r, direct2, 1)
            if isborder(r, direct1)
                break
            end
        end
        if !isborder(r,direct1)
            move!(r, direct1)
        end
        direct2 = inverse(direct2)
    end
end

function perimeter_border!(r)
    direct2 = Nord
    move!(r, West)
    if isborder(r, Nord)
        direct1 = West
        move!(r,Ost)
    elseif !isborder(r, Nord)
        direct1 = Ost
        move!(r, Ost)
    end
    if direct1 == Ost
        for x in 1:4
            while isborder(r, direct2)
                putmarker!(r)
                move!(r, direct1)
            end
            putmarker!(r)
            move!(r,direct2)
            direct1 = right(direct1)
            direct2 = right(direct2)
        end
    end
    if direct1 == West
        for x in 1:4
            while isborder(r, direct2)
                putmarker!(r)
                move!(r, direct1)
            end
            putmarker!(r)
            move!(r,direct2)
            direct1 = left(direct1)
            direct2 = left(direct2)
        end
    end
end

function numsteps_along!(robot, direct, max_num_steps)::Int
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

function num_steps_along!(robot, direct)::Int
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

function along!(robot, direct, num_steps)
    for _ in 1:num_steps
        move!(robot, direct)
    end
end

function perimeter!(r) # робот - в юго-западном углу
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

function try_move!(robot, direct)::Bool
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))
right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))

road=road2angle!(r,Sud,West)
perimeter!(r)
findborder!(r, Nord, Ost)
perimeter_border!(r)
road2angle!(r, Sud, West)
back!(r, road)