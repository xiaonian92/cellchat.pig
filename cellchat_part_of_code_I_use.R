interaction_input <- read.csv('3.database_pig/interaction_input_CellChatDB.csv', row.names = 1)
#row.names(interaction_input) <- interaction_input[ ,1]
complex_input     <- read.csv('3.database_pig/complex_input_CellChatDB.csv', row.names = 1)
cofactor_input    <- read.csv('3.database_pig/cofactor_input_CellChatDB.csv', row.names = 1)
geneInfo_input    <- read.table('3.database_pig/geneInfo_input_CellChatDB.txt', 
                                sep = "\t", row.names = 1, header = T, fill = TRUE, quote = "")
CellChatDB        <- list()
CellChatDB$interaction <- interaction_input
CellChatDB$complex     <- complex_input
CellChatDB$cofactor    <- cofactor_input
CellChatDB$geneInfo    <- geneInfo_input
CellChatDB.pig         <- CellChatDB

# create object
data.input <- read.table('1.cellchat_count.txt', header = T, row.names = 1)
data.input <- normalizeData(data.input, scale.factor = 10000, do.log = TRUE)
meta       <- read.table('1.cellchat_meta.txt', header = T, row.names = 1)
unique(meta$group) 
cellchat <- createCellChat(object = data.input,
                           meta = meta,
                           group.by = "group")
cellchat
summary(cellchat)

# set database
CellChatDB <- CellChatDB.pig
showDatabaseCategory(CellChatDB)
dplyr::glimpse(CellChatDB$interaction)
CellChatDB.use <- CellChatDB #or: sebsetDB(CellChatDB,search="Secreted Signaling")

cellchat@DB <- CellChatDB.use

colnames(CellChatDB$interaction)
CellChatDB$interaction[1:4,1:4]

# preprocessing for over-expressed LRs
cellchat <- subsetData(cellchat)
