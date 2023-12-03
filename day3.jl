function part1()

    lookup = zeros(Int32, 200, 200)
    open("inputs/day3.txt") do f
        for (row, l) in enumerate(eachline(f))
            for (col, character) in enumerate(l)
                if !isdigit(character) && character != '.'
                    lookup[row, col] = 1
                end
            end
        end
    end

    open("inputs/day3.txt") do f
        vals = []
        for (row, l) in enumerate(eachline(f))
            number_matches = collect(eachmatch(r"\d+", l))
            for match in number_matches
                col = match.offset
                num_digits = length(match.match)
                x = max(1, row-1):row+1
                y = max(1, col-1):col+num_digits
                if sum(lookup[x, y]) != 0
                    push!(vals, parse(Int32,match.match))
                end
            end
        end
        println(sum(vals))
    end
end

function part2()

    lookup = ones(Int32, 200, 200)

    open("inputs/day3.txt") do f
        vals = []
        for (row, l) in enumerate(eachline(f))
            number_matches = collect(eachmatch(r"\d+", l))
            for match in number_matches
                col = match.offset
                num_digits = length(match.match)
                x = row
                y = col:col+num_digits - 1
                lookup[x,y] .= parse(Int32,match.match)
            end
        end
    end

    gear_ratio = 0
    open("inputs/day3.txt") do f
        for (row, l) in enumerate(eachline(f))
            for (col, character) in enumerate(l)
                if character == '*'
                    x = max(1, row-1):row+1
                    y = max(1, col-1):col+1
                    if length(unique(lookup[x, y])) == 3
                        gear_ratio += prod(unique(lookup[x, y]))
                    end
                end
            end
        end
    end
    println(gear_ratio)

end

part1()
part2()