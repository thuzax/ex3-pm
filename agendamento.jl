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

@variable(model, tempo >= 1, Int)
@variable(model, maquinas_realizando_operacao[1:tam_maquinas, 1:tempo_maximo , 1:tam_operacoes], Bin)


@objective(model, Min, tempo)


println(model)


# Adiciona restrições de exclusividade
for i in collect(1:tam_maquinas)
    for j in collect(1:tempo_maximo)
        for k in collect(1:tam_operacoes-1)
            for l in collect(k+1:tam_operacoes)
                @constraint(model, maquinas_realizando_operacao[i,j,k] + maquinas_realizando_operacao[i,j,l] <= 1)
            end
        end
    end
end

# Adiciona restrições de ordem
# for t in collect(1:tam_tarefas)
#     for i in collect(1:tam_operacoes-1)
#         for j in collect(i+1:tam_operacoes)
#             maquinas_realizando_operacao[maquinas_operacao[t,i], ]
#         end
#     end
# end


println(model)




# @constraints(model, 
#                 begin
#                     [i in collect(1:tam_maquinas)], 
#                     [j in collect(1:tempo_maximo)], 
#                     [k in collect(1:tam_operacoes)], 
#                     [l in collect(k+1:tam_operacoes)], 
#                     maquinas_realizando_operacao[i,j,k] + maquinas_realizando_operacao[i,j,l] <= 1
#                 end
#             )

# @constraint(model, capacidade, sum(x[i]*p[i] for i in n) <= C)

# @constraints(model, 
#     begin

#     end
# )

# optimize!(model)

# println("Peso total = ", peso_total)

# println("Função ótima: ", JuMP.objective_value(model))

