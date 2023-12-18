using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

# function along!(r,side,num_steps::Int = 0)
#     if !isborder(r,side)
#         move!(r, side)
#         num_steps += 1
#         along!(r,side,num_steps)
#     end

#     if isborder(r, side)
#         putmarker!(r)
#         for _ in 1:num_steps
#             move!(r,inverse(side))
#         end
#     end
# end



function along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        along!(robot, side)
        move!(robot, inverse(side))
    else
        putmarker!(robot)
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

along!(r, West)