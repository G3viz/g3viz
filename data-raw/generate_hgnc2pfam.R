#' HUGO gene to Pfam mapping
#'
#' @description Generate HUGO gene symbol to Pfam mapping table from UniProt and Pfam databases
generateHgnc2pfam <- function() {
  message("Download data from UniProt website ...")

  uniprot.file <- gzcon(file("data-raw/uniprot.tab.gz", "r"))
  uniprot.txt <- readLines(uniprot.file)
  uniprot.df <- read.table(textConnection(uniprot.txt),
                           sep = "\t",
                           quote = "",
                           comment.char = "#",
                           stringsAsFactors = FALSE,
                           header = TRUE)
  colnames(uniprot.df) <- c("uniprot", "length", "symbol")

  # split multiple entries in symbol column
  uniprot.single.df <- subset(uniprot.df, !grepl(";", symbol))
  uniprot.to.parse.df <- subset(uniprot.df, grepl(";", symbol))
  for(idx in 1:nrow(uniprot.to.parse.df)){
    symbols <- strsplit(uniprot.to.parse.df[idx, "symbol"], "; ")[[1]]
    uniprot.single.df <- rbind(uniprot.single.df,
                              data.frame(uniprot = uniprot.to.parse.df[idx, "uniprot"],
                                         length = uniprot.to.parse.df[idx, "length"],
                                         symbol = symbols)
    )
  }

  # pfam (human 9606)
  message("Download Pfam data from Pfam website ...")
  pfam.file <- gzcon(file("data-raw/9606.tsv.gz", "r"))
  pfam.txt <- readLines(pfam.file)

  pfam.df <- read.table(
    file = textConnection(pfam.txt),
    sep = "\t",
    quote = "",
    comment.char = "#",
    stringsAsFactors = FALSE,
    header = FALSE
  )

  colnames(pfam.df) = c("id", "align.start", "align.end", "start", "end",
                        "hmm.acc", "hmm.name", "type", "hmm.start", "hmm.end", "hmm.length",
                        "bit.score", "e.value", "clan")
  pfam.sub.df = pfam.df[, c("id", "start", "end", "hmm.acc", "hmm.name", "type")]

  # merge by UniProt
  hgnc2pfam.df = merge(uniprot.single.df, pfam.sub.df, by.x="uniprot", by.y = "id", all.x=TRUE, sort = FALSE)
  hgnc2pfam.df = hgnc2pfam.df[with(hgnc2pfam.df, order(symbol, uniprot, start, end)), ]
  hgnc2pfam.df = hgnc2pfam.df[, c("symbol", "uniprot", "length",
                                  "start", "end", "hmm.acc", "hmm.name", "type")]


  message("Generate data ...")
	rownames(hgnc2pfam.df) <- c()
	
  #saveRDS(hgnc2pfam.df, "data/hgnc2pfam.RDS")
}
