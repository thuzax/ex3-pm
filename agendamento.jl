using JuMP
using Gurobi

tam_tarefas = 3
tam_operacoes = 3
tam_maquinas = 3

tarefas = collect(1:tam_tarefas)
operacoes = collect(1:tam_operacoes)
maquinas = collect(1:tam_maquinas)

maquinas_operacao = Dict(
    (tarefas[1], operacoes[1]) => maquinas[1],
    (tarefas[1], operacoes[2]) => maquinas[2],
    (tarefas[1], operacoes[3]) => maquinas[3],
    (tarefas[2], operacoes[1]) => maquinas[2],
    (tarefas[2], operacoes[2]) => maquinas[1],
    (tarefas[2], operacoes[3]) => maquinas[3],
    (tarefas[3], operacoes[1]) => maquinas[3],
    (tarefas[3], operacoes[2]) => maquinas[2],
    (tarefas[3], operacoes[3]) => maquinas[1]
)

tempo_operacao = Dict(
    (tarefas[1], maquinas[1]) => 1,
    (tarefas[1], maquinas[2]) => 1,
    (tarefas[1], maquinas[3]) => 1,
    (tarefas[2], maquinas[1]) => 1,
    (tarefas[2], maquinas[2]) => 2,
    (tarefas[2], maquinas[3]) => 1,
    (tarefas[3], maquinas[1]) => 2,
    (tarefas[3], maquinas[2]) => 1,
    (tarefas[3], maquinas[3]) => 2
)


tempo_maximo = 0
for i in collect(1:tam_tarefas)
    for j in collect(1:tam_maquinas)
        global tempo_maximo = tempo_maximo + tempo_operacao[tarefas[i], maquinas[j]]
    end
end

linha_do_tempo = collect(1:tempo_maximo)


model = Model(with_optimizer(Gurobi.Optimizer))

@variable(
            model, 
            tempo_maximo >= tempo_tarefas_operacoes[1:tam_tarefas, 1:tam_operacoes] >= 1, 
            Int
)

# @variable(
#             model, 
#             tempo_maximo >= tempo_tarefas_maquinas[1:tam_tarefas, 1:tam_maquinas] >= 1, 
#             Int
# )

@variable(
            model, 
            tempo_maximo >= tarefas_maquina_tempo[1:tam_maquinas, 1:tempo_maximo] >= 1, 
            Int
)


@variable(model, tempo_maximo >= maior_tempo >= 1, Int)

@objective(model, Min, maior_tempo)


# for i in collect(1:tam_tarefas)
#     for j in collect(1:tam_maquinas)
#         for o in collect(1:tam_operacoes)
#             if (maquinas_operacao[i, o] == maquinas[j])
#                 @constraint(model, tempo_tarefas_maquinas[i, j] == tempo_tarefas_operacoes[i, o])
#             end
#         end
#     end
# end


for i in collect(1:tam_tarefas)
    for j in collect(1:tam_operacoes-1)
            @constraint(model, 
                    tempo_tarefas_operacoes[i, j+1] >= tempo_tarefas_operacoes[i, j] + 1
            )
    end
end

# @constraints(model, 
#                 begin
#                     [i in collect(2:tam_tarefas)],
#                     tempo_tarefas_operacoes[1,tam_operacoes] >= tempo_tarefas_operacoes[i,tam_operacoes]
#                 end
# )

for j in collect(1:tam_operacoes)
    @constraints(model, 
                    begin
                        maior_tempo >= tempo_tarefas_operacoes[j, tam_operacoes]
                    end
    )
end

println(model)

optimize!(model)

for i in collect(1:tam_tarefas)
    for j in collect(1:tam_operacoes)
        print(JuMP.value(tempo_tarefas_operacoes[i,j]), " ")
    end
    println()
end

println("----------------------------")

for i in collect(1:tam_maquinas)
    for j in collect(1:tempo_maximo)
        print(JuMP.value(tarefas_maquina_tempo[i,j]), " ")
    end
    println()
end