function drop_blocks(arr::Array{Int, 3}, blocks::Vector)
    fallen_blocks = Set()
    while true
        state_changed = false
        for block in blocks
            block_id = block[3]
            subarr = arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3]:block[2][3]]

            if count(==(block_id), subarr) != prod(length(subarr))
                println("bad state")
                println(subarr)
                println(block_id)
                exit()
            end

            z = block[1][3] - 1
            if z == 1
                continue
            end
            below = arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3] - 1]
            if sum(below) == 0
                push!(fallen_blocks, block_id)
                arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3]:block[2][3]] .= 0
                arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3]-1:block[2][3]-1] .= block_id
                block[1][3] -= 1
                block[2][3] -= 1
                state_changed = true
            end
        end
        if !state_changed
            break
        end
    end
    return fallen_blocks
end

function find_supports(arr::Array{Int64, 3}, blocks::Vector)
    
    supports = Dict()
    for (block_id, block) in enumerate(blocks)
        below = arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3] - 1]
        if sum(below) != 0
            supports[block_id] = unique(unique(filter(x->x!=0, below)))
        end
    end
    return supports
end
function part1()
    blocks = []
    max_x = 0
    max_y = 0
    max_z = 0
    open("inputs/day22.txt") do f
        for (id, l) in enumerate(eachline(f))
            startl, stopl = split(l, '~')
            start = map(x->parse(Int64, x), split(startl, ','))
            stop = map(x->parse(Int64, x), split(stopl, ','))
            max_x = max(max_x, stop[1])
            max_y = max(max_y, stop[2])
            max_z = max(max_z, stop[3])
            push!(blocks, (start.+1, stop.+1, id))
        end
    end
    #println(blocks)
    #println(max_x, ',', max_y, ',', max_z)
    arr = zeros(Int64, max_x+1, max_y+1, max_z+1)
    for (block_id, block) in enumerate(blocks)
        arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3]:block[2][3]] .= block_id
    end

    _ = drop_blocks(arr, blocks)

    supports = find_supports(arr, blocks)
    #show(supports)
    unsafe = Set()
    for v in values(supports)
        if length(v) == 1
            push!(unsafe, v[1])
        end
    end
    println(length(blocks) - length(unsafe))
end

function part2()
    blocks = []
    max_x = 0
    max_y = 0
    max_z = 0
    open("inputs/day22.txt") do f
        for (id, l) in enumerate(eachline(f))
            startl, stopl = split(l, '~')
            start = map(x->parse(Int64, x), split(startl, ','))
            stop = map(x->parse(Int64, x), split(stopl, ','))
            max_x = max(max_x, stop[1])
            max_y = max(max_y, stop[2])
            max_z = max(max_z, stop[3])
            push!(blocks, (start.+1, stop.+1, id))
        end
    end

    arr = zeros(Int64, max_x+1, max_y+1, max_z+1)
    for (block_id, block) in enumerate(blocks)
        arr[block[1][1]:block[2][1], block[1][2]:block[2][2], block[1][3]:block[2][3]] .= block_id
    end
    _ = drop_blocks(arr, blocks)
    total = 0
    for idx in 1:length(blocks)
        arrt = deepcopy(arr)
        arrt = ifelse.(arrt.==idx, 0, arrt)
        blockst = deepcopy(blocks)
        deleteat!(blockst, idx)
        fallen = drop_blocks(arrt, blockst)
        total += length(fallen)
    end
    println(total)

end

part1()
part2()