using Memoize
using LRUCache

function tilt(array::Array{Int64,2}, direction::Char='N')
    (rows, cols) = size(array)

    if direction == 'N'
        for col in 1:cols
            for row in 1:rows
                if array[row, col] == 8
                    loc = row
                    while true
                        if loc == 1
                            break
                        end
                        if array[loc-1, col] == 0
                            array[loc, col] = 0
                            array[loc-1, col] = 8
                            loc -= 1
                        else
                            break
                        end
                    end     
                end
            end
        end
        return array
    end

    if direction == 'S'
        for col in 1:cols
            for row in rows:-1:1
                if array[row, col] == 8
                    loc = row
                    while true
                        if loc == rows
                            break
                        end
                        if array[loc+1, col] == 0
                            array[loc, col] = 0
                            array[loc+1, col] = 8
                            loc += 1
                        else
                            break
                        end
                    end     
                end
            end
        end
        return array
    end

    if direction == 'W'
        for row in 1:rows
            for col in 1:cols
                if array[row, col] == 8
                    loc = col
                    while true
                        if loc == 1
                            break
                        end
                        if array[row, loc-1] == 0
                            array[row, loc] = 0
                            array[row, loc-1] = 8
                            loc -= 1
                        else
                            break
                        end
                    end     
                end
            end
        end
        return array
    end

    if direction == 'E'
        for row in 1:rows
            for col in cols:-1:1
                if array[row, col] == 8
                    loc = col
                    while true
                        if loc == cols
                            break
                        end
                        if array[row, loc+1] == 0
                            array[row, loc] = 0
                            array[row, loc+1] = 8
                            loc += 1
                        else
                            break
                        end
                    end     
                end
            end
        end
        return array
    end
    return array
end

function part1()
    array = []

    open("inputs/day14.txt") do f
        array = []
        for l in eachline(f)
            l = replace(l, '.'=>'0')
            l = replace(l, '#'=>'1')
            l = replace(l, 'O'=>'8')
            l = map(x->parse(Int64,x), collect(l))
            push!(array, l)
        end
    end
    array = transpose(hcat(array...))
    array = convert(Matrix{Int64}, array)

    array = tilt(array, 'N')
    (rows, cols) = size(array)
    score = 0
    for col in 1:cols
        for row in 1:rows
            if array[row, col] == 8
                score += (rows + 1 - row)
            end
        end
    end
    println(score)

end

function part2()
    array = []

    open("inputs/day14.txt") do f
        array = []
        for l in eachline(f)
            l = replace(l, '.'=>'0')
            l = replace(l, '#'=>'1')
            l = replace(l, 'O'=>'8')
            l = map(x->parse(Int64,x), collect(l))
            push!(array, l)
        end
    end
    array = transpose(hcat(array...))
    array = convert(Matrix{Int64}, array)
    t = time_ns()
    mydict = Dict()
    n = 0
    target = 1000000000
    while true
        if n == target
            break
        end

        tilt(array, 'N')
        tilt(array, 'W')
        tilt(array, 'S')
        tilt(array, 'E')
        n += 1

        if array ∈ keys(mydict)
            period = n - mydict[array]
            while n < target
                n += period
            end
            if n > target
                n -= period
            end
        else
            mydict[array] = n
        end
    end

    (rows, cols) = size(array)
    score = 0
    for col in 1:cols
        for row in 1:rows
            if array[row, col] == 8
                score += (rows + 1 - row)
            end
        end
    end
    println(score)

end

part1()
part2()
