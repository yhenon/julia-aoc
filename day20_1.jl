using DataStructures

global num_low = 0
global num_high = 0

mutable struct FlipFlop
    out::Array{String}
    state::String
    name::String
end
mutable struct Conjunction
    inputs::Dict{String, String}
    out::Array{String}
    memory::Array{String}
    name::String
end
mutable struct Broadcast
    out::Array{String}
    name::String
end
mutable struct Noop
    out::Array{String}
    name::String
end


function parse()
    d = Dict{String,Any}()
    conjunctions = []
    modules = Set()
    open("inputs/day20.txt") do f
        for l in eachline(f)
            l = replace(l, " "=>"")
            source, dest = split(l, "->")
            dests = split(dest, ',')
            push!(modules, dests...)
            name = source[2:end]
            if source == "broadcaster"
                d["broadcaster"] = Broadcast(dests, "broadcaster")
            elseif source[1] == '%'
                d[name] = FlipFlop(dests, "low", name)
            elseif source[1] == '&'
                d[name] = Conjunction(Dict(), dests, repeat(["low"], length(dests)), name)
                push!(conjunctions, name)
            end
        end
    end
    for m in modules
        if m ∉ keys(d)
            println(m)
            d[m] = Noop([], m)
        end
    end
    for k in keys(d)
        for c in conjunctions
            if c ∈ d[k].out
                d[c].inputs[k] = "low"
            end
        end
    end
    return d
end

function propagate(q::Queue{Tuple{String, String, String}}, source::String, message::String, mymodule::Broadcast)
    for out in mymodule.out
        enqueue!(q, (mymodule.name, out, message))
        if message == "low"
            global num_low += 1
        else
            global num_high += 1
        end
    end
end

function propagate(q::Queue{Tuple{String, String, String}}, source::String, message::String, mymodule::Noop)
    if message == "low"
        println(num_low, 'm', num_high)
        println(num_low*num_high)
        exit()
    end
end

function propagate(q::Queue{Tuple{String, String, String}}, source::String, message::String, mymodule::FlipFlop)
    if message == "high"
        return
    end
    if mymodule.state == "low"
        mymodule.state = "high"
    else
        mymodule.state = "low"
    end
    for out in mymodule.out
        if mymodule.state == "low"
            global num_low += 1
        else
            global num_high += 1
        end
        enqueue!(q, (mymodule.name, out, mymodule.state))
    end
end

function propagate(q::Queue{Tuple{String, String, String}}, source::String, message::String, mymodule::Conjunction)
    if source ∉ keys(mymodule.inputs)
        println("Error")
        exit()
    end
    mymodule.inputs[source] = message
    all_high = false
    if "low" ∉ values(mymodule.inputs)
        all_high = true
    end
    for out in mymodule.out
        if all_high
            enqueue!(q, (mymodule.name, out, "low"))
            global num_low += 1
        else
            enqueue!(q, (mymodule.name, out, "high"))
            global num_high += 1
        end
    end
end


function part1()
    d = parse()
    q = Queue{Tuple{String, String, String}}()
    for i in 1:1000
        enqueue!(q, ("button", "broadcaster", "low"))
        global  num_low += 1
        while !isempty(q)
            (source, destination, message) = dequeue!(q)
            #println(source, ',', message, ',', destination)# ',', d[destination], ',')
            propagate(q, source, message, d[destination])
        end
    end
    println(num_low, ',', num_high)
    println(num_low * num_high)
end

part1()