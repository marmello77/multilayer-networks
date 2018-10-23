####################################################################
#####                                                           ####
##### SCRIPT FOR DRAWING AND ANALYZING MULTILAYER NETWORKS IN R ####
#####                                                           ####       
####################################################################


##### Ecological Synthesis Lab (SintECO)
##### https://marcomellolab.wordpress.com
##### Authors: Marco Mello & Renata Muylaert
##### E-mail: marmello@gmail.com 
##### Script: Drawing and analyzing multilayer networks in R
##### How to cite: Mello MAR & Muylaert RL. 2017. Script for drawing and analyzing
##### multilayer networks in R. Available at https://marcomellolab.wordpress.com.
##### Published on November 23rd, 2017 (English version).
##### Run in R 3.4.2 (2017-09-28) -- "Short Summer"

##### Disclaimer: You may use this script freely for non-comercial
##### purposes at your own risk. We assume no responsibility or
##### liability for the use of this software, convey no license
##### or title under any patent, copyright, or mask work right
##### to the product. We reserve the right to make changes in
##### the software without notification. 
##### We also make no representation or warranty that such
##### application will be suitable for the specified use without
##### further testing or modification.

##### Obs: If this script helps you produce any academic work
##### (paper, book, chapter, dissertation etc.), please
##### acknowledge the authors and cite the source.


#############################################


#### Step 1 ####
# Set the working directory automatically to the source file location 

library(rstudioapi) # load it
current_path <- getActiveDocumentContext()$path 
setwd(dirname(current_path ))
print( getwd() )


#### Step 2 ####
# Clear all objects and load the required packages

rm(list=ls())
library("igraph")
library("bipartite")
library("ggplot2")
library("network") 
library("png")
library("plyr")
library("reshape2")


#### Step 3 ####
# Example file: two adjacency matrices: antagonistic and mutualistic
# interactions between small mammals and plants in an urban protected
# area in Brazil (Genrich et al 2017, Oikos:
# http://dx.doi.org/10.1111/oik.03825)
# NOTE ABOUT THE INPUT FILES
# How are your INPUT data formatted: edge list or adjacency matrix?
# You need to know it, before choosing the data import 
# method (1 or 2).
# Method 1 will save multilayer network as the object multilayer1
# Method 2 will save multilayer network as the object multilayer2
# Method 2 is preferable, as you can import a file in which you 
# can include all the addtional data you want (e.g., species
# traits) in the node and edge lists.

#### METHOD 1 ####
# Import the data, method 1: from adjacency matrices

# Using the example files provided with this script
antagonistic <- read.table("antagonistic.txt", head=TRUE)
class(antagonistic)
mutualistic <- read.table("mutualistic.txt", head=TRUE)
class(mutualistic)

# Check the data O^O
antagonistic 
mutualistic

# Transform the bipartite matrices into edge lists

### Layer 1: antagonistic
antagonistic2 = cbind.data.frame(reference=row.names(antagonistic),antagonistic)
str(antagonistic2)
antagonistic_list = melt(antagonistic2, na.rm = T)
colnames(antagonistic_list) = c("animals", "plants", "weight")
antagonistic_list[,1]=as.character(paste(antagonistic_list[,1]))
antagonistic_list[,2]=as.character(paste(antagonistic_list[,2]))
head(antagonistic_list)

# Exclude all edges with value 0 (zero)
antagonistic_list2 <- subset(antagonistic_list, weight > 0)
head(antagonistic_list2)

# Create the edge list
links_ant = antagonistic_list2
head(links_ant)

# Creata the node list of the antagonistic layer
nodes_ant <- unique(data.frame(nodes = c(antagonistic_list2[,1], antagonistic_list2[,2])))
head(nodes_ant)

# Check the dimensions of the node list
dim(nodes_ant[1])

# Create a new column in the node list to tell which
# nodes are the animals and the plants
# They are the rows and columns of the original matrix
nodes_ant$taxon = c((rep("Animal",8)), rep("Plant", 33)) 
head(nodes_ant)

# Create an igraph object based on the node and edge lists
antagonistic3 <- graph_from_data_frame(d=links_ant, vertices=nodes_ant, directed=F) 
class(antagonistic3)
str(antagonistic3)
head(antagonistic3)
antagonistic3

#Add information on the two-mode strucutre
V(antagonistic3)$type <- V(antagonistic3)$name %in% links_ant[,1]
V(antagonistic3)$type = nodes_ant[,2]
antagonistic3

# Create a column in the edge for the layers
# In the example file, the layers are interaction types
antagonistic_list2$layer = "antagonistic"

### Layer 2: mutualistic
mutualistic2 = cbind.data.frame(reference=row.names(mutualistic),mutualistic)
str(mutualistic2)
mutualistic_list = melt(mutualistic2, na.rm = T)
colnames(mutualistic_list) = c("animals", "plants", "weight")
mutualistic_list[,1]=as.character(paste(mutualistic_list[,1]))
mutualistic_list[,2]=as.character(paste(mutualistic_list[,2]))
head(mutualistic_list)

# Exclude all edges with value 0 (zero)
mutualistic_list2 <- subset(mutualistic_list, weight > 0)
head(mutualistic_list2)

# Create the edge list
links_mut = mutualistic_list2
head(links_mut)

# Creata the node list of the mutualistic layer
nodes_mut <- unique(data.frame(nodes = c(mutualistic_list2[,1], mutualistic_list2[,2])))
head(nodes_mut)

# Check the dimensions of the node list
dim(nodes_mut[1])

# Create a new column in the node list to tell which
# nodes are the animals and the plants
# They are the rows and columns of the original matrix
nodes_mut$taxon = c((rep("Animal",8)), rep("Plant", 20)) 
head(nodes_mut)

# Create an igraph object based on the node and edge lists
mutualistic3 <- graph_from_data_frame(d=links_mut, vertices=nodes_mut, directed=F) 
class(mutualistic3)
str(mutualistic3)
head(mutualistic3)
mutualistic3

#Add information on the two-mode strucutre
V(mutualistic3)$type <- V(mutualistic3)$name %in% links_mut[,1]
V(mutualistic3)$type = nodes_mut[,2]
mutualistic3

# Create a column in the edge for the layers
# In the example file, the layers are interaction types
mutualistic_list2$layer = "mutualistic"

### Bind the layers and build the multilayer network
links1 = rbind(antagonistic_list2, mutualistic_list2)
nodes1 = rbind(nodes_ant, nodes_mut)
nodes1 = unique(nodes1)
dim(nodes1)
multilayer1 <- graph_from_data_frame(d=links1, vertices=nodes1, directed=F) 
class(multilayer1)
head(multilayer1)
multilayer1

write.table(links1, "links1.txt", sep="\t", quote=F, row.names = FALSE)
write.table(nodes1, "nodes1.txt", sep="\t", quote=F, row.names = FALSE)

#### METHOD 2 ####
# Import the data, method 2: from edge and node lists
# Import vertices (nodes) and edges (links) that you already have in
# your working directory 
# You may create those lists with as many additional data as
# you want. Or you may just use the files exported using
# the method 1

links2 = read.table("links1.txt", header= TRUE, sep="\t")
nodes2 = read.table("nodes1.txt", header= TRUE, sep="\t")

head(links2)
head(nodes2)

# Create the multilayer network based on the node and link lists
multilayer2 <- graph_from_data_frame(d=links2, vertices=nodes2, directed=T) 

# Notice that, using the example files, the two multilayer
# networks are actually the same
str(multilayer2)
str(multilayer1)

# So you may work with either of the two networks in
# the following steps
# multilayer1 <- multilayer2


#### Step 4: Drawing ####


# Draw the graph with node colors by taxon
# Data from the example file (import using method 1)

# Choose the drawing method (layout) and save it as an object 
l <- layout_nicely(multilayer1)

#If the nodes are overlapping, try expanding the graph
my.layout <- layout_with_fr(multilayer1)
my.layout <- norm_coords(my.layout, ymin=-1, ymax=1, xmin=-1, xmax=1)
plot(multilayer1, rescale=F, layout=my.layout*3)

# Set node colors by taxon
V(multilayer1)$color = nodes1$taxon
V(multilayer1)$color = gsub("Animal","#E6B246",V(multilayer1)$color)
V(multilayer1)$color = gsub("Plant","#A3D642",V(multilayer1)$color)

#Set link colors by layer
E(multilayer1)$color = links1$layer
E(multilayer1)$color = gsub("antagonistic","#D05B9B",E(multilayer1)$color)
E(multilayer1)$color = gsub("mutualistic","#5770AE",E(multilayer1)$color)

# Transform arcs into edges
E(multilayer1)$arrow.mode = 0

# Export the graph as a PNG image
# CAUTION: study the plotting parameters, so you can
# customize your own graph
plot.new()

png(filename= "multilayer_example.png", res= 300, height= 3000, width= 4700)
par(mfrow=c(1,1),mar=c(1,1,3,17))
#Use a function for avoiding overlap between edges of different layers in the graph
curves = curve_multiple(multilayer1)
plot(multilayer1, 
     vertex.color = V(multilayer1)$color, 
     vertex.frame.color= V(multilayer1)$color, 
     vertex.shape = V(multilayer1)$shape, 
     vertex.size=10,
     vertex.label=V(multilayer1)$name,
     vertex.label.color="white",
     vertex.label.cex=.5,
     edge.color = E(multilayer1)$color, 
     edge.width = E(multilayer1)$weight/2,
     edge.curved=curves, 
     layout=l)

# Create a legend for the plot 
legend(x = 1.3,y = 0.9, legend = c("Animals", "Plants"), 
       pch = c(15,16),  title="Taxa", 
       text.col = "gray20", title.col = "black", box.lwd = 0,
       cex = 2, col=c("#E6B246", "#A3D642"))
legend(x = 1.3,y = 0.1, legend = c("Antagonistic", "Mutualistic"),
       fill = c("#D05B9B", "#5770AE"), 
       title="Interaction types (layers)",
       text.col = "gray20", title.col = "black", box.lwd = 0, cex = 2)
title(main = "Plant-frugivore multilayer network", cex.main=2)
par(mfrow=c(1,1))

dev.off()


#### Suggested readings ####


# Boccaletti S, Bianconi G, Criado R, et al (2014) The structure and dynamics of multilayer networks. Phys Rep 544:1–122. doi: 10.1016/j.physrep.2014.07.001

# Costa F V., Mello MAR, Bronstein JL, et al (2016) Few Ant Species Play a Central Role Linking Different Plant Resources in a Network in Rupestrian Grasslands. PLoS One 11:e0167161. doi: 10.1371/journal.pone.0167161

# Cozzo E, Arruda GF, Rodrigues FA, Moreno Y (2016) Multilayer networks: metrics and spectral properties. In: Garas A (ed) Interconnected networks. Springer International Publishing, Cham, pp 17–35

# Genrich CM, Mello MAR, Silveira FAO, et al (2017) Duality of interaction outcomes in a plant-frugivore multilayer network. Oikos 126:361–368. doi: 10.1111/oik.03825

# Kivela M, Arenas A, Barthelemy M, et al (2014) Multilayer networks. J Complex Networks 2:203–271. doi: 10.1093/comnet/cnu016

# Kefi S, Miele V, Wieters EA, et al (2016) How Structured Is the Entangled Bank? The Surprisingly Simple Organization of Multiplex Ecological Networks Leads to Increased Persistence and Resilience. PLOS Biol 14:e1002527. doi: 10.1371/journal.pbio.1002527

# Pilosof S, Porter MA, Pascual M, Kefi S (2017) The multilayer nature of ecological networks. Nat Ecol Evol 1:101. doi: 10.1038/s41559-017-0101

# Pocock MJO, Evans DM, Fontaine C, et al (2016) The Visualisation of Ecological Networks, and Their Use as a Tool for Engagement, Advocacy and Management. In: Woodward G, Bohan DA (eds) Advances in Ecological Research, 1st edn. Academic Press, Cambridge, pp 41–85
