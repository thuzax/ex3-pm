using JuMP
using Gurobi

T = [0 4 3 6; 7 8 6 8; 2 3 1 8] # Tabuleiro
(n,m) = size(T)

model = Model(with_optimizer(Gurobi.Optimizer))

@variable(model, 1 >= tabuleiro[1:n, 1:m] >= 0, Int)

@objective(model, Min, 
                sum(
                    sum(
                        tabuleiro[i,j] * T[i,j]
                        for j in collect(1:m)
                    )
                    for i in collect(1:n)
                )
)

println(model)

for i in collect(1:n-1)
    for j in collect(1:m-1)
        @constraint(model, tabuleiro[i+1, j] + tabuleiro[i,j+1] + tabuleiro[i, j] <= 2)
        @constraint(model, tabuleiro[i+1, j] + tabuleiro[i,j+1] - tabuleiro[i, j] >= 0)
        @constraint(model, tabuleiro[i+1, j] + tabuleiro[i,j+1] - tabuleiro[i, j] <= 1)
    end
end

for i in collect(1:n-1)
    @constraint(model, tabuleiro[i+1, m] - tabuleiro[i, m] >= 0)
end

for i in collect(1:m-1)
    @constraint(model, tabuleiro[n, i+1] - tabuleiro[n, i] >= 0)
end

@constraints(model, 
                begin
                    tabuleiro[1, 1] == 1
                    tabuleiro[n, m] == 1
                end
)

println(model)

optimize!(model)

for i in collect(1:n)
    for j in collect(1:m)
        if (JuMP.value(tabuleiro[i, j]) == 0)
            print("0   ")
        else ()
            print(JuMP.value(tabuleiro[i, j]), " ")
        end 
    end
    println()
end