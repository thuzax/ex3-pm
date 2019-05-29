using LightGraphs
using Plots
using GraphPlot


G1 = SimpleGraph{Int64}(6)

add_edge!(G1,1,2)
add_edge!(G1,1,3)
add_edge!(G1,1,5)
add_edge!(G1,1,6)
add_edge!(G1,2,3)
add_edge!(G1,2,4)
add_edge!(G1,2,5)
add_edge!(G1,2,6)
add_edge!(G1,3,4)
add_edge!(G1,3,5)
add_edge!(G1,3,6)
add_edge!(G1,4,6)
add_edge!(G1,5,6)


## Acessando as arestas do grafo
println("Arestas")
for e in edges(G1)
    println("(", src(e), ",", dst(e), ")")
end

# gplot(G1, layout=GraphPlot.circular_layout , nodelabel=1:6)

using JuMP
using Gurobi

n = 6

model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= horarios_comissao[1:n, 1:n] >= 0, Int)

@variable(model, 1 >= horarios_escolhidos[1:n] >= 0, Int)

@objective(model, Min, 
                    sum(
                        horarios_escolhidos[i]
                        for i in collect(1:n)
                    )
)


for edge in edges(G1)
    for i in collect(1:n)
    @constraint(model,
                  horarios_comissao[src(edge), i] + horarios_comissao[dst(edge), i] <= 1 
    )
    end
end



for i in collect(1:n)
    @constraint(model, 
                    sum(
                        horarios_comissao[i,j]
                        for j in collect(1:n)
                    ) == 1
    )
end

for i in collect(1:n)
    
    @constraint(model,
        sum(
            horarios_comissao[j,i]
            for j in collect(1:n)
        ) 
        <= horarios_escolhidos[i] * n
    )
end


print(model)
optimize!(model)

for i in collect(1:n)
    for j in collect(1:n)
        if (JuMP.value(horarios_comissao[i,j]) == 0)
            print(0, "\t")
        else
            print(JuMP.value(horarios_comissao[i,j]), "\t")
        end
    end
    println()
end

println()
