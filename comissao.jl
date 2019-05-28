using LightGraphs, Plots, GraphPlot

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

gplot(G1, layout=GraphPlot.circular_layout , nodelabel=1:6)