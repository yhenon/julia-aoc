function part1()
    total = 0
    open("inputs/day1.txt") do f
        for l in eachline(f)
            s = filter(isdigit, l)
            s2 = map(x->parse(Int32,x),collect(s))
            total += Int(s2[1]) * 10 + Int(s2[end])
        end
    end
    println(total)
end

function myparse(s::String)

    nums = [r"one", r"two", r"three", r"four", r"five", r"six", r"seven", r"eight", r"nine"]
    nums2 = [r"1", r"2", r"3", r"4", r"5", r"6", r"7", r"8", r"9"]

    occ = Dict()
    for outerstr in [nums, nums2]
        for (index, value) in enumerate(outerstr)
            matches = collect(eachmatch(value, s))
            offsets = map(x->x.offset, matches)

            for offset in offsets
                occ[offset] = index
            end
        end
    end
    k = sort(collect(keys(occ)))

    return 10 * occ[k[1]] + occ[k[end]]
end

function part2()
    total = 0
    open("inputs/day1.txt") do f
        for l in eachline(f)
            total += myparse(l)
        end
    end
    println(total)
end

part1()
part2()