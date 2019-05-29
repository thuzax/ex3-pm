# using LightGraphs
# using Plots
# using GraphPlot

using JuMP
using Gurobi

numero_de_maquinas = 3
numero_de_tarefas = 10
tempo_tarefas = collect(1:numero_de_tarefas)


# tarefas = collect(1:numero_de_trabalhadores)

model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= atribuicao_tarefas[1:numero_de_maquinas, 1:numero_de_tarefas] >= 0, Int)

@objective(model, Min,
                sum(
                    atribuicao_tarefas[1, i] * tempo_tarefas[i]
                    for i in collect(1:numero_de_tarefas) 
                )
)


@constraints(model, 
                begin
                    sum(atribuicao_tarefas[2, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas)) <= sum(atribuicao_tarefas[1, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas))
                    sum(atribuicao_tarefas[3, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas)) <= sum(atribuicao_tarefas[1, j]*tempo_tarefas[j] for j in collect(1:numero_de_tarefas))
                    [i in collect(1:numero_de_tarefas)], sum(atribuicao_tarefas[j, i] for j in collect(1:numero_de_maquinas)) == 1                    
                end
)


print(model)

# println(model)
optimize!(model)

for i in collect(1:numero_de_maquinas)
    for j in collect(1:numero_de_tarefas)
        if (JuMP.value(atribuicao_tarefas[i,j]) == 0)
            print("0   ")
        else ()
            print(JuMP.value(atribuicao_tarefas[i,j]), " ")
        end
    end
    println()
end