# For playing with igraph objects

library(igraph)

from <- sample(LETTERS, 50, replace=T)
to <- sample(LETTERS, 50, replace=T)
rel <- data.frame(from, to)
head(rel)    

### lets plot the data
g <- graph.data.frame(rel)
summary(g)
plot(g, vertex.label=LETTERS, edge.arrow.size=.1)


## find the 2nd degree connections
d1 <- unlist(neighborhood(g, 1, nodes="F", mode="out"))
d2 <- unlist(neighborhood(g, 2, nodes="F", mode="out"))
d1;d2;
setdiff(d2,d1)

V(g)[setdiff(d2,d1)]


####


# Name of vertex
V(g)$name[19]
# Name of vertex plus neighbours degree 1
V(make_ego_graph(g, 1, mode= "out")[[19]])$name
# Name of vertex plus neighbours degree 2
V(make_ego_graph(g, 2, mode= "out")[[19]])$name
V(make_ego_graph(g, 2, mode= "out", mindist = 2)[[19]])$name

ego_size(g, order = 2, mode = "out", mindist = 2)

# Turns out each (small) vertex object is about 1kB in size, this might be sutainable.
# There are 200,000 verteces in dataset, by say 2kB is 400 mB. I suspect sparseness
# of dataset will mean many of these will have no friends of friends and can be removed. 
make_ego_graph(g, order = 2, mode = "out", mindist = 2)[[19]] %>% object.size()
ego(g, order = 2, mode = "out", mindist = 2)[[19]] %>% object.size()