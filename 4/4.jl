using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function oblique_cross!(r)
    sides1 = [Nord, Sud]
    sides2 = [West, Ost]
    for direct1 in sides1  
        for direct2 in sides2
            road = []
            while !isborder(r, direct1) && !isborder(r, direct2)
                move!(r, direct1)
                move!(r, direct2)
                push!(road, (1, direct1))
                push!(road, (1, direct2))
                putmarker!(r)
            end
        print(length(road))
        back!(r, road)
        end
    end
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


oblique_cross!(r)