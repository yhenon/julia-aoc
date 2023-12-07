
function get_hand_rank(x)
    if 5 ∈ x
        return 0
    elseif 4 ∈ x
        return 1 
    elseif 3 ∈ x && 2 ∈ x
        return 2
    elseif 3 ∈ x
        return 3
    elseif count(==(2), x) == 2
        return 4
    elseif 2 ∈ x
        return 5
    else
        return 6
    end
end

function is_less_hand(x, y)
    xh = get_hand_rank([count(==(i), x[1]) for i in unique(collect(x[1]))])
    yh = get_hand_rank([count(==(i), y[1]) for i in unique(collect(y[1]))])
    vals = Dict('A'=>0, 'K'=>1, 'Q'=>2, 'J'=>3, 'T'=>4, '9'=>5, '8'=>6, '7'=>7, '6'=>8, '5'=>9, '4'=>10, '3'=>11, '2'=>12)

    if xh != yh
        
        return xh > yh
    else
        for idx in 1:5

            card_x = vals[x[1][idx]]
            card_y = vals[y[1][idx]]

            if card_x != card_y

                return card_x > card_y
            end
        end
    end
    return true
end

function part1()
    hands = []
    open("inputs/day7.txt") do f
        for l in eachline(f)
            (hand, bid) = split(l, ' ')
            bid = parse(Int64, bid)
            push!(hands, (hand, bid))
        end
    end
    sort!(hands, lt=is_less_hand)
    total::Int64 = 0
    for ix in 1:length(hands)
        total += ix * hands[ix][2]
    end
    println(total)
end

part1()