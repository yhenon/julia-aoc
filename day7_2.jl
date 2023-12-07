
function get_hand_rank(x, num_jokers)
    #println(x)
    if length(x) > 0
        x[argmax(x)] += num_jokers
    else
        x = [5]
    end
    
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
    num_j_x = count(==('J'), x[1])
    num_j_y = count(==('J'), y[1])

    cards_x = replace(x[1], 'J'=>"")
    cards_y = replace(y[1], 'J'=>"")
    #println(x,' ', cards_x, ' ', num_j_x)
    xh = get_hand_rank([count(==(i), cards_x) for i in unique(collect(cards_x))], num_j_x)
    yh = get_hand_rank([count(==(i), cards_y) for i in unique(collect(cards_y))], num_j_y)
    vals = Dict('A'=>0, 'K'=>1, 'Q'=>2, 'T'=>3, '9'=>4, '8'=>5, '7'=>6, '6'=>7, '5'=>8, '4'=>9, '3'=>10, '2'=>11, 'J'=>12)

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

function part2()
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

part2()