using DataStructures
using Polynomials
function part1()
    arr = []
    srow = 0
    scol =0
    open("inputs/day21.txt") do f
        for (col, l) in enumerate(eachline(f))
            push!(arr, l)
            if 'S' ∈ l
                row = match(r"S", l).offset
                scol = col
                srow = row
                l = replace(l, 'S'=>'.')
            end
        end
    end
    q1 = Queue{Tuple}()
    q2 = Queue{Tuple}()
    seen = Set{Tuple}()
    enqueue!(q2, (srow, scol, 0))

    for i in 1:65
        if i % 2 == 0
            q_old = q1
            q_new = q2
        else
            q_old = q2
            q_new = q1
        end
        if i - 1 == 64
            println(i-1, ',', length(q_old))
        end
        while !isempty(q_old)
            (row, col, nym_steps) = dequeue!(q_old)
            for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
                new_row = row + dx
                new_col = col + dy
                if new_row < 1 || new_col < 1 || new_row > length(arr) || new_col > length(arr[1])
                    continue
                end
                if (new_row, new_col, nym_steps+1) ∈ seen
                    continue
                end
                if arr[new_row][new_col] == '#'
                    continue
                end
                enqueue!(q_new, (new_row, new_col, nym_steps+1))
                push!(seen, (new_row, new_col, nym_steps+1))
            end
        end
    end
end


function part2()
    arr = []
    srow = 0
    scol =0
    open("inputs/day21.txt") do f
        for (col, l) in enumerate(eachline(f))
            push!(arr, l)
            if 'S' ∈ l
                row = match(r"S", l).offset
                scol = col
                srow = row
                l = replace(l, 'S'=>'.')
            end
        end
    end

    N = length(arr)
    q1 = Queue{Tuple{Int64,Int64,Int64}}()
    q2 = Queue{Tuple{Int64,Int64,Int64}}()
    seen = Set{Tuple{Int64,Int64,Int64}}()
    enqueue!(q1, (srow, scol, 0))
    vals::Array{Int64} = []
    i = 0
    while true
        if i % 2 == 0
            q_old = q1
            q_new = q2
        else
            q_old = q2
            q_new = q1
        end
        if (i - 65) % 131  == 0
            push!(vals, length(q_old))
        end
        if length(vals) == 3
            f=fit([0,1,2],vals)
            println(f(202300))
            exit()
        end
        i += 1

        while !isempty(q_old)
            (row, col, nym_steps) = dequeue!(q_old)
            for (dx, dy) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
                new_row = row + dx
                new_col = col + dy
                new_col2 = new_col
                new_row2 = new_row
                new_row2 -= N * fld(new_row2 - 1, N)
                new_col2 -= N * fld(new_col2 - 1, N)

                if (new_row, new_col, nym_steps+1) ∈ seen
                    continue
                end
                if arr[new_row2][new_col2] == '#'
                    continue
                end
                enqueue!(q_new, (new_row, new_col, nym_steps+1))
                push!(seen, (new_row, new_col, nym_steps+1))
            end
        end
    end
end

part1()
part2()