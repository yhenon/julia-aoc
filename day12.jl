using Combinatorics
using Memoize
using LRUCache

function get_count(arr::Array{Int64})
    in_group = false
    groups::Array{Int64} = []
    count = 0
    for a in arr
        if a == 1
            if !in_group
                count = 1
                in_group = true
            else
                count += 1
            end
        else
            if in_group
                push!(groups, count)
                count = 0
                in_group = false
            end
        end
    end
    if count > 0
        push!(groups, count)
    end
    return groups
end

function gen(unknowns::Array{Int64}, walls::Array{Int64}, groups::Array{Int64}, arr_size::Int64)
    N = length(unknowns)
    M = sum(groups) - length(walls)
    #println(N, ' ', M)

    array = vcat(zeros(Int, N-M), ones(Int, M))
    combinations = multiset_permutations(array, length(array))
    
    num_matches = 0

    a = zeros(Int64, arr_size)
    for ix in walls
        a[ix] = 1
    end
    for c in combinations

        for (idx, v) in enumerate(c)
            a[unknowns[idx]] = v
        end
        count = get_count(a)
        num_matches += (groups==count)
    end

    return num_matches
end

function part1()

    total = 0
    open("inputs/day12.txt") do f
        for l in eachline(f)
            mymap, groups = split(l, ' ')
            groups = map(x->parse(Int64, x), collect(split(groups, ',')))
            walls = map(x->x.offset, collect(eachmatch(r"\#", mymap)))
            unknowns = map(x->x.offset, collect(eachmatch(r"\?", mymap)))
            arr_size = length(mymap)
            total += gen(unknowns, walls, groups, arr_size)
        end
        println(total)
    end
end

@memoize LRU{Tuple{String,Array{Int64},Int64},Int64}(maxsize=100000) function gen_dp(mymap::String, groups::Array{Int64}, c::Int64)
    if length(mymap) == 0
        return (length(groups) == 0) && (c == 0)
    end
    total::Int64 = 0

    # we are in a wall group
    if mymap[1] != '.'
        total += gen_dp(mymap[2:end], groups, c+Int64(1))
    end

    # we are in a non-wall group
    if mymap[1] != '#'

        # case if there are still groups
        if length(groups) > 0
            # we got the right count for the current group
            if groups[1] == c
                total += gen_dp(mymap[2:end], groups[2:end], Int64(0))
            end
        end
        # we were not in a group, and still are not
        if c == 0
            total += gen_dp(mymap[2:end], groups, Int64(0))
        end
    end
    return total
end

function part2()

    total = 0
    N = 5
    open("inputs/day12.txt") do f
        for l in eachline(f)
            smallmap, groups = split(l, ' ')
            mymap = ""
            for i in 1:N
                mymap *= smallmap
                if i != N
                    mymap *= "?"
                end
            end
            mymap *= "."
            groups = map(x->parse(Int64, x), collect(split(groups, ',')))
            groups = repeat(groups, N)
            total += gen_dp(mymap, groups, Int64(0))
        end
    end
    println(total)
end


part1()
part2()
