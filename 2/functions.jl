

"""
along!(robot, direct)::Nothing
-- перемещает робота до упора в заданном направлении
"""

function along!(robot, direct)::Nothing
    while !isborder(robot, direct)
        move!(robot, direct)
    end
end

"""
num_steps_along!(robot, direct)::Int
-- перемещает робота в заданном направлении до упора и 
возвращает число фактически сделанных им шагов
"""
function num_steps_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        num_steps += 1
    end
    return num_steps
end


"""
along!(robot, direct, num_steps)::Nothing
-- перемещает робота в заданном направлении на заданное 
число шагов (предполагается, что это возможно)
"""
function along!(robot, direct, num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot, direct)
    end
end


"""
try_move!(robot, direct)::Bool
-- делает попытку одного шага в заданном направлении и 
27
возвращает true, в случае, если это возможно, и false - в 
противном случае (робот остается в исходном положении) 
"""
function try_move!(robot, direct)::Bool
    if isborder(robot, direct)
        return false
    end
    move!(robot, direct)
    return true
end

"""
numsteps_along!(robot, direct, max_num_steps)::Int
-- перемещает робота в заданном направлении до упора, если 
необходимое для этого число шагов не превосходит 
max_num_steps, или на max_num_steps шагов, и возвращает 
число фактически сделанных им шагов
"""
function numsteps_along!(robot, direct, max_num_steps)::Int
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        #- здесь принципиально, что операция && является “ленивой”
        num_steps +=1
    end
    return num_steps
end

"""
inverse(side::HorizonSide)::HorizonSide
-- возвращает направление, противоположное заданному 
"""
function inverse(side::HorizonSide)::HorizonSide
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

"""
right(side::HorizonSide)::HorizonSide
32
-- возвращает направление, следующее по часовой стрелке по 
отношению к заданному
"""
right(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1, 4))

"""
left(side::HorizonSide)::HorizonSide
-- возвращает направление, следующее против часовой стрелки 
по отношению к заданному
"""
left(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)-1, 4))

"""
nummarkers!(robot)
-- возвращает число клеток поля, в которых стоят маркеры 
В начале и в конце робот находится в юго-западном углу поля
"""
function num_markers!(robot)
    side = Ost # - начальное направление при перемещениях змейкой"
    num_markers = num_markers!(robot, side)
    while !isborder(robot,Nord)
        move!(robot,Nord)
        side = inverse(side)
        num_markers += num_markers!(robot, side)
    end
    #УТВ: робот - где-то у северной границы поля
    along!(robot, Sud) # возвращаемое функцией значение в данном случае игнорируется
    along!(robot, West)
    return num_markers
end

"""
num_markers!(robot,side)
-- перемещает робота до упора в заданном направлении и 
ВОЗВРАЩАЕТ число встретившихся на пути маркеров
"""
function num_markers!(robot, side)
    num_markers = ismarker(robot) # - фактически, это то же самое, что и num_markers = Int(ismarker(r))
    while !isborder(robot, side)
        move!(robot, side)
        if ismarker(robot)
        num_markers += 1
        end
    end
    return num_markers
end

"""
num_markers!(robot,side, num_markers)
-- перемещает робота до упора в заданном направлении, после 
каждого шага увеличивает число num_markers, если в очередной 
клетке имеется маркер, и возвращает обновленное значение 
num_markers
"""
function nummarkers!(robot, side, num_markers)
    while !isborder(robot, side)
        move!(robot, side)
        if ismarker(robot)
            num_markers += 1
        end
    end
    return num_markers
end

function mark_kross!(robot)
    for side in (Nord, West, Sud, Ost)
        num_steps = numsteps_mark_along!(robot, side) # перемещаться в направлении side до упора, после каждого шага ставя маркер, и получить число сделанных шагов
        along!(robot, inverse(side), num_steps) # переместить робота в направлении, противоположном side, на полученное число шагов #Очередной луч замаркирован, и робот в исходном положении
    end
    putmarker!(robot) # в центре поставлен недостающий маркер
end

"""
numsteps_mark_along!(robot, direct)::Int
-- перемещает робота в заданном направлении до упора, после 
каждого шага ставя маркер, и возвращает число фактически 
сделанных им шагов
"""
function numsteps_mark_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
    num_steps += 1
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

function back!(r,road)
    for steps in road
        along!(r,inverse(steps[2]),steps[1])
    end
end

function mark_along!(r, direct)
    while !isborder(r, direct)
        putmarker!(r)
        move!(r, direct)
    end
end

function perimeter!(r) # робот - в юго-западном углу
    road2angle!(r, Sud, West)
    side = [Nord, Ost, Sud, West]
    for side1 in 1:4
        mark_along!(r, side[side1])
    end
end

function mark_all!(r) # робот - в юго-западном углу
    putmarker!(r)
    side1=Ost
    while !isborder(r,Nord)
        numsteps_mark_along!(r, side1)
        side1=inverse(side1)
        move!(r,Nord)
        putmarker!(r)
    end
    numsteps_mark_along!(r, side1)
end

"""
oblique_cross!(r)
-- робот делает косой крест из маркеров и возвращается в исходное положение
"""
function oblique_cross!(r)
    sides1 = [Nord,Sud]
    sides2 = [West,Ost]
    for direct1 in sides1  
        for direct2 in sides2
            road=[]
            while !isborder(r,direct1) && !isborder(r,direct2)
                move!(r,direct1)
                move!(r,direct2)
                push!(road,(1,direct1))
                push!(road,(1,direct2))
                putmarker!(r)
            end
        print(length(road))
        back!(r,road)
        end
    end
end

"""
perimeter_border!(r) 
-- проходит по периметру прямоугольной перегородки и ставит маркеры, 
   исходное положение - под нижней стенкой перегородки
"""
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

"""
findborder!(r, direct1, direct2)
-- проходит змейкой по полю из угла, 
   direct1 - Nord, Sud
   direct2 - West, Ost
"""

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

"""
opposite!(r, road)
-- робот в юго-западном углу, проходит по периметру поля и ставит маркеры напротив исходной позиции робота и возвращается в юго-западный угол
"""

function opposite!(r,road)
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
"""
findspace!(r, direct1, direct2)
-- робот над/под бесконечной перегородкой [направление - direct2] двигается челноком и останавливается в клетке под пробелом 
"""
function findspace!(r, direct1, direct2)
    k = 1
    while isborder(r,direct2)
        numsteps_along!(r, direct1, k)
        direct1 = inverse(direct1)
        k += 1
    end
end

function find_marker!(robot)
    max_num_steps = 1
    side = Nord
    while !ismarker(robot)
        find_marker_along!(robot, side, max_num_steps)
        side = left(side)
        find_marker_along!(robot, side, max_num_steps)
        max_num_steps += 1
        side = left(side)
    end
end

function find_marker_along!(robot, side, max_num_steps)
    num_steps = 0
    while num_steps < max_num_steps && !ismarker(robot)
        move!(robot, side)
        num_steps += 1
    end
end

function num_steps!(r,road)
    num_steps = 0 
    for x in road
        num_steps += x[1]
    end
    return num_steps
end

function move_to_angle!(r)
    steps=[]
    while !isborder(r,Sud) || !isborder(r,West)
        pushfirst!(steps,(num_steps_along!(r,Sud),Sud))
        pushfirst!(steps,(num_steps_along!(r,West),West))
    end
    return steps
end

function mark_line_through1!(r, direct) - #робот идет по линии и ставит через каждую клетку маркер
    putmarker!(r)
    while !isborder(r, direct)
        try_move!(r,direct)
        if try_move!(r,direct)
            putmarker!(r)
        end
    end
end

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

function spiral!(r)
    direct = Nord
    num_steps = 1
    while true
        numsteps_along!(r, direct, num_steps)
        putmarker!(r)
        direct = left(direct)
        numsteps_along!(r, direct, num_steps)
        putmarker!(r)
        direct = left(direct)
        num_steps += 1
    end
end

function mark_numsteps_along!(robot, direct, max_num_steps)
    num_steps = 0
    while num_steps<max_num_steps && try_move!(robot,direct) 
        putmarker!(r)
        #- здесь принципиально, что операция && является “ленивой”
        num_steps +=1
    end
    return num_steps
end

function inverse_spiral!(r,n,direct1)
    direct = Nord
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

function angle!(r)
    if isborder(r,Sud) || isborder(r,West)
        return true
    elseif isborder(r,Sud) || isborder(r,Ost)
        return true
    elseif isborder(r,Nord) || isborder(r,Ost)
        return true
    elseif isborder(r,Nord) || isborder(r,West)
        return true
    end
    return false
end

function shuttle!(stop_condition, r, direct1)
    k = 1
    while stop_condition(r, Nord)
        numsteps_along!(r, direct1, k)
        direct1 = inverse(direct1)
        k += 1
    end
end

function snake!(robot, (move_side, next_row_side)::NTuple{2,HorizonSide} = (Ost,Nord))
    while !isborder(r, next_row_side) || !isborder(r, move_side)
        numsteps_along!(r,move_side, num_steps % 2)
        mark_line_through1!(r, move_side)
        if try_move!(r, next_row_side)
            move_side = inverse(move_side)
        end
    end     
end

function spiral!(stop_condition::Function, robot)
    max_num_steps = 1
    side = Nord
    while !stop_condition(robot)
        num_steps = 0
        while num_steps < max_num_steps && !stop_condition(robot)
            move!(robot, side)
            num_steps += 1
        end
        side = left(side)
        num_steps = 0
        while num_steps < max_num_steps && !stop_condition(robot)
            move!(robot, side)
            num_steps += 1
        end
        max_num_steps += 1
        side = left(side)
    end
end

function along20!(r,side,num_steps::Int = 0)
    if !isborder(r,side)
        move!(r, side)
        num_steps += 1
        along20!(r,side,num_steps)
    end

    if isborder(r, side)
        putmarker!(r)
        for _ in 1:num_steps
            move!(r,inverse(side))
        end
    end
end

function along19!(r,side)
    if !isborder(r,side)
        move!(r, side)
        along19!(r,side)
    end    
end