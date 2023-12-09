function get_val(s::Array{Int64})
    all = []
    push!(all, s)
    while true
        diff = s[2:end] - s[1:end - 1]
        push!(all, diff)
        if count(==(0), diff) == length(diff)
            break
        else
            s = diff
        end
    end
    rightmost = 0
    for v in reverse(all)
        rightmost += v[end]
    end
    return rightmost
end

function get_val2(s::Array{Int64})
    all = []
    push!(all, s)
    while true
        diff = s[2:end] - s[1:end - 1]
        push!(all, diff)
        if count(==(0), diff) == length(diff)
            break
        else
            s = diff
        end
    end
    leftmost = 0
    for v in reverse(all)
        leftmost = v[1] - leftmost
    end
    return leftmost
end

function part1()
    total = 0
    open("inputs/day9.txt") do f
        for l in eachline(f)
            s2 = map(x->parse(Int64,x),split(l, ' '))
            total += get_val(s2)
        end
    end
    println(total)
end

function part2()
    total = 0
    open("inputs/day9.txt") do f
        for l in eachline(f)
            s2 = map(x->parse(Int64,x),split(l, ' '))
            total += get_val2(s2)
        end
    end
    println(total)
end

part1()
part2()