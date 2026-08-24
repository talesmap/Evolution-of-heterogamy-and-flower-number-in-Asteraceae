#### ==========================================================================
#### 04_ggtree_plot.R
#### Plots the fan-shaped tree colored by the number of florets per capitulum
#### (ggtree) and adds bars with the log of the floret number (ggtreeExtra).
#### Requires objects from 01_prepare_data.R and 03_floret_number.R.
#### ==========================================================================

source("00_config.R")

phycut <- readRDS(file.path(obj_dir, "phycut.rds"))
flo    <- readRDS(file.path(obj_dir, "flo.rds"))
fl     <- readRDS(file.path(obj_dir, "fl.rds"))
ace    <- readRDS(file.path(obj_dir, "ace.rds"))

#### PREPARING TO USE GGTREE -----

tip_d <- data.frame(node = nodeid(phycut, names(fl)), trait = fl)

node_d <- data.frame(node = names(ace$ace), trait = ace$ace)

d <- rbind(tip_d, node_d)

d$node <- as.numeric(d$node)

tree <- full_join(phycut, d, by = "node")

#### PLOTTING WITH GGTREE -----------------------------------------------

ast_anc <- getMRCA(phy = phycut, tip = c("Helichrysum_italicum", "Barnadesia_parviflora"))

anc_value <- d$trait[which(d$node == ast_anc)]

real_value <- round(10 ^ anc_value, digits = 2)

my_palette <- c("#002F70", "#879FDB", "#BCA58A", "#DA8A8B", "#5F1415")

rec <- ggtree(tree, layout = "fan", ladderize = FALSE, size = 0.5) +
  geom_tree(aes(color = trait), continuous = "color", size = 0.5) +
  scale_color_gradientn(colours = my_palette,
                         name = "Flowers per capitulum", labels = c("1", "10", "100", "1000")) +
  theme(legend.position = "bottom",
        legend.box.spacing = unit(1, "pt"),
        legend.margin = margin(-20, 0, 0, 0)) +
  geom_nodelab(geom = "label", aes(label = real_value, subset = node == ast_anc), hjust = 1.5) +
  geom_point2(aes(subset = node == ast_anc), shape = 23, size = 1.5, fill = "red")

rec <- ggtree::rotate(rec, node = 972)

rec

#### adding a categorical ring showing whether floret number increased or ----
#### decreased relative to the ancestor (not executed) -----------------------

# library(ggnewscale)
#
# ttt <- as.data.frame(fl)
# ttt$new <- ifelse(10 ^ ttt$fl <= 11.8, "Decrease", "Increase")
#
# t <- as.data.frame(ttt$new)
#
# rownames(t) <- flo$Species
#
# rec2 <- rec + new_scale_fill()
#
# rec3 <- gheatmap(rec2, t, offset = .05, width = .03,
#                   colnames = FALSE, color = NA) +
#   scale_fill_manual(values = c("blue3", "firebrick4"),
#                      name = "Changes from \nAsteracea's MRCA")
#
# rec3

#### adding bars around the phylogeny with the log of the floret number ------

fig2 <- rec + geom_fruit(data = flo, geom = geom_bar,
                          mapping = aes(y = Species, x = log10(Floret)),
                          pwidth = 0.2,
                          orientation = "y",
                          stat = "identity",
                          axis.params = list(axis = "x",
                                              text.size  = 1.8,
                                              hjust      = 1,
                                              vjust      = 0.5,
                                              nbreak     = 3),
                          grid.params = list())

ggsave("fig2.tiff", plot = fig2, units = "in", height = 5, width = 5, dpi = 1200)
