using SECP
using Plots

function main()
    A = 10 .* rand(100, 2)
    x = [0, 0]

    K = 5000

    V = f_value(A, x)

    z = copy(x)

    for i in 1:K 
        x = x - 0.01 .* sub_d(A, x)
        if f_value(A, x) <= V
            V = f_value(A, x)
            z = copy(x)
        end
    end
    draw_disk(z, V)
    scatter!(A[:, 1], A[:, 2], color=:red, marker=:star, label="Points in A")
    title!("Optimization Result and Points in A")
    # display(plot())
    savefig("figures/optimization_result.png")
    println("Optimized point z: $z, Minimized maximum distance V: $V")
end

main()