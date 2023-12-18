using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function inverse_spiral!(r,n)
    direct = Nord
    putmarker!(r)
    num_steps = n - 1
    for x in 1:3
        mark_numsteps_along!(r, direct, num_steps)
        direct = left(direct)
    end
    num_steps -= 1
    while num_steps >= 0 
        for k in 1:2
            mark_numsteps_along!(r, direct, num_steps)
            direct = left(direct)
            mark_numsteps_along!(r, direct, num_steps)
            direct = left(direct)
            num_steps -= 1
        end
    end
end

function move_to_angle_chess!(r,n)
    if n%2 == 0
        numsteps_along!(r, West, n//2)
        n = n - n//2 - 1
        numsteps_along!(r, Sud, n)
    end
    if n%2 == 1
        numsteps_along!(r, West, n//2 - 1)
        n = n // 2 - 1
        numsteps_along!(r, Sud, n)
    end
end
function chess_nxn_line!(r, n, f, field)
    x_field = field[1] - f 
    k = (x_field ÷ (n*2))
    num_steps = 0
    for x in 1:k
        direct = Ost
        inverse_spiral!(r, n)
        move_to_angle_chess!(r, n)
        num_steps += numsteps_along!(r, direct, n*2)
    end
    if num_steps != x_field
        if (x_field - num_steps) >= n
            inverse_spiral!(r, n)
            move_to_angle_chess!(r, n)
        end
    end
end
function field!(r)
    return [num_steps_along!(r, Ost) + 1, num_steps_along!(r,Nord) + 1]
end

function chess!(r, n, field)
    k = (field[2] ÷ n) ÷ 2
    for y in 1:k
        a = 0
        chess_nxn_line!(r, n, a, field)
        along!(r, West)
        numsteps_along!(r, Nord, n)
        numsteps_along!(r, Ost, n)
        a += n
        chess_nxn_line!(r, n, a, field)
        along!(r, West)
        numsteps_along!(r, Nord, n)
    end
    if n <= (field[2]-n*k*2)
        chess_nxn_line!(r, n, 0, field)
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

function mark_numsteps_along!(robot, direct, max_num_steps)
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        putmarker!(r)
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

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

function numsteps_along!(robot, direct, max_num_steps)::Int
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        num_steps +=1
    end
    return num_steps
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


road = move_to_angle!(r)
field = field!(r)
print(field)
move_to_angle!(r)
chess!(r, 4, field)
move_to_angle!(r)
back!(r, road)



