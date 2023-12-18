using HorizonSideRobots
# include("functions.jl")
r = Robot("untitled.sit", animate = true)

function along!(r,side)
    if !isborder(r,side)
        move!(r, side)
        along!(r,side)
    end    
end

along!(r, West)