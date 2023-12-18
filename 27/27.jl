function summa(vector, s = 0)
    if length(vector) == 0
        return s
    end
    return summa(vector[1:end-1], s + vector[end])
end

vector = [1, 2, 3]
print(summa(vector))