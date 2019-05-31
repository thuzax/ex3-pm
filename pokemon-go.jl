# using LightGraphs
# using Plots
# using GraphPlot

using JuMP
using Gurobi

Pokestops = Dict(
    1 => (523, 418),
    2 => (527, 566),
    3 => (435, 603),
    4 => (386, 660),
    5 => (346, 692),
    6 => (431, 730),
    7 => (419, 818),
    8 => (389, 892),
    9 => (384, 902),
    10 => (383, 913),
    11 => (347, 520),
    12 => (332, 330),
    13 => (165, 374),
    14 => (196, 198),
    15 => (187, 108),
    16 => (210, 63)
)


# Quatidade de pontos
n = 16

# Distancia Euclidiana
EucD(x,y) = sqrt((x[1] - y[1])^2 + (x[2] - y[2])^2)

# Matriz de custos
c = [EucD(Pokestops[i],Pokestops[j]) for i=1:n, j=1:n]
println(c)


# numero_de_maquinas = 3
# numero_de_tarefas = 10
# tempo_tarefas = collect(1:numero_de_tarefas)


# # tarefas = collect(1:numero_de_trabalhadores)

env = Gurobi.Env()
model = Model(with_optimizer(Gurobi.Optimizer, env))
setparams!(env, TimeLimit=120)

# @variable(model, 1 >= atribuicao_tarefas[1:numero_de_maquinas, 1:numero_de_tarefas] >= 0, Int)


# @objective(model, Min,
#                 sum(
#                     atribuicao_tarefas[1, i] * tempo_tarefas[i]
#                     for i in collect(1:numero_de_tarefas) 
#                 )
# )


# @constraints(model, 
#                 begin
#                     sum(atribuicao_tarefas[2, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas)) <= sum(atribuicao_tarefas[1, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas))
#                     sum(atribuicao_tarefas[3, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas)) <= sum(atribuicao_tarefas[1, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas))
#                     [i in collect(1:numero_de_tarefas)], sum(atribuicao_tarefas[j, i] for j in collect(1:numero_de_maquinas)) == 1                    
#                 end
# )


# print(model)

# # println(model)
# optimize!(model)

# for i in collect(1:numero_de_maquinas)
#     for j in collect(1:numero_de_tarefas)
#         if (JuMP.value(atribuicao_tarefas[i,j]) == 0)
#             print("0   ")
#         else ()
#             print(JuMP.value(atribuicao_tarefas[i,j]), " ")
#         end
#     end
#     println()
# end

# for i in collect(1:6)
#     for j in collect(1:6)
#         print(matriz_tempos[i][j], "  ")
#     end
#     println()
# end