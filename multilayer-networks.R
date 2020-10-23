################################################################################
##### A tutorial on how to draw and analyze multilayer networks in R.
##### Ecological Synthesis Lab (SintECO).
##### https://marcomellolab.wordpress.com.
##### Authors: Marco Mello & Renata Muylaert.
##### E-mail: marmello@usp.br. 
##### See README for further info.
##### https://github.com/marmello77/multilayer-networks/blob/master/README.md
################################################################################


################################################################################
##### SUMMARY
################################################################################


# 1. Get ready
# 2. Attention
# 3. Starting with incidence matrices
# 4. Starting with vertex and edge lists
# 5. Draw the network


################################################################################
##### 1. Get ready
################################################################################


# Warning: 

# There is no single magic way to draw all kinds of networks. 
# There are several network drawing algorithms implemented in different
# R packages and stand-alone software. Study their logic and algorithms, 
# see some papers in which they were used. Think it through, and only 
# then decide which drawing method to use in your study. For guidelines
# on which drawing algorithm to choose, see the suggested readings.

# The elements of a network may be called nodes or vertices. Depending on the
# software or package used, you'll see one term or the other.

# The relationships between the elements of a network may be called links or
# edges. Depending on the software or package used, you'll see one term or
# the other.

##############################

# Set the working directory automatically to the source file location 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Remove all previous objects
rm(list= ls())

# Load the required packages
library(bipartite)
library(dplyr)
library(igraph)
library(reshape2)
library(tidyverse)


################################################################################
##### 2. Attention
################################################################################


# The best way to work with multilayer networks is by using vertex and edge
# lists, because you can easily add several attributes to those lists and
# input them directly in R.

# However, in most cases, ecologists organize their interaction data as
# incidence matrices (AxB), in which the rows represent one class of vertices
# and the columns represent the other class. Those classes may represent
# pollinators and plants, for instance.

# If your data are organized as incidence matrices, go to section 3.

# Otherwise, if your data are organized as edge and vertex lists, go to
# section 4.


################################################################################
##### 3. Starting with incidence matrices
################################################################################


# OK, we are going to work with a multilayer network (net1) composed of two
# layers: one with antagonistic interactions and the other with mutualistic 
# interactions. These layers are represented by two matrices with equal
# dimensions and exactly the same label order for rows and columns. This
# kind of multilayer network is known as multiplex network, as all vertices
# are represented in all layers, and are connected to their counterparts
# through interlayer edges.

#Import the data in matrix format, ready to be used with bipartite
net1an_bi <- as.matrix(read.delim("data/net1an.txt", row.names=1))
net1mu_bi <- as.matrix(read.delim("data/net1mu.txt", row.names=1))

#Inspect the incidence matrices
class(net1an_bi)
dim(net1an_bi)
min(net1an_bi)
max(net1an_bi)

class(net1mu_bi)
dim(net1mu_bi)
min(net1mu_bi)
max(net1mu_bi)

# Let's take a closer look at these matrices. See that they are like 
# reflections in a mirror, but with different values in their cells.

# Antagonistic matrix:
net1an_bi

# Mutualistic matrix:
net1mu_bi

#Transform these matrices into graphs formatted for igraph
net1an_ig <- graph_from_incidence_matrix(net1an_bi, directed = F, weighted = TRUE) 
net1mu_ig <- graph_from_incidence_matrix(net1mu_bi, directed = F, weighted = TRUE) 

#Inspect the graphs
class(net1an_ig)
net1an_ig
attributes(E(net1an_ig))
attributes(V(net1an_ig))

class(net1mu_ig)
net1mu_ig
attributes(E(net1mu_ig))
attributes(V(net1mu_ig))

# At this point, you could work already with the matrices in the package
# bipartite or with the graphs in the package igraph. Nevertheless, you
# would be working with separate layers, not with a true multilayer network.
# Let's work on combining these layers.

#Transform the matrices into a combined edge list
net1list <- bind_rows(
        as.data.frame(as.table(net1an_bi)),
        as.data.frame(as.table(net1mu_bi)),
        .id = "layer") %>%
        
        filter(Freq != 0) %>%
        select(
                from = Var1,
                to = Var2,
                layer,
                Freq)

#Check the data
head(net1list)

#Give the columns informative names
colnames(net1list) <- c("animals", "plants", "layer", "weight")

#Check the data
head(net1list)

#Transform the combined edge list into an igraph object
net1_multi <- graph_from_data_frame(net1list, directed = FALSE)

#Check the multilayer network
net1_multi
attributes(V(net1_multi))
attributes(E(net1_multi))
V(net1_multi)$name
V(net1_multi)$taxon
V(net1_multi)$type
E(net1_multi)$layer
E(net1_multi)$weight

# Create a new edge attribute with info on interaction types (layers)
E(net1_multi)$layer <- ifelse(E(net1_multi)$layer == "1",
                              "antagonistic",
                              "mutualistic")

# Check the layers
E(net1_multi)$layer

# Add information on the bipartite structure by assigning vertex classes
V(net1_multi)$type = c(rep(0, nrow(net1an_bi)), 
                       rep(1, ncol(net1an_bi)))

# Check the network's attributes and the vertex classes
net1_multi
V(net1_multi)$type

# This network contains 3 taxonomic groups: marsupials, rodents, and plants.
# So let's recover this information now.
# Create a new vertex attribute with the taxonomic groups
V(net1_multi)$taxon = c(c("Rodents", "Rodents", "Marsupials", "Marsupials",
                          "Marsupials", "Rodents", "Rodents", "Marsupials",
                          "Rodents"),
                        rep("Plants", ncol(net1an_bi)))

# Check the taxonomic groups
V(net1_multi)$taxon


# Congrats!
# Now you can skip to step 5 and draw the network.


################################################################################
##### 4. Starting with vertex and edge lists
################################################################################


# We are going to work with the same network (net1) as in section 3. But here
# we assume that the data are organized as edge and vertex lists. You'll see
# that working with this format is much, much easier. Seriously easier.
# Furthermore, lists are consistent with the "tidy data format", which is
# much better for management and analysis. Read this manifesto:
# https://cran.r-project.org/web/packages/tidyverse/vignettes/manifesto.html

# Import the edge and vertex lists
nodes = read.delim("data/net1nodes.txt", header = T)
links = read.delim("data/net1links.txt", header = T)

# Let's take a look of those objects. See that, in addition to the core data
# (i.e., the nodes and the links), they contain attributes. That's a huge
# advantage of the list format: you can include as many edge and vertex
# attributes as you want in your lists. Those attributes can then be easily
# correlated with the strictu sensu network information.
head(nodes)
head(links)

#Create the multilayer network by combining the lists as an igraph object
net1_multi <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 

#Check the multilayer network
net1_multi
attributes(V(net1_multi))
attributes(E(net1_multi))
V(net1_multi)$name
V(net1_multi)$taxon
V(net1_multi)$type
E(net1_multi)$layer
E(net1_multi)$weight

# Convert the graph to undirected
net1_multi <- as.undirected(net1_multi, mode = "each")

#Check the multilayer network 
net1_multi

# Add information on the bipartite structure by assigning vertex classes (type)
V(net1_multi)$type <- c(rep(0, length(which(nodes$taxon=="Animal"))),
                        rep(1, length(which(nodes$taxon=="Plant"))))

# Check the network's attributes and the vertex classes
net1_multi
V(net1_multi)$type

# This network contains 3 taxonomic groups: marsupials, rodents, and plants.
# So let's recover this information now.
# Create a new vertex attribute with the taxonomic groups
V(net1_multi)$taxon = c(c("Rodents", "Rodents", "Marsupials", "Marsupials",
                          "Marsupials", "Rodents", "Rodents", "Marsupials",
                          "Rodents"),
                        rep("Plants", ncol(net1an_bi)))

# Check the taxonomic groups
V(net1_multi)$taxon

# Congrats!
# Now you can go to step 5 and draw the network.


################################################################################
##### 5. Draw the network
################################################################################


# Either if you started with incidence matrices or with edge and vertex lists,
# now you have an object named "net1_multi". We are going to just do some 
# adjustments, so the graph looks better and is more informative when
# plotted.


# Set vertex colors by taxonomic group
V(net1_multi)$color = V(net1_multi)$taxon
V(net1_multi)$color = gsub("Marsupials","gold",V(net1_multi)$color)
V(net1_multi)$color = gsub("Rodents","purple",V(net1_multi)$color)
V(net1_multi)$color = gsub("Plants","darkgreen",V(net1_multi)$color)

# Check vertex colors
V(net1_multi)$color

# Set edge colors by layer
E(net1_multi)$color = E(net1_multi)$layer
E(net1_multi)$color = gsub("antagonistic", "red",E(net1_multi)$color)
E(net1_multi)$color = gsub("mutualistic","blue",E(net1_multi)$color)

# Check edge colors
E(net1_multi)$color

# Adjust a function to set edge curvatures, so the edges do not overlap
curves = curve_multiple(net1_multi)

# Plot the network as an energy--minimization graph and
# export the output as a PNG image
png(filename= "figures/net1.png", #name the file
    units = "px", #set the units to pixels
    res= 300, #set the resolution in dpi (most journals require at least 300)
    height= 3000, width= 3000) #set the dimensions in the chosen unit

plot(net1_multi, #the network you want to plot
     layout = layout_nicely, #choose a drawing layout for the graph
     vertex.shape = "circle", #choose a vertex shape
     vertex.size = 8, #set vertex size
     vertex.color = V(net1_multi)$color, #set vertex colors
     vertex.frame.color = NA, #set vertex border color
     vertex.label.cex = 0.5, #set vertex label size
     vertex.label.color = "white", #set vertex label color
     edge.width = E(net1_multi)$weight/2, #set edge width and adjust it
     edge.color = adjustcolor(E(net1_multi)$color, alpha = 0.3), #set edge color
     edge.curved = curves) #set edge curvature
# You can set many other arguments. Check this function's help

dev.off()


#################################### END #######################################

