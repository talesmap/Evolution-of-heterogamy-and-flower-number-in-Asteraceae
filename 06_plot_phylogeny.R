####### FILOGENIA COM AS SUBFAMILIAS EM DESTAQUE --- DEPENDENTE DO SCRIPT USING_2018_PLANT_PHYLOGENY ------


library(tidytree)


x <- full_join(as_tibble(phycut), floret, by = c("label" = "Species"))

tree2 <- as.treedata(x)

ggtree(tree2, aes(color = Subfamily), layout = "circular", ladderize = F) +
  scale_color_discrete(name = "Subfamily",
                      labels = c("Asteroideae (450 sp)",
                                 "Barnadesioideae (55 sp)",
                                 "Carduoideae (41 sp)",
                                 "Cichorioideae (89 sp)",
                                 "Corymbioideae (3 sp)", "Dicomoideae (3 sp)",
                                 "Famatinanthoideae (1 sp)", "Gochnatioideae (25 sp)",
                                 "Hecastocleidoideae (1 sp)", "Mutisioideae (100 sp)",
                                 "Pertyoideae (26 sp)", "Stifftioideae (6 sp)",
                                 "Tarchonanthoideae (11 sp)", "Vernonioideae (136 sp)",
                                 "Wunderlichioideae (3 sp)", "Outgroup (21 sp)"))