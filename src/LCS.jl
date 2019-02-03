module LCS

# ----------------------------------------
# EXPORTED INTERFACE
# ----------------------------------------

export lcs

# ----------------------------------------
# EXPORTED FUNCTIONS
# ----------------------------------------

function lcs(left, right, comparator)
    splits = split(walk(table(left, right, comparator), left, right, comparator))

    grouper   = ( x, y ) -> y[1] == x[1] + 1 && x[2] == y[2]
    collector = group -> ( group[1][2], range(group[1][1], group[end][1], step = 1) )

    return map(groups -> map(collector, groups), map(list -> group_by(list, grouper), splits))
end

# ----------------------------------------
# PRIVATE FUNCTIONS
# ----------------------------------------

# Group up the sequence pairs ( boolean, index ) into a sequence that uses ranges ... ( boolean, [start ... end] ).
#
function group_by(ungrouped, comparator)
    function worker(head, tail, accumulator, accumulators)
        push!(accumulator, head)
        if isempty(tail)
            push!(accumulators, accumulator)

        else
            if !comparator(head, tail[1])
                push!(accumulators, accumulator)
                accumulator = [ ]
            end

            worker(tail[1], tail[2:end], accumulator, accumulators)
        end
    end


    accumulators = [ ]

    if !isempty(ungrouped)
        worker(ungrouped[1], ungrouped[2:end], [ ], accumulators)
    end

    return accumulators
end


# This builds the longest-common-subsequence table of costs. 
#
function table(left, right, comparator)
    rows    = length(left) + 1
    columns = length(right) + 1
    costs   = zeros(UInt64, rows, columns)

    for column = 2:columns
        for row = 2:rows
            if comparator(left[row - 1], right[column - 1])
                costs[row, column] = costs[row - 1, column - 1] + 1

            else
                costs[row, column] = max(costs[row, column - 1], costs[row - 1, column])
            end
        end
    end

    return costs
end


# Partition the sets into left and right groupings.
#
function split(boths)
    return ( map(left -> ( left[2], left[1] == "L" ), filter(both -> both[1] == "L" || both[1] == "=", boths)),
             map(right -> ( right[3], right[1] == "R" ), filter(both -> both[1] == "R" || both[1] == "=", boths)) )
end


# Walk the LCS costs table to generate diff op-codes.
#
function walk(costs, left, right, comparator)
    function worker(i, j, accumulator::Array{Any, 1})
        if i > 1 && j > 1 && comparator(left[i - 1], right[j - 1])
            worker(i - 1, j - 1, accumulator)
            push!(accumulator, ( "=", i - 1, j - 1, left[i - 1] ))

        elseif j > 1 && (i == 1 || costs[i, j - 1] >= costs[i - 1, j])
            worker(i, j - 1, accumulator)
            push!(accumulator, ( "R", i - 1, j - 1, right[j - 1] ))

        elseif i > 1 && (j == 1 || costs[i, j - 1] < costs[i - 1, j])
            worker(i - 1, j, accumulator)
            push!(accumulator, ( "L", i - 1, j - 1, left[i - 1] ))
        end
    end


    accumulator = [ ]
    worker(size(costs)[1], size(costs)[2], accumulator)

    return accumulator
end

end
