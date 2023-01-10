=begin
        mfp(1)		= 1
        mfp(9999)	= 73
        mfp(10000)	= 23
=end

def mfp(m)
    p_sum = 0
    for i in (1..m)
        p_sum += p(i)
    end
    return get_max_prime_factor(p_sum)
end

def p(n)
    sum = 1
    while (n != 0)
        i = n % 10
        if (i != 0)
            sum *= i
        end
        n /= 10
    end
    return sum
end

def get_max_prime_factor(n)
	return 1 if n == 1

	for i in 2..n
		while (n % i) == 0
			n = n / i
		end
		if n == 1
			break
		end
	end
	
	return i
end

=begin
def get_max_prime_factor(n)
    if (n == 1)
        return 1
    elsif is_prime(n)
        return n
    else
        i = n / 2
        while (i >= 1)
            if ((n % i) == 0)
                if is_prime(i) or (i == 1)
                    return i
                end
            end
            i -= 1
        end
    end
end

def is_prime(n)
    if n == 1
        return false
    elsif n == 2
        return true
    else
        i = 2 #
        while (i * i <= n) # n ** (1.0 / 2)
            if ((n % i) == 0)
                return false   
            end        
            i = i + 1
        end
        return true
    end
end
=end
#puts is_prime(81)
#puts get_max_prime_factor()
=begin
puts mfp(1)
puts mfp(9999)
puts mfp 100000
puts mfp 1000000
=end
