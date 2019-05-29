using LightGraphs
using Plots
using GraphPlot

n = 5

G1 = SimpleGraph{Int64}(n)

add_edge!(G1,1,3)
add_edge!(G1,1,4)
add_edge!(G1,1,5)
add_edge!(G1,2,3)
add_edge!(G1,2,4)
add_edge!(G1,3,4)
add_edge!(G1,4,5)

# gplot(G1, layout=GraphPlot.circular_layout , nodelabel=1:5)

using JuMP
using Gurobi
model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= x[1:n] >= 0, Int)

@variable(model, 1 >= z[1:n, 1:n] >= 0, Int)

@objective(model, Max, 
                sum(
                    sum(
                        z[i, j] * has_edge(G1, i, j)
                        for j in collect(1:n)
                    )
                    for i in collect(1:n)
                )
)

for i in collect(1:n)
    for j in collect(1:n)
        @constraints(model,
            begin
                x[i] + x[j] - z[i,j] >= 0
                x[i] + x[j] + z[i,j] >= 0
                x[i] + x[j] + z[i,j] <= 2
            end
        )
    end
end

println(model)
optimize!(model)

for i in collect(1:n)
    if (JuMP.value(x[i]) == 0)
        println("Vértice ", i, " pertence à partição: ", 1)
    else
        println("Vértice ", i, " pertence à partição: ", Int(JuMP.value(x[i] + 1)))
    end
end
