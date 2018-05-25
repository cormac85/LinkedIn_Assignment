# LinkedIn_Assignment
This is an analysis for a LinkedIn interview for a data science position. 

The best answer I could get was:

| member_id_1  | member_id_2  | Number of Common Connections  |
| -----------------|:-----------------:| --------------------------------------:|
| 99476             | 84644              | 163                                           |

The number of common connections is probably pessimistic, as this answer was taken from two random samples of  
N = 500,000  relationships out of a total 10,000,000.

## Solution Overview
The solution I'm using here is using R and has two broad steps with some details to follow. 

1. Calculate the friends of friends (2nd degree only) for each unique member_id in the dataset using the `igraph` package.
2. For each unique relationship, compare a list of friends for both members of the relationship and count matches. 
Use indexed data frames from the `data.tables` package.

The solution can be seen under /LinkedIn Exploration/get_common_connections.R

### Scaling
Unfortunately this solution was not very fast and did not scale well on one machine, with this approach and using R. I made 
some estimates of time it would take using a linear model (see /LinkedIn Exploration/lm_predictions, time in seconds), 
it seems a full run could take several days.

Memory was an issue as both a table of edges, a table of results AND a very large list of graphs had to be generated. There 
are certainly some optimisations (remove duplicate relationships, remove objects once used etc.) that could be made here
but computation time is probably a larger issue.

Scaling the solution to 3rd or 4th degree friends of friends could be prohibitively expensive at this sort of scale. Again sampling would 
almost certainly be needed, as discussed in the next section.

### Solution With Sampling 
The memory and computational constraints forced me to us multiple samples to approach an approximate solution. The sampling 
method used is simply random samples of the edges (relationships) of the network before converting them to an `igraph`
object to do the "friend of friend" calculation.

It seems this approach is not ideal to approximate properties of the full netowrk, and there are 
[better sampling methods available](https://cs.stanford.edu/~jure/pubs/sampling-kdd06.pdf) such as node-based sampling,
rather than the edge-based sampling that I have done here.

## Proposed Improvements

### Friends of Friends
Although R is notoriously slow for larger datasets, I don't think there would be much performance to gain by switching to 
Python for the friend of friend calculation since `igraph` is available in both languages and is based on the same C libraries.
Some [benchmarking](https://graph-tool.skewed.de/performance) shows `igraph` in python performing very well in comparison to other graph analysis tools.

### Direct Friends Lookup
The second part of the solution seemed to be "balooning" in time quite quickly as the number of sampled relatioships increased. I used 
`data.tables` package for this, with an added index. This is probably one of the fastest ways to do data filtering like this in R.
Playing with the indexes might also help here, or using an external database for the queries (see next section). 

### Graph Databases
With the time frame involved I was not able to explore graph databases such as Neo4j to see if the naturally graph-based queries 
could be done faster. Given the nature of the queries in the proposed solution it would be worth exploring this approach.
