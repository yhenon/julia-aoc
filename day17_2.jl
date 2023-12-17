using DataStructures

function get_d(row, col, a::Char)

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

function get_score(pq)

    grid::Array{Array{Int32}} = []
    open("inputs/day17.txt") do f
        for l in eachline(f)
            push!(grid, map(x->parse(Int32, x), collect(l)))
        end
    end
    rows = length(grid)
    cols = length(grid[1])
    seen = Dict() # {Tuple{Int32, Int32, Int32, Char}}
    best_cost = 100000000
    while length(pq) > 0

        (row, col, num_steps, cost, dir) = dequeue!(pq)
        

        if row < 1 || col < 1 || row > rows|| col > cols
            continue
        end


        cell_cost = grid[row][col]
        total_cost = cost + cell_cost

        if row == rows && col == cols
            println("reached end with cost ", total_cost)
            continue
        end


        if (row, col, num_steps, dir) ∈ keys(seen) && seen[(row, col, num_steps, dir)] < (total_cost)
            continue
        end

        seen[(row, col, num_steps, dir)] = total_cost

        #println(row, ' ', col, ' ', num_steps, ' ', dir, ' ', total_cost)
        #sleep(0.1)
        for d in ['N', 'S', 'W', 'E']
            #println(d, ' ', dir, ' ', num_steps)
            if d != dir && num_steps < 4
                continue
            end
            if d == dir && num_steps == 10
                continue
            end            
            if (dir == 'N' && d == 'S') || (dir == 'S' && d == 'N') || (dir == 'W' && d == 'E') || (dir == 'E' && d == 'W')
                continue
            end
            if d != dir
                new_steps = Int32(1)
            else
                new_steps = num_steps + 1
            end
            (new_row, new_col, _) = get_d(row, col, d)
            #push!(q, (new_row, new_col, new_steps, total_cost, d))
            pq[(new_row, new_col, new_steps, total_cost, d)] = total_cost
        end
    end
    min_val = 10000000
    for k in keys(seen)
        if k[1] == rows && k[2] == cols
            min_val = min(min_val, seen[k])
        end
    end
    println(min_val)
end

function part1()
    #q::Array{Tuple{Int32, Int32, Int32, Int32, Char}} = []
    pq = PriorityQueue()
    pq[(Int32(1), Int32(1), Int32(0), Int32(-2), 'E')] = 0
    pq[(Int32(1), Int32(1), Int32(0), Int32(-2), 'S')] = 0

    println(pq)
    get_score(pq)
end

part1()
