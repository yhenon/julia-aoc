function get_num(nn)
    arrays = []

    open("inputs/day13.txt") do f
        array = []
        for l in eachline(f)
            l = replace(l, '.'=>'0')
            l = replace(l, '#'=>'1')
            l = map(x->parse(Int64,x), collect(l))

            if l == []
                push!(arrays, array)
                array = []
            else
                push!(array, l)
            end
        end
        push!(arrays, array)
    end

    score = 0
    for arr in arrays
        arr = transpose(hcat(arr...))
        (rows, cols) = size(arr)
        for ix in 1:(rows-1)
            N = min(ix, rows-ix)
            a = arr[ix-N+1:ix, :]
            b = arr[ix+1:ix+N, :][end:-1:1, :]
            num_non_zero = count(!=(0), a-b)
            if num_non_zero == nn
                score += 100 * ix
            end
        end
        for ix in 1:(cols-1)
            N = min(ix, cols-ix)
            a = arr[:, ix-N+1:ix]
            b = arr[:, ix+1:ix+N][:, end:-1:1]
            num_non_zero = count(!=(0), a-b)
            if num_non_zero == nn
                score += 1 * ix
            end
        end        
    end
    println(score)
end

function part1()
    get_num(0)
end

function part2()
    get_num(1)
end

part1()
part2()