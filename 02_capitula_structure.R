#### ==========================================================================
#### 02_capitula_structure.R
#### Phylogenetic signal and ancestral reconstruction (simmap) of capitulum
#### structure (Homogamous x Heterogamous). Requires objects from
#### 01_prepare_data.R.
#### ==========================================================================

source("00_config.R")

red    <- readRDS(file.path(obj_dir, "red.rds"))
phycut <- readRDS(file.path(obj_dir, "phycut.rds"))
tree   <- readRDS(file.path(obj_dir, "tree.rds"))

#### PHYLOGENETIC RECONSTRUCTIONS ------- HETEROGAMY AND HOMOGAMY -------------

#### phylogenetic signal -------------

red_ps <- red %>%
  filter(Capitula_structure %in% c("Homogamous", "Heterogamous"))

red_ps <- as.data.frame(red_ps)
rownames(red_ps) <- red_ps$Species

cd <- comparative.data(phy = tree,
                        data = red_ps,
                        names.col = "Species", na.omit = FALSE,
                        warn.dropped = TRUE, vcv = TRUE)

phylo.d(data = cd, binvar = Capitula_structure, permut = 1000)

## ----------------- reconstruction --------

red$Capitula_structure <- as.factor(red$Capitula_structure)

red <- as.data.frame(red)
rownames(red) <- red$Species

anc <- make.simmap(tree = phycut, x = setNames(red$Capitula_structure, rownames(red)),
                    model = "ER", nsim = 100, Q = "mcmc", prior = list(use.empirical = TRUE),
                    samplefreq = 10)

anc_summary <- summary(anc)

#### PLOT: fan-shaped reconstruction map -------------------------------------

colors <- setNames(c("#56B4E9", "#D55E00", "#999999"),
                    c("Homogamous", "Heterogamous", "Not_capitulum"))

par(fg = "transparent")
plot(anc_summary, type = "fan", ftype = "off", cex = 0.3, colors = colors, lwd = .5)
par(fg = "black")

add.simmap.legend(colors = setNames(c("#56B4E9", "#D55E00", "#999999"),
                                     c("Homogamous",
                                       "Heterogamous",
                                       "Outgroups")),
                   prompt = FALSE, x = 0.9 * par()$usr[1],
                   y = 0.7 * par()$usr[3], fsize = 0.8)

#### number of transitions between states ---------------

describe.simmap(anc)

d <- density(anc)

dev.off()

tiff(filename = "test1.tiff", width = 5, height = 7, res = 600, units = "in")
par(mfrow = c(2, 1), las = 1, cex.axis = 0.8)
plot(density(anc), transition = "Homogamous->Heterogamous",
     colors = "firebrick4")
plot(density(anc), transition = "Heterogamous->Homogamous",
     colors = "blue3")
dev.off()

#### SAVING OBJECTS -----------------------------------------------------

saveRDS(anc, file.path(obj_dir, "anc.rds"))
