using OrderedCollections

function myhash(s::AbstractString)
    n = 0
    for char in s
        n = ((Int32(char) + n) * 17) % 256
    end
    return n
end

function part1()
    score = 0
    open("inputs/day15.txt") do f
        for l in eachline(f)

            score += sum(map(x->myhash(x), collect(split(l, ','))))
        end
    end
    println(score)
end

function part2()
    d = Dict()
    for i in 0:256
        d[i] = OrderedDict()
    end
    
    open("inputs/day15.txt") do f
        for l in eachline(f)
            for v in split(l, ',')
                if '=' ∈ v
                    val = v[1:end-2]
                    pos = myhash(v[1:end-2])
                    focal = parse(Int32, v[end])
                    d[pos][val] = focal
                else
                    val = v[1:end-1]
                    pos = myhash(v[1:end-1])
                    delete!(d[pos], val)
                end
            end
        end
    end
    score = 0
    for i in 0:256
        for (idx, key) in enumerate(keys(d[i]))
            score += (i+1) * idx * d[i][key]
        end
    end
    println(score)
end

part1()
part2()