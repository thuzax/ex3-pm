using LightGraphs
using Plots
using GraphPlot

using JuMP
using Gurobi
n = 5

G1 = SimpleGraph{Int64}(n)

add_edge!(G1,1,3)
add_edge!(G1,1,2)
add_edge!(G1,1,4)
add_edge!(G1,1,5)
add_edge!(G1,2,3)
add_edge!(G1,2,5)
add_edge!(G1,2,4)
add_edge!(G1,3,5)
add_edge!(G1,4,5)

# gplot(G1, layout=GraphPlot.circular_layout , nodelabel=1:5)

model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= x[1:n] >= 0, Int)
@variable(model, 1 >= y[1:n] >= 0, Int)


@objective(model, Max, 
                    sum(
                        x[i]
                        for i in collect(1:n)
                    )
)

total_x = sum(
            (sum(
                has_edge(G1, i, j) 
                for j in collect(1:n)
            ) * x[i])
            for i in collect(1:n)
        )


total = sum(
            sum(has_edge(G1, i, j) 
            for j in collect(1:n)
        ) 
        for i in (1:n)
    )

@constraint(model, total_x <= (total / 2))

@constraints(model, 
                begin
                    [i in collect(1:n)], x[i] + y[i] == 1
                end
)

println(model)
optimize!(model)

for i in collect(1:n)
    if (JuMP.value(x[i]) == 0)
        println(i, " ", 0, " ", JuMP.value(y[i]))
    else
        println(i, " ", JuMP.value(x[i]), " ", 0)
    end
end