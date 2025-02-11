module SECP

using Random
using LinearAlgebra
using Plots

function f_value(B, x)
    max_distance = norm(x - B[1, :])
    n = size(B, 1) 
    for i in 1:n
        distance = norm(x - B[i, :])
        max_distance = max(max_distance, distance)
    end
    return max_distance
end

function sub_d(B, x)
    n = size(B, 1)
    W = zeros(n)
    for l in 1:n 
        W[l] = norm(x - B[l, :])
    end
    p = argmax(W)
    if W[p] == 0
        z = 0
    else
        z = (x - B[p, :]) / norm(x - B[p, :])
    end
    return z
end

function draw_disk(center, r)
    t = range(0, 2π, length=1000)
    x = r .* cos.(t) .+ center[1]
    y = r .* sin.(t) .+ center[2]
    
    plot(x, y, aspect_ratio=:equal, linewidth=2, label="")
end

export f_value
export sub_d 
export draw_disk

function greet_your_package_name()
    return "Hello YourPackageName!"
end

export greet_your_package_name

end
