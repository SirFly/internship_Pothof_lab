
install.packages('../tools/DESeq2_1.30.1.tar.gz' , repos = NULL, type="source")

library(DESeq2)
library(ggplot2)


countData_male <- read.csv('../data/brain/merged_counts_default_trim_Refseq_males.csv', header = TRUE, sep = ",")
head(countData_male)


metaData_male <- read.csv('../data/brain/sample_groups_male.csv', header = TRUE, sep = ",")
metaData_male

dds <- DESeqDataSetFromMatrix(countData=countData_male, 
                              colData=metaData_male, 
                              design=~age, tidy = TRUE)
dds
dds <- DESeq(dds)


res <- results(dds)
head(results(dds, tidy=TRUE))

summary(res)

#Sort summary list by p-value
res <- res[order(res$padj),]
head(res)


#reset par
par(mfrow=c(1,1))
# Make a basic volcano plot
with(res, plot(log2FoldChange, -log10(padj), pch=20, main="Aging mice male (young = 3m, old = 24m)", xlim=c(-3,3)))
with(subset(res, padj<.05 & log2FoldChange > 1), points(log2FoldChange, -log10(padj), pch=20, col="red"))
with(subset(res, padj<.05 & log2FoldChange < -1), points(log2FoldChange, -log10(padj), pch=20, col="green"))



#PCA
#First we need to transform the raw count data
#vst function will perform variance stabilizing transformation

vsdata <- vst(dds, blind=FALSE)
z <-plotPCA(vsdata, intgroup="age") #using the DESEQ2 plotPCA fxn we can
z + geom_label(aes(label = name))
nudge <- position_nudge(y = 1)
z + geom_label(aes(label = name), position = nudge)
z + geom_text(aes(label = name), position = nudge)

res <- data.frame(res)
write.csv(res,"../data/brain/DESeq2_out/male_Refseq.csv")
res_up <- res[which(res$padj<0.05 & res$log2FoldChange > 0.9),]
res_down <- res[which(res$padj<0.05 & res$log2FoldChange < -0.9),]

