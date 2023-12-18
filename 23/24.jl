using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true) 

function neib!(robot, side)
    if !try_move!(robot, side)
        move!(robot, left(side))
        neib!(robot, side)
        move!(robot, right(side))
    end
end

function try_move!(robot, direct)
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

function along!(r, side)
    if !isborder(r, side)
        move!(r,side)
        along!(r, side)
    else
        neib!(r,side)
    end
    move!(r, side)
end
right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))

left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

along!(r, Ost)