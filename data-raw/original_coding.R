
ps_coding <- read.delim("data-raw/kristen_zach.txt", na.strings=c("NA", "na"), stringsAsFactors=FALSE)
save(ps_coding, file = "data/ps_coding.RData", compress = "xz")

rec_coding = read.delim('data-raw/KZ reconciliation.txt', colClasses='character')
save(rec_coding, file = "data/rec_coding.RData", compress = "xz")

srs_coding = read.delim("data-raw/ZK SRS coding.txt", na.strings=c("NA", "na"), stringsAsFactors=FALSE)
save(srs_coding, file = "data/srs_coding.RData", compress = "xz")
