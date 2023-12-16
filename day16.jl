using DataStructures

function d(row::Int, col::Int, a::Char)

    if a == 'W'
        return (row, col-1, a)
    elseif a == 'E'
        return (row, col+1, a)
    elseif a == 'N'
        return (row-1, col, a)
    else
        return (row+1, col, a)
    end
end

function get_score(q)

    grid = []
    open("inputs/day16.txt") do f
        for l in eachline(f)
            push!(grid, l)
        end
    end
    rows = length(grid)
    cols = length(grid[1])
    seen = Set{Tuple{Int32, Int32, Char}}()
    arr = zeros(Int32, rows, cols)

    while length(q) > 0

        (row, col, dir) = popfirst!(q)

        if row < 1 || col < 1 || row > rows|| col > cols
            continue
        end

        if (row, col, dir) ∈ seen
            continue
        end

        push!(seen, (row, col, dir))
        arr[row, col] = 1
        symbol = grid[row][col]
        
        if symbol == '.'
            if dir == 'N'
                push!(q, d(row, col, 'N'))
            elseif  dir == 'S'
                push!(q, d(row, col, 'S'))
            elseif  dir == 'W'
                push!(q, d(row, col, 'W'))
            elseif  dir == 'E'
                push!(q, d(row, col, 'E'))
            end
        end
        if symbol == '/'
            if dir == 'N'
                push!(q, d(row, col, 'E'))
            elseif  dir == 'S'
                push!(q, d(row, col, 'W'))
            elseif  dir == 'W'
                push!(q, d(row, col, 'S'))
            elseif  dir == 'E'
                push!(q, d(row, col, 'N'))
            end
        end
        if symbol == '\\'
            if dir == 'N'
                push!(q, d(row, col, 'W'))
            elseif  dir == 'S'
                push!(q, d(row, col, 'E'))
            elseif  dir == 'W'
                push!(q, d(row, col, 'N'))
            elseif  dir == 'E'
                push!(q, d(row, col, 'S'))
            end
        end
        if symbol == '-'
            if dir == 'N'
                push!(q, d(row, col, 'W'))
                push!(q, d(row, col, 'E'))
            elseif  dir == 'S'
                push!(q, d(row, col, 'W'))
                push!(q, d(row, col, 'E'))
            elseif  dir == 'W'
                push!(q, d(row, col, 'W'))
            elseif  dir == 'E'
                push!(q, d(row, col, 'E'))
            end
        end
        if symbol == '|'
            if dir == 'N'
                push!(q, d(row, col, 'N'))
            elseif  dir == 'S'
                push!(q, d(row, col, 'S'))
            elseif  dir == 'W'
                push!(q, d(row, col, 'S'))
                push!(q, d(row, col, 'N'))
            elseif  dir == 'E'
                push!(q, d(row, col, 'N'))
                push!(q, d(row, col, 'S'))
            end
        end    
    end
    return sum(arr)
end

function part1()
    q = []
    push!(q, (1, 1, 'E'))
    get_score(q)
end

function part2()
    grid = []
    open("inputs/day16.txt") do f
        for l in eachline(f)
            push!(grid, l)
        end
    end
    rows = length(grid)
    cols = length(grid[1])
    max_score = 0
    for row in 1:rows
        q = []
        push!(q, (1, row, 'S'))
        score = get_score(q)
        max_score = max(score, max_score)

        q = []
        push!(q, (cols, row, 'N'))
        score = get_score(q)
        max_score = max(score, max_score)
    end
    for col in 1:cols
        q = []
        push!(q, (col, 1, 'E'))
        score = get_score(q)
        max_score = max(score, max_score)

        q = []
        push!(q, (col, rows, 'W'))
        score = get_score(q)
        max_score = max(score, max_score)
    end
    println(max_score)
end

#part1()
part2()
