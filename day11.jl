function get_total(multiplier)
    vals::Array{Tuple{Int64, Int64}} = []
    max_x = 0
    max_y = 0
    open("inputs/day11.txt") do f
        for (idx, l) in enumerate(eachline(f))
            lm = map(x->x.offset, collect(eachmatch(r"#", l)))
            for m in lm
                push!(vals, (idx, m))
                max_x = max(idx, max_x)
                max_y = max(m, max_y)
            end
        end
    end

    gaps_x::Array{Int64} = []
    gaps_y::Array{Int64} = []
    for x = 1:max_x
        if x ∉ map(x->x[1], vals)
            push!(gaps_x, x)
        end
    end
    for y = 1:max_y
        if y ∉ map(x->x[2], vals)
            push!(gaps_y, y)
        end
    end
    println(gaps_x)
    println(gaps_y)
    vals2::Array{Tuple{Int64, Int64}} = []

    for val in vals
        num_expand_x = sum(gaps_x .< val[1])
        num_expand_y = sum(gaps_y .< val[2])
        val1 = val[1] + multiplier * num_expand_x
        val2 = val[2] + multiplier * num_expand_y
        push!(vals2, (val1, val2))
    end
    
    total = 0
    for ix = 1:length(vals2)
        for jy = ix+1:length(vals2)
            total += abs(vals2[ix][1] - vals2[jy][1]) + abs(vals2[ix][2] - vals2[jy][2])
        end
    end

    return total
end

function part1()
    total = get_total(1)
    println(total)
end

function part2()
    mult = 1000000
    total = get_total(mult-1)
    println(total)
end

part1()
part2()