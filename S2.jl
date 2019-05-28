using JuMP
using Gurobi


tam = 4

posicoes = collect(1:tam)

model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= tabuleiro[1:tam, 1:tam] >= 0, Int)

# @variable(model, a >= 0, Int)

# @objective(model, Max, sum(sum(tabuleiro[i, j] for i in posicoes) for j in posicoes)) 
@objective(model, Max,  
                sum(
                    sum(
                        tabuleiro[i,j]
                        for j in posicoes
                    )
                    for i in posicoes
                )
)

# println(model)

for i in posicoes[2:tam-1]
    for j in posicoes[2:tam-1]
        @constraint(model, 
            2 * tabuleiro[i, j] + 1 == tabuleiro[i-1, j] + tabuleiro[i+1, j] + tabuleiro[i, j-1] + tabuleiro[i, j+1]
        )
    end
end



for i in posicoes[2:tam-1]
    @constraints(model, 
        begin
            tabuleiro[1, i] + 1 == tabuleiro[1, i+1] + tabuleiro[1, i-1] + tabuleiro[2, i]
            tabuleiro[tam, i] + 1 == tabuleiro[tam, i+1] + tabuleiro[tam, i-1] + tabuleiro[tam-1, i]
            tabuleiro[i, 1] + 1 == tabuleiro[i, 2] + tabuleiro[i-1, 1] + tabuleiro[i+1, 1]
            tabuleiro[i, tam] + 1 == tabuleiro[i, tam-1] + tabuleiro[i-1, tam] + tabuleiro[i+1, tam]
        end
    )
end


@constraints(model, 
begin
    tabuleiro[1,2] + tabuleiro[2,1] == 1
    tabuleiro[tam,2] + tabuleiro[tam-1,1] == 1
    tabuleiro[1,tam-1] + tabuleiro[2,tam] == 1
    tabuleiro[tam-1,tam] + tabuleiro[tam,tam-1] == 1
end
)

println(model)
optimize!(model)

for i in posicoes
    for j in posicoes
        if (JuMP.value(tabuleiro[i, j]) == 0)
            print("＋ ")
        elseif (JuMP.value(tabuleiro[i, j]) == 1)
            print("♡  ")
        end 
    end
    println()
end