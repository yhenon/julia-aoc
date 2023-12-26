using LinearAlgebra
using JuMP
import Ipopt
using Printf


Base.show(io::IO, f::Float64) = @printf(io, "%1.16f", f)

function part1()
    d = []
    open("inputs/day24.txt") do f
        for (col, l) in enumerate(eachline(f))
            l = replace(l, " "=>"")
            ls = split(l, '@')
            px, py, pz = map(x->parse(Int64, x), split(ls[1],','))
            vx, vy, vz = map(x->parse(Int64, x), split(ls[2],','))
            push!(d, ((px, py, pz), (vx, vy, vz)))
        end
    end
    num_crosses = 0
    sv = 200000000000000
    ev = 400000000000000
    for i in 1:length(d) - 1
        for j in i+1:length(d)
            p1, v1 = d[i]
            p2, v2 = d[j]
            A = [v1[1] -v2[1];v1[2] -v2[2]]
            b = [p2[1]-p1[1], p2[2]-p1[2]]
            if det(A) == 0.0
                continue
            end
            x = A\b
            if x[1] < 0 || x[2] < 0
                continue
            end
            pxt = p1[1] + v1[1] * x[1]
            pyt = p1[2] + v1[2] * x[1]

            if (sv < pxt < ev) && (sv < pyt < ev)
                num_crosses += 1
            end
        end
    end
    println(num_crosses)
end


function part2()
    d = []
    open("inputs/day24.txt") do f
        for (col, l) in enumerate(eachline(f))
            l = replace(l, " "=>"")
            ls = split(l, '@')
            px, py, pz = map(x->parse(Int64, x), split(ls[1],','))
            vx, vy, vz = map(x->parse(Int64, x), split(ls[2],','))
            push!(d, (px, py, pz, vx, vy, vz))
        end
    end

    model = Model(Ipopt.Optimizer)
    N = length(d)
    @variables(model, begin
        pos[1:3]
        vel[1:3]
        t[1:3]
    end)
    offset = 3
    @constraint(
        model,
        c1,
        (pos[1] + t[1] * vel[1]) == (d[offset+1][1] + t[1]*d[offset+1][4])
    )
    @constraint(
        model,
        c2,
        (pos[2] + t[1] * vel[2]) == (d[offset+1][2] + t[1]*d[offset+1][5])
    )
    @constraint(
        model,
        c3,
        (pos[3] + t[1] * vel[3]) == (d[offset+1][3] + t[1]*d[offset+1][6])
    )

    @constraint(
        model,
        c7,
        (pos[1] + t[2] * vel[1]) == (d[offset+2][1] + t[2]*d[offset+2][4])
    )
    @constraint(
        model,
        c8,
        (pos[2] + t[2] * vel[2]) == (d[offset+2][2] + t[2]*d[offset+2][5])
    )
    @constraint(
        model,
        c9,
        (pos[3] + t[2] * vel[3]) == (d[offset+2][3] + t[2]*d[offset+2][6])
    )

    @constraint(
        model,
        c4,
        (pos[1] + t[3] * vel[1]) == (d[offset+3][1] + t[3]*d[offset+3][4])
    )
    @constraint(
        model,
        c5,
        (pos[2] + t[3] * vel[2]) == (d[offset+3][2] + t[3]*d[offset+3][5])
    )
    @constraint(
        model,
        c6,
        (pos[3] + t[3] * vel[3]) == (d[offset+3][3] + t[3]*d[offset+3][6])
    )
    @objective(
        model,
        Min,
        1
    )

    @constraint(model, ct, t >= 0)

    optimize!(model)
    println("""
    termination_status = $(termination_status(model))
    primal_status      = $(primal_status(model))
    objective_value    = $(objective_value(model))
    """)

    for variable in all_variables(model)
        println("$(name(variable)) = $(value(variable))")
    end
    show(value(pos[1]+pos[2]+pos[3]))
    return
end

part1()
part2()