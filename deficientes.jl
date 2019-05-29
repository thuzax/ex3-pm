# using LightGraphs
# using Plots
# using GraphPlot

using JuMP
using Gurobi

numero_de_trabalhadores = 6
numero_trabalhadores_nd = 3
numero_trabalhadores_d = 3

INFINITO = 999
T_ND = [5, 8, 3, 7, 8, 12]
T_D1 = [12, 10, 5, 9, 15, 12]
T_D2 = [10, 8, INFINITO, 9, 9, 23]
T_D3 = [10, 9, 4, INFINITO, INFINITO, 30]

matriz_tempos = [[],[],[],[],[],[]]

for i in collect(1:numero_trabalhadores_nd)
    append!(matriz_tempos[i], T_ND)
end

matriz_tempos[4] = T_D1
matriz_tempos[5] = T_D2
matriz_tempos[6] = T_D3

println(matriz_tempos)
println(matriz_tempos[2][2])
println(matriz_tempos[2])


tarefas = collect(1:numero_de_trabalhadores)

model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= atribuicao_tarefas[1:numero_de_trabalhadores, 1:numero_de_trabalhadores] >= 0, Int)




# @variable(model, 1 >= x[1:n] >= 0, Int)
# @variable(model, 1 >= y[1:n] >= 0, Int)
# print(atribuicao_tarefas[2])
# println(atribuicao_tarefas[2, 2] * )

@objective(model, Min,
                sum(
                    sum(
                        atribuicao_tarefas[i, j] * matriz_tempos[i][j]
                        for i in collect(1:numero_de_trabalhadores)
                    ) 
                    for j in collect(1:numero_de_trabalhadores) 
                )
)

# total_x = sum(
#             (sum(
#                 has_edge(G1, i, j) 
#                 for j in collect(1:n)
#             ) * x[i])
#             for i in collect(1:n)
#         )


# total = sum(
#             sum(has_edge(G1, i, j) 
#             for j in collect(1:n)
#         ) 
#         for i in (1:n)
#     )

# println(model)

# @constraint(model, total_x <= (total / 2))

@constraints(model, 
                begin
                    [i in collect(1:6)], sum(atribuicao_tarefas[i, j] for j in collect(1:6)) == 1
                    [i in collect(1:6)], sum(atribuicao_tarefas[j, i] for j in collect(1:6)) == 1
                end
)

println(model)
optimize!(model)

for i in collect(1:6)
    for j in collect(1:6)
        if (JuMP.value(atribuicao_tarefas[i,j]) == 0)
            print("0   ")
        else ()
            print(JuMP.value(atribuicao_tarefas[i,j]), " ")
        end
    end
    println()
end

for i in collect(1:6)
    for j in collect(1:6)
        print(matriz_tempos[i][j], "  ")
    end
    println()
end