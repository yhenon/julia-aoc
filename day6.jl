function part1()
    times=[61, 70, 90, 66]
    distances=[643, 1184, 1362, 1041]
    wins = []
    for ix in 1:length(times)
        time = times[ix]
        distance = distances[ix]
        vals = collect(1:time-1)
        travelled = vals .* (time .- vals)
        num = sum(travelled .> distance)
        push!(wins, num)
    end
    println(prod(wins))
end

function part2()
    times=[61709066]
    distances=[643118413621041]
    wins = []
    for ix in 1:length(times)
        time = times[ix]
        distance = distances[ix]
        vals = collect(1:time-1)
        travelled = vals .* (time .- vals)
        num = sum(travelled .> distance)
        push!(wins, num)
    end
    println(prod(wins))
end
part1()
part2()