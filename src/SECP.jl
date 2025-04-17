module SECP

using Random
using LinearAlgebra
using Plots

function custom_mean(A::AbstractMatrix)
    # Compute column-wise mean
    return vec(sum(A, dims=1) ./ size(A, 1))
end

"""
Compute the maximum distance from a point x to a set of points B.

# Arguments
- `B`: Matrix of points
- `x`: Reference point

# Returns
Maximum distance from x to any point in B
"""
function f_value(B::AbstractMatrix, x::AbstractVector)
    # Ensure inputs are float
    B_float = float(B)
    x_float = float(x)
    
    # Compute distances to each point
    distances = [norm(x_float - B_float[i, :]) for i in 1:size(B_float, 1)]
    
    # Return maximum distance
    return maximum(distances)
end

"""
Compute the subgradient direction for the smallest enclosing covering point problem.

# Arguments
- `B`: Matrix of points
- `x`: Current point

# Returns
Subgradient direction vector
"""
function sub_d(B::AbstractMatrix, x::AbstractVector)
    # Ensure inputs are float
    B_float = float(B)
    x_float = float(x)
    
    # Compute distances to each point
    distances = [norm(x_float - B_float[i, :]) for i in 1:size(B_float, 1)]
    
    # Find the point with maximum distance
    max_dist_index = argmax(distances)
    
    # If all points are at the same location, return zero
    if distances[max_dist_index] == 0
        return zeros(size(x_float))
    end
    
    # Return normalized direction vector
    return (x_float - B_float[max_dist_index, :]) / distances[max_dist_index]
end

"""
Draw a disk centered at a given point with a specified radius.

# Arguments
- `center`: Center of the disk
- `r`: Radius of the disk

# Returns
Plotting object representing the disk
"""
function draw_disk(center::AbstractVector, r::Real)
    # Ensure inputs are float
    center_float = float(center)
    r_float = float(r)
    
    # Generate points on the circumference
    t = range(0, 2π, length=1000)
    x = r_float .* cos.(t) .+ center_float[1]
    y = r_float .* sin.(t) .+ center_float[2]
    
    # Create and return the plot
    return plot(x, y, aspect_ratio=:equal, linewidth=2, label="")
end

"""
Solve the Smallest Enclosing Covering Point (SECP) problem.

# Arguments
- `B`: Matrix of points
- `x0`: Initial point (optional)
- `max_iter`: Maximum number of iterations
- `learning_rate`: Step size for gradient descent

# Returns
Tuple of (optimized point, minimum maximum distance)
"""
function solve_secp(
    B::AbstractMatrix, 
    x0::Union{AbstractVector, Nothing} = nothing, 
    max_iter::Int = 5000, 
    learning_rate::Float64 = 0.01
)
    # Ensure inputs are float
    B_float = float(B)
    
    # Set default initial point if not provided
    if isnothing(x0)
        x0 = custom_mean(B_float)
    else
        x0 = float(x0)
    end
    
    x = x0
    V = f_value(B_float, x)
    z = copy(x)

    for _ in 1:max_iter
        x = x - learning_rate .* sub_d(B_float, x)
        current_V = f_value(B_float, x)
        
        if current_V <= V
            V = current_V
            z = copy(x)
        end
    end

    return z, V
end

# Visualization wrapper
"""
Visualize the SECP solution.

# Arguments
- `B`: Matrix of points
- `x`: Optimized point
- `V`: Minimum maximum distance

# Returns
Plot of the solution
"""
function visualize_secp(B::AbstractMatrix, x::AbstractVector, V::Real)
    # Create disk plot
    p = draw_disk(x, V)
    
    # Add scatter plot of original points
    scatter!(p, B[:, 1], B[:, 2], color=:red, marker=:star, label="Points in A")
    
    # Add plot styling
    title!(p, "SECP Optimization Result")
    xlabel!(p, "X coordinate")
    ylabel!(p, "Y coordinate")
    
    return p
end

# Exports
export f_value, sub_d, draw_disk, solve_secp, visualize_secp, custom_mean

end # module