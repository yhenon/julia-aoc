function get(sections::Array{Array{Tuple{Int64, Int64, Int64}}}, curr::Int64)
    for section in sections
        for row in section
            if row[1] <= curr <= row[1] + row[3] - 1
                curr -= row[2]
                break
            end
        end
    end
    return curr
end

function part2()
    seeds = [4239267129 20461805 2775736218 52390530 3109225152 741325372 1633502651 46906638 967445712 47092469 2354891449 237152885 2169258488 111184803 2614747853 123738802 620098496 291114156 2072253071 28111202]
    sections::Array{Array{Tuple{Int64, Int64, Int64}}} = []
    subsection::Array{Tuple{Int64, Int64, Int64}} = []
    min_val = typemax(Int64)
    open("inputs/day5.txt") do f
        for (idx, l) in enumerate(eachline(f))
            if l == ""
                continue
            end
            number_matches = collect(eachmatch(r"\d+", l))
            if length(number_matches) > 0
                number_matches = map(x->parse(Int64,x.match),number_matches)
                push!(subsection, (number_matches[2], number_matches[2] - number_matches[1], number_matches[3]))
            else
                push!(sections, subsection)
                subsection = []
            end
        end
    end
    push!(sections, subsection)

    vals = zeros(Int64, length(seeds)÷2)

    Threads.@threads for idx in 1:2:length(seeds)-1#÷2
        min_val = typemax(Int64)
        for offset in range(0, seeds[1, idx + 1] - 1)
            curr = seeds[1, idx] + offset
            min_val = min(min_val, get(sections, curr))
        end
        println(min_val)
    end
end


function part1()
    seeds = [4239267129 20461805 2775736218 52390530 3109225152 741325372 1633502651 46906638 967445712 47092469 2354891449 237152885 2169258488 111184803 2614747853 123738802 620098496 291114156 2072253071 28111202]
    sections = []
    subsection = []
    locs::Array{Int64} = []
    open("inputs/day5.txt") do f
        for (idx, l) in enumerate(eachline(f))
            if l == ""
                continue
            end
            number_matches = collect(eachmatch(r"\d+", l))
            if length(number_matches) > 0
                number_matches = map(x->parse(Int64,x.match),number_matches)
                push!(subsection, (number_matches[2], number_matches[2] - number_matches[1], number_matches[3]))
            else
                push!(sections, subsection)
                subsection = []
            end
        end
    end
    push!(sections, subsection)
    for seed in seeds
        curr = seed
        for section in sections
            for row in section
                if row[1] <= curr <= row[1] + row[3] - 1
                    curr -= row[2]
                    break
                end
            end
        end
        push!(locs, curr)
    end
    println(minimum(locs))
end

part1()
part2()