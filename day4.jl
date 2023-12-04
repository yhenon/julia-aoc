function myparse(s::String)

    (_, s2) = split(s, ':')
    number_matches = collect(eachmatch(r"\d+", s2))
    matches = map(x->parse(Int32, x.match), number_matches)
    return (matches[1:10], matches[11:end])

end

function part1()
    total = 0

    open("inputs/day4.txt") do f
        for (idx, l) in enumerate(eachline(f))
            winning, have = myparse(l)
            intersection = findall(x->x in winning, have)
            points = 0
            if length(intersection) > 0
                points = 2^(length(intersection) - 1)
            end
            total += points
        end
    end
    println(total)
end

function part2()
    arr = ones(Int32, 219)

    open("inputs/day4.txt") do f
        for (idx, l) in enumerate(eachline(f))
            winning, have = myparse(l)
            num_wins = length(findall(x->x in winning, have))
            arr[idx+1:idx+num_wins] .+= arr[idx]
        end
    end
    println(sum(arr))
end

part1()
part2()