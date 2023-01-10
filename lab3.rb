def count_ones(n)
    sum = 0
    while (n / 2) != 0
        sum += (n % 2)
        n /= 2
    end
    return sum + (n % 2)
end
