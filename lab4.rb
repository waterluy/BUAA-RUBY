def decode_ways(code)
    # code == 0
    return 0 if code == 0

    str = code.to_s
    # code contains '50'....
    return 0 if str =~ /[^12]0/

    # remove '10' and '20'
    splits = str.split(/[12]0/)
    splits.delete("")
    splits.map!(&:to_i)
    return 1 if splits.size == 0

    def fb(num)
        s1, s2 = 0, 1 
        prevd = 0
        sum = 0
        digits = num.to_s.chars.map(&:to_i)
        for d in digits  # no 0
            sum = s2;
            if (prevd == 1) || ((prevd == 2) && (d <= 6))
                sum += s1
            end
            s1 = s2
            s2 = sum
            prevd = d  # update
            #puts ("s1-#{s1} s2-#{s2} sum-#{sum}")
        end
        return sum
    end
    
    ways = []
    for num in splits 
        ways << fb(num)
    end

    return ways.inject(&:*)
end

