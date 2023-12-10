using DataStructures
using Plots

function get_path()
    neighbors = Dict(
        '|'=> [(-1, 0), (1, 0)], 
        '-'=>[(0, -1), (0, 1)],
        'L'=>[(-1, 0), (0, 1)],
        'J'=>[(-1, 0), (0, -1)],
        '7'=>[(1, 0), (0, -1)],
        'F'=>[(1, 0), (0, 1)])
    arr = []
    curr = Deque{Tuple{Int, Int, Int}}()
    already_seen = Dict()
    open("inputs/day10.txt") do f
        for (row, l) in enumerate(eachline(f))
            if 'S' ∈ l
                col = findfirst('S', l)
                push!(curr, (row, col, 0))
                l = replace(l, 'S'=>'L')
            end
            push!(arr, collect(l))
        end
    end
    arr = hcat(arr)
    # push!(curr, (3, 1, 0))
    while length(curr) != 0
        node = pop!(curr)
        already_seen[(node[1], node[2])] = node[3]
        symbol = arr[node[1]][node[2]]
        conns = neighbors[symbol]
        #println(node, "  ", symbol)
        for conn in conns
            #println(conn) # e.g. (0, 1)
            symbol_in_conn = arr[node[1] + conn[1]][node[2] + conn[2]]

            if symbol_in_conn == '.'
                continue
            end
            #println(already_seen[(node[1] + conn[1], node[2] + conn[2])], " .. ", )
            if ((node[1] + conn[1], node[2] + conn[2]) ∈ keys(already_seen)) && (already_seen[(node[1] + conn[1], node[2] + conn[2])] <= (node[3]))
                continue
            end

            for conn2 in neighbors[symbol_in_conn]
                if conn[1] + conn2[1] == 0 && conn[2] + conn2[2] == 0
                    push!(curr, (node[1] + conn[1], node[2] + conn[2], node[3] + 1))
                end
            end
        end
    end
    return (already_seen, arr)
end

function part1()
    (path, _) = get_path()
    println(maximum(values(path)))
end

function part2()
    (path, arr) = get_path()
    num_in = 0
    
    for x in 1:size(arr, 1)
        parity = false
        for y in 1:size(arr[1], 1)

            in_loop = (x, y) ∈ keys(path)
            if in_loop && arr[x][y] ∈ "|LJ"
                parity = !parity
            elseif !in_loop && parity == true
                num_in += 1
            end
        end
    end
    println(num_in)
end


part1()
part2()