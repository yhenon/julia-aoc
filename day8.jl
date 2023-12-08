function part1()
    seq = "LLLLRLRLRRLRRRLRRLRLRRLRLLRRRLRRLRRRLRLLLRLRRLRLLRRRLRRLRLRRLLRRRLRRRLRLRRLRRRLRRLRRLLRRRLLLLRRLRRLRRLRRRLLLRLRLRLRRLRRRLRLRRRLRLRRRLRRLRRLLRRLLRLRRRLRLRRRLLLRLRRRLRLRRRLRRLRLRRLRRRLRRRLRRLLLRRRLRRLRRLRRLRRRLLLRRLRLRRRLLLLRRRLRRLRRRLLRLRLRRLLRRRLLRLRLRLRRLRRLRRRLRRLLRLRRLRRLLLLRRLRLRRLLRRLLRRLRRLRRRLLLRRRR"
    seq_lookup = Dict('L'=>1, 'R'=>2)
    instr::Dict{String, Tuple{String, String}} = Dict()
    open("inputs/day8.txt") do f
        for l in eachline(f)
            node1 = l[1:3]
            node2 = l[8:10]
            node3 = l[13:15]
            instr[node1] = (node2, node3)
        end
    end
    loc = "AAA"
    num_steps = 0
    while true
        for elem in collect(seq)
            loc = instr[loc][seq_lookup[elem]]
            num_steps += 1
            if loc == "ZZZ"
                println(num_steps)
                return
            end
        end
    end
end

function part2()
    seq = "LLLLRLRLRRLRRRLRRLRLRRLRLLRRRLRRLRRRLRLLLRLRRLRLLRRRLRRLRLRRLLRRRLRRRLRLRRLRRRLRRLRRLLRRRLLLLRRLRRLRRLRRRLLLRLRLRLRRLRRRLRLRRRLRLRRRLRRLRRLLRRLLRLRRRLRLRRRLLLRLRRRLRLRRRLRRLRLRRLRRRLRRRLRRLLLRRRLRRLRRLRRLRRRLLLRRLRLRRRLLLLRRRLRRLRRRLLRLRLRRLLRRRLLRLRLRLRRLRRLRRRLRRLLRLRRLRRLLLLRRLRLRRLLRRLLRRLRRLRRRLLLRRRR"
    seq_lookup = Dict('L'=>1, 'R'=>2)
    instr::Dict{String, Tuple{String, String}} = Dict()
    locs = []

    open("inputs/day8.txt") do f
        for l in eachline(f)
            node1 = l[1:3]
            node2 = l[8:10]
            node3 = l[13:15]
            instr[node1] = (node2, node3)
            if node1[3] == 'A'
                push!(locs, node1)
            end
        end
    end

    done_nodes = zeros(Int64, length(locs))
    num_steps = 0
    while true
        for elem in collect(seq)
            num_steps += 1
            
            for (idx, loc) in enumerate(locs)
                locs[idx] = instr[loc][seq_lookup[elem]]
                if locs[idx][3] == 'Z'
                    done_nodes[idx] = num_steps
                end
            end
            if count(==(0), done_nodes) == 0
                println(lcm(done_nodes))
                return
            end            
        end
    end
end

part1()
part2()