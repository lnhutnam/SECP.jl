using SECP
using Test
using LinearAlgebra

@testset "SECP.jl Tests" begin
    @testset "f_value function" begin
        # Test Case 1: Simple symmetric matrix
        B = [-2 0; 0 2; 2 0]
        x = [0.0, 0.0]  # Test point at origin
        @test SECP.f_value(B, x) ≈ 2.0  # Max distance should be 2 (from (2,0) or (-2,0))

        # Test Case 2: Single point
        B = [3 4]  # Single point
        x = [0.0, 0.0]
        @test SECP.f_value(B, x) ≈ 5.0  # Distance from (0,0) to (3,4) is 5

        # Test Case 3: Multiple points with a farthest one
        B = [1 1; -3 -4; 2 2]
        x = [0.0, 0.0]
        @test SECP.f_value(B, x) ≈ 5.0  # Max distance from (0,0) is from (-3,-4)
    end

    @testset "sub_d function" begin
        # Test subgradient computation
        B = [-2 0; 0 2; 2 0]
        x = [0.0, 0.0]
        subgrad = SECP.sub_d(B, x)
        
        # Verify subgradient properties
        @test length(subgrad) == 2  # 2D vector
        @test norm(subgrad) ≈ 1.0  # Normalized direction
    end

    @testset "solve_secp function" begin
        # Test with various point configurations
        test_configs = [
            10 .* rand(50, 2),   # Random points
            [-2 0; 0 2; 2 0],    # Symmetric configuration
            [1 1; 4 4; 7 7]      # Linear configuration
        ]

        for B in test_configs
            # Solve SECP
            x, V = solve_secp(B)
            
            # Verify solution properties
            @test length(x) == 2  # 2D point
            @test V >= 0           # Non-negative max distance
            @test V ≤ f_value(B, x)  # Optimality check
        end
    end
end

println("All SECP.jl tests passed successfully!")