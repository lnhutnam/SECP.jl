using SECP
using Plots
using Random

function main()
    # Set random seed for reproducibility
    Random.seed!(42)

    # Generate random points
    A = 10 .* rand(100, 2)

    # Solve the SECP problem
    optimized_point, min_max_distance = solve_secp(A)

    # Visualize the result
    p = visualize_secp(A, optimized_point, min_max_distance)

    # Create figures directory if it doesn't exist
    mkpath("figures")

    # Save the plot
    savefig(p, "figures/optimization_result.png")

    # Print optimization results
    println("Optimized point: ", optimized_point)
    println("Minimum maximum distance: ", min_max_distance)
end

# Run the main function
main()