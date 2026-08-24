#### ==========================================================================
#### 01_prepare_data.R
#### Reads the phylogeny and the data, checks the overlap between them, and
#### generates the "red" (data) and "phycut"/"tree" (phylogeny) objects used
#### in the next steps. Saves everything as .rds for the other scripts to reuse.
#### ==========================================================================

source("00_config.R")

#### PHYLOGENY AND DATA --------------

phy  <- read.tree(tree_file)
data <- read_excel(data_file)

#### SETTING ROW NAMES ----------------

rownames(data) <- data$Species

#### CHECKING OVERLAP -------

sb <- name.check(phy, data)

length(setdiff(data$Species, sb$data_not_tree)) # number of species considered

#### GETTING DATA AND PHYLOGENY RESTRICTED TO THE OVERLAP --------

## data
match <- match_dataphy(Family ~ Species, data = data, phy = phy)

sp <- match$phy$tip.label

red <- subset(data, Species %in% sp)

rownames(red) <- red$Species

## phylogeny
phycut <- drop.tip(phy, sb$tree_not_data)

##### IS EVERYTHING OK WITH THE LENGTHS? ----------------

length(phycut$tip.label) == length(red$Species)

phycut$tip.label %in% rownames(red)

rownames(red) <- red$Species

## version of the phylogeny without node labels, used in the reconstructions
tree <- phycut
tree$node.label <- NULL

#### SAVING OBJECTS FOR THE NEXT STEPS ---------------------------

saveRDS(red,    file.path(obj_dir, "red.rds"))
saveRDS(phycut, file.path(obj_dir, "phycut.rds"))
saveRDS(tree,   file.path(obj_dir, "tree.rds"))


