#' HUGO gene to Pfam mapping
#'
#' @description Generate HUGO gene symbol to Pfam mapping table from UniProt and Pfam databases

message("Parsing filtered human data from UniProt ...")
# ===
# Note: not run.
# can use "UniProt.ws" to retrieve all UniProt information.
# However, UniProt limits queries with a large amount of keys.
# It's recommended that the select method be invoked with fewer than
# 100 keys or the query may fail.
# ===
# library(UniProt.ws)
# up = UniProt.ws(taxId=9606)
# up_col = c("UNIPROTKB", "GENES", "LENGTH", "VERSION")
# up_keys = keys(up, keytype="UNIPROTKB")
# up_all = select(up, keys=up_keys, columns=up_col, keytype="UNIPROTKB")

# --------------------------
# In practice, the data were downloaded from UniProtKB
#
# https://www.uniprot.org/uniprot/?query=*&fil=organism%3A%22Homo+sapiens+%28Human%29+%5B9606%5D%22+AND+reviewed%3Ayes
# (1) select 9606
# (2) select "Reviewed" only entries
# (3) select columns
# - Entry
# - Gene names (primary)
# - Length
# (4) download in tsv format
# --------------------------

uniprot_fn <- "prepare_data/uniprotkb_taxonomy_id_9606_AND_reviewed_2024_07_29.tsv.gz"

uniprot_file <- gzcon(file(uniprot_fn, "r"))
uniprot_txt <- readLines(uniprot_file)
uniprot_df <- read.table(
  textConnection(uniprot_txt),
  sep = "\t",
  quote = "",
  comment.char = "#",
  stringsAsFactors = FALSE,
  header = TRUE)
colnames(uniprot_df) <- c("uniprot", "length", "symbol")

# split multiple entries in symbol column
uniprot_single_df <- subset(uniprot_df, !grepl(";", symbol))
uniprot_to_parse_df <- subset(uniprot_df, grepl(";", symbol))
for(idx in 1:nrow(uniprot_to_parse_df)){
  symbols <- strsplit(uniprot_to_parse_df[idx, "symbol"], "; ")[[1]]
  uniprot_single_df <- rbind(
    uniprot_single_df,
    data.frame(
      uniprot = uniprot_to_parse_df[idx, "uniprot"],
      length = uniprot_to_parse_df[idx, "length"],
      symbol = symbols)
  )
}

# --------------------------
# Pfam (human 9606)
# Date: 2025-07-29
# Version: 37.0
message("Download Pfam data from Pfam website ...")
pfam_url <- "ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/proteomes/9606.tsv.gz"
pfam_fn <- "prepare_data/9606.tsv.gz"
# download.file(pfam_url, pfam_fn)

# --------------------------
message("Read Pfam information ...")
pfam_file <- gzcon(file(pfam_fn, "r"))
pfam_txt <- readLines(pfam_file)

pfam_df <- read.table(
  file = textConnection(pfam_txt),
  sep = "\t",
  quote = "",
  comment.char = "#",
  stringsAsFactors = FALSE,
  header = FALSE
)

colnames(pfam_df) <- c(
  "id", "align.start", "align.end", "start", "end",
  "hmm.acc", "hmm.name", "type", "hmm.start", "hmm.end", "hmm.length",
  "bit.score", "e.value", "clan")
pfam_sub_df <- pfam_df[, c("id", "start", "end", "hmm.acc", "hmm.name", "type")]

# merge by UniProt
message("Generating mapping table ...")
hgnc2pfam.df <- merge(uniprot_single_df, pfam_sub_df, by.x="uniprot", by.y = "id", all.x=TRUE, sort = FALSE)
hgnc2pfam.df <- hgnc2pfam.df[with(hgnc2pfam.df, order(symbol, uniprot, start, end)), ]
hgnc2pfam.df <- hgnc2pfam.df[, c("symbol", "uniprot", "length",
                                 "start", "end", "hmm.acc", "hmm.name", "type")]

# create Rdata, move this to "data" directory
save(hgnc2pfam.df, file="data/hgnc2pfam.df.rda", compress = "xz")

