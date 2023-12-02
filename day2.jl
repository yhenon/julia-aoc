function myparse(s::String)

    (_, s2) = split(s, ':')
    draws = split(s2, ';')
    a::Array{Tuple} = []
    for draw in draws
        elements = split(draw, ',')
        elements = map(x -> x[2:end], elements)

        num_red = 0
        num_green = 0
        num_blue = 0
        for element in elements
            num, color = split(element, ' ')
            num_balls = parse(Int32,num)
            if color == "red"
                num_red = num_balls
            elseif color == "blue"
                num_blue = num_balls
            elseif color == "green"
                num_green = num_balls
            end
        end
        push!(a, (num_red, num_green, num_blue))
    end
    return a
end

function part1()
    total = 0

    max_red = 12
    max_green = 13
    max_blue = 14

    open("inputs/day2.txt") do f
        for (idx, l) in enumerate(eachline(f))
            draws = myparse(l)
            failed = 0
            for (red, green, blue) in draws
                if red > max_red || green > max_green || blue > max_blue
                    failed = 1
                end
            end
            if failed == 0
                total += idx
            end
        end
    end
    println(total)
end



function part2()
    total = 0

    open("inputs/day2.txt") do f
        for (idx, l) in enumerate(eachline(f))
            draws = myparse(l)
            min_red = 0
            min_green = 0
            min_blue = 0

            for (red, green, blue) in draws
                min_red = max(red, min_red)
                min_green = max(green, min_green)
                min_blue = max(blue, min_blue)
            end
            powerset = min_green * min_red * min_blue
            println(powerset)
            total += powerset
        end
    end
    println(total)
end

part1()
part2()