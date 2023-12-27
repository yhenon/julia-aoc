using Graphs
#using GLMakie, GraphMakie
#using GraphMakie.NetworkLayout

function part1()
    g = Graph()
    d = Dict()
    d2 = Dict()
    N = 1
    s = []
    open("inputs/day25.txt") do f
        for (col, l) in enumerate(eachline(f))
            ls = split(l, ':')
            source = ls[1]
            sinks = split(ls[2], ' ')[2:end]
            if source ∉ keys(d2)
                d[N] = source
                d2[source] = N
                N += 1
                add_vertex!(g)
            end
            for sink in sinks
                if sink ∉ keys(d2)
                    d[N] = sink
                    d2[sink] = N
                    N += 1
                    add_vertex!(g)
                end
                push!(s, (d2[source], d2[sink]))
            end
        end
    end
    for (v1, v2) in s
        ret = add_edge!(g, v1, v2)
    end
    node_names = []
    for i in 1:nv(g)
        push!(node_names, d[i])
    end
    #, ax, p = graphplot(g; ilabels=node_names, arrow_shift=:end)
    # look at the graph and write down the 3 cuts to make 
    cuts = [("ddj", "znv"), ("rrz", "pzq"), ("jtr", "mtq")]
    for cut in cuts
        rem_edge!(g, d2[cut[1]], d2[cut[2]])
    end
    cc = connected_components(g)
    println(length(cc[1])*length(cc[2]))

end

part1()