using GeometryBasics
using Printf
Base.show(io::IO, f::Float64) = @printf(io, "%1.12f", f)

function is_on_boundary(d::Dict, x::Int64, y::Int64)
    return x ∈ keys(d) && y ∈ keys(d[x])
end

function part1()
    x = 0
    y = 0
    min_x = 1000
    min_y = 1000
    max_x = -1000
    max_y = -1000
    d = Dict()
    open("inputs/day18.txt") do f
        for l in eachline(f)
            dir = l[1]
            steps = parse(Int32,split(l, ' ')[2])
            for _ in 1:steps
                if dir == 'U'
                    x -= 1
                elseif dir == 'D'
                    x += 1
                elseif dir == 'R'
                    y += 1
                elseif  dir == 'L'
                    y -= 1
                end
                if x ∉ keys(d)
                    d[x] = Dict()
                end
                d[x][y] = 1
                min_x = min(x, min_x)
                min_y = min(y, min_y)
                max_x = max(x, max_x)
                max_y = max(y, max_y)
            end
        end
    end
    area = 0
    for x in min_x:max_x
        is_in = false
        for y in min_y:max_y
            if is_on_boundary(d, x, y) && is_on_boundary(d, x-1, y)
                is_in = !is_in
            end
            if is_on_boundary(d, x, y) || is_in
                area += 1
            end
        end
    end
    println(area)
end

function part2()

    dirs = Dict('0'=>'R', '1'=>'D', '2'=>'L', '3'=>'U')
    x = 0.0
    y = 0.0
    pts::Vector{Point2{Float64}} = []
    push!(pts, Point(x, y))
    p = 0
    open("inputs/day18.txt") do f
        for l in eachline(f)
            hex = split(l, ' ')[3][2:end-1]
            dir = dirs[hex[end]]
            steps = parse(Float64, replace(hex[1:end-1], "#"=>"0x"))
            p += steps
            if dir == 'U'
                x -= steps
            elseif dir == 'D'
                x += steps
            elseif dir == 'R'
                y += steps
            elseif  dir == 'L'
                y -= steps
            end
            push!(pts, Point(x, y))
        end
    end
    a = -area(pts)
    show(a + p/2 + 1)
end

part1()
part2()