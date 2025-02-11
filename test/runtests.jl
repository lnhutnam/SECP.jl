using SECP
using Test

@testset "f_value function tests" begin
    # Test Case 1: Simple 3×2 matrix
    B = [-2 0; 0 2; 2 0]
    x = [0.0, 0.0]  # Test point at origin
    @test SECP.f_value(B, x) ≈ 2.0  # Max distance should be 2 (from (2,0) or (-2,0))

    # Test Case 2: Single point (should return distance from x to that point)
    B = [3 4]  # Single point
    x = [0.0, 0.0]
    @test SECP.f_value(B, x) ≈ 5.0  # Distance from (0,0) to (3,4) is 5 (Pythagorean theorem)

    # Test Case 3: Multiple points with a farthest one
    B = [1 1; -3 -4; 2 2]
    x = [0.0, 0.0]
    @test SECP.f_value(B, x) ≈ 5.0  # Max distance from (0,0) is from (-3,-4), which is 5

    # Test Case 4: x is inside the points (should still return max distance)
    B = [1 1; -1 -1; 2 2; -2 -2]
    x = [0.5, 0.5]
    @test SECP.f_value(B, x) ≈ sqrt(8)  # Max distance from (-2,-2) is sqrt(8)
    
    println("All tests passed!")
end
