# setwd("D:/Work/others/YJH/190813_abun_taxa_tree")

F_ifno <- function(temp){
	flag <- temp[1]
    for (i in 2:length(temp))
    {
        if (temp[i] == flag)
        {
            temp[i] <- NA
        }else{
            flag <- temp[i]
        }
    }
	return(temp)
}
F_count <- function(temp){
    flag <- temp[1]
    count <- rep(1,length(temp))
    count[1] <- 1
    k <- 1
    for (i in 2:length(temp))
    {
        if (temp[i] == flag)
        {
            temp[i] <- NA
            count[i] <- 0
            count[k] <- count[k]+1
        }else{
            flag <- temp[i]
            k <- i
        }
    }
    return(count)
}
F_width <- function(temp){
    length <- c()
    for (i in 1:length(temp))
    {
        length <- append(length,length(strsplit(temp[i],'')[[1]]))
    }
    return(max(c(6,length)))
}
F_grid <- function(temp){
    t1 <- as.character(unique(temp[!is.na(temp)]))
    y1 <- c()
    if(length(t1)==1)
    {
        y1 <- 1
        y2 <- length(temp)
    }
    if(length(t1)==length(temp))
    {
        y1 <- 1:length(t1)
        y2 <- 1:length(t1)
    }
    if((length(t1)!=1) & length(t1)!=length(temp))
    {
        k=1
        names <- temp[!is.na(temp)]
        tt <- temp
        for (i in 1:length(temp))
        {
            if(!is.na(tt[i]))
            {
                y1[k] <- grep(tt[i],tt)[1]
                tt[i] <- NA
                k <- k+1
            }
        }
        y2 <- y1[2:length(y1)]-1
        y2 <- c(y2,length(temp))
    }
    yy <- cbind(y1=y1,y2=y2)
    return(yy)
}
error.bar <- function(x, y, upper, lower=upper, length=0.03,lwd=0.5,...){
    arrows(x-lower,y, x+upper, y, angle=90, code=3, length=length,lwd = lwd, ...)
}
library(tidyverse)
############read data
options(stringsAsFactors = F)
# data <- read.table('BUT_HMP_new_hits.txt',header=T,sep='\t')

data <- read_tsv("12Population_abun_taxa.txt")
#Data_VFDB <- Data_VFDB[-ncol(Data_VFDB)]
# Data_VFDB <- Data_VFDB[complete.cases(Data_VFDB$Abundance),]
data2 <- data %>% 
    filter(relat_abundance > 0) %>% 
    group_by(
        BestHit, Pop, Indi_id
    ) %>% 
    summarise(
        relative_abun = sum(relat_abundance)
    ) %>% 
    ungroup()

data3 <- data2 %>% 
    group_by(BestHit) %>% 
    summarise(
        n = n(),
        MEAN = mean(relative_abun),
        SD = sd(relative_abun),
        SE = SD/n
    ) %>% 
    ungroup() %>% 
    mutate(Repre_Gene_ID = BestHit) %>% 
    select(-BestHit)

Data <- read.table("BUT_indi_Hits_taxa.abun.tab",header=T,sep='\t')
Data <- Data[Data[,1] != 'Indi',]
new.id <- unique(Data$ref_gene_id)
data <- data[which(data$Gene_ID %in% new.id),]
data <- data[-1]

Data <- Data[complete.cases(Data$Genus),]
abun <- data.frame(tapply(as.numeric(as.character(Data$Abun)),list(Data$Indi,Data$Genus),sum))


data <- data[complete.cases(data$Genus),]
data[is.na(data)] <- "unclassfied"
data$Type <- "BUT"
# name <- colnames(data)[-1]
# data <- data[,-ncol(data)]
# colnames(data) <- name
ord <- order(data[,1],data[,2],data[,3],data[,4],data[,5],data[,6],data[,7],data[,8],decreasing=F)
data <- data[ord,]
###########detail taxa infomation
tt <- apply(data,2,F_ifno)
count <- F_count(data[,ncol(data)])
if(length(count[count==0])!=0)
{
    info <- tt[count!=0,]
}else{
    info <- tt
}
info <- cbind(info,number=count[count!=0])
write.csv(info,file="Taxa.info.csv",row.names=T)
############plot data
plot.data <- info[,c(2,4,5,6,ncol(info))]   ####选择你要画的taxanomic层次，例如：phylum、order、family、genus
if(length(grep(TRUE,is.na(plot.data[,(ncol(plot.data)-1)])))!=0)
{
    sum <- as.numeric(plot.data[,ncol(plot.data)])
    names <- plot.data[,ncol(plot.data)-1]
    flag <- names[1]
    k=1
    for (i in 1:nrow(plot.data))
    {
        if(is.na(names[i]))
        {
            sum[k] <- sum[k]+sum[i]
            sum[i] <- 0
        }else{
            flag <- names[i]
            names[i] <- NA
            k=i
        }
    }
    plot.data[,ncol(plot.data)] <- sum
    plot.data <- plot.data[sum!=0,]
}
#############plot
ww<-as.numeric(apply(plot.data,2, F_width))
pdf("Taxa-BUT.plot.pdf",w=10,h=nrow(plot.data)/6)
layout(mat=matrix(c(1:3,0,0,4),nrow=3,byrow=F),heights=c(1.5,1.3,nrow(plot.data)-1),widths=c(4,1))
############title
par(mar= c(0,1,0,1),mex=0.5,lwd=2,cex=1,font=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,sum(ww)),ylim=c(0,1),col="white",bg='grey90')
text(x=mean(c(sum(ww),0)), y=0.5,srt =0,labels ="BUT(No. = 142)",font=4,xpd = TRUE) ###标签
############label
par(mar= c(0,1,0,1),mex=0.5,lwd=2,cex=0.8,font=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,sum(ww)),ylim=c(0,1),col="white",bg='grey90')
#rect(xleft=-5, ybottom=0, xright=sum(ww[1:5])+5,xpd=T,ytop=1,col="grey90",border=NA) ### 0-down
segments(x0=1,y0=0,x1=ww[1]-1,y1=0)
text(x=mean(c(ww[1],0)), y=0.6,srt =0,, labels ="Phylum",xpd = TRUE) ###标签
segments(x0=ww[1]+1,y0=0,x1=sum(ww[1:2])-1,y1=0)
text(x=mean(c(ww[1],sum(ww[1:2]))), y=0.6,srt =0, labels ="Order",xpd = TRUE)   #Family
segments(x0=sum(ww[1:2])+1,y0=0,x1=sum(ww[1:3])-1,y1=0)
text(x=mean(c(sum(ww[1:3]),sum(ww[1:2]))), y=0.6,srt =0, labels ="Family",xpd = TRUE)   #Genus
segments(x0=sum(ww[1:3])+1,y0=0,x1=sum(ww[1:4])-1,y1=0)
text(x=mean(c(sum(ww[1:3]),sum(ww[1:4]))), y=0.6,srt =0, labels ="Genus",xpd = TRUE)   #Species
segments(x0=sum(ww[1:4])+1,y0=0,x1=sum(ww[1:5])-1,y1=0)
text(x=mean(c(sum(ww[1:5]),sum(ww[1:4]))), y=0.6,srt =0, labels ="No.",xpd = TRUE)
#########???3???
par(mar = c(0,1,1,1),mex=1,cex=0.7,lwd=1,xaxs = "i", yaxs = "i",adj=0)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,sum(ww)),ylim=c(0,nrow(plot.data)+0.1),col="white")

#cols <- c('Honeydew1','LavenderBlush1','OldLace','LightBlue','MistyRose')
#for (i in 1:nrow(yy))
#{
    #rect(xleft=-5,ybottom=yy[i,1]-0.5, xright=sum(ww[1:5])+5,ytop=yy[i,2]+1,col=cols[i],border=NA,xpd=T) ### 1-up
#}
xx <- ww[1]/2
for(i in 1:(ncol(plot.data)-1)){
    lab <- plot.data[!is.na(plot.data[,i]),i]
    yy <- F_grid(plot.data[,i])

    text(x=xx,y=rowMeans(yy),srt =0,adj=0.5,labels=lab,font=3,xpd = TRUE)
    if(i != (ncol(plot.data)-1))
    {
        segments(x0=xx+ww[i]/2,y0=yy[,1],x1=xx+ww[i]/2,y1=yy[,2])
        segments(x0=xx+ww[i]/2,y0=yy[,1],x1=xx+ww[i]/2+1,y1=yy[,1])
        segments(x0=xx+ww[i]/2,y0=yy[,2],x1=xx+ww[i]/2+1,y1=yy[,2])
    }
    xx <- xx+ww[i]/2+ww[i+1]/2
}
lab <- plot.data[,ncol(plot.data)]
yy <- 1:nrow(plot.data)
text(x=xx+2,y=yy,srt=0,adj=1,labels=lab,font=1,xpd = TRUE)
#segments(x0=xxs,y0=yy,x1=xxs+1,y1=yy)
###abundance bars
# Data <- read.table("BUT_indi_Hits_taxa.abun.tab",header=T,sep='\t')
# Data <- Data[Data[,1] != 'Indi',]
# Data <- Data[complete.cases(Data$Genus),]
# abun <- data.frame(tapply(as.numeric(as.character(Data$Abun)),list(Data$Indi,Data$Genus),sum))



# abun <- read.csv('all_mean_genus.csv',header=T,row.names=1)
m <- as.data.frame(plot.data)
# flag <- setdiff(m[,4],colnames(abun))
# for (i in 1:length(flag)) {
#     abun[flag[i]] <- 0
# }
data.abun <- abun[,plot.data[,4]]
# data.abun <- abun[,as_factor(plot.data[,4])]
#data.abun <- subset(data.abun,select = -Genus)
data.mean <- colMeans(data.abun,na.rm = T)
# data.mean <- colSums(data.abun,na.rm = T)/nrow(data.abun)
# data.mean[grep("Unclassified",names(data.mean))] <- 0
data.sd <- c()
for (i in 1:ncol(data.abun))
{
    data.sd[i] <- sd(data.abun[,i],na.rm=T)
}
data.sd[is.na(data.sd)] <- 0
names(data.sd) <- colnames(data.abun)
# data.sd[grep("Unclassified",names(data.sd))] <- 0
max(data.mean+data.sd)
par(mar = c(0.5,0.2,0.7,1),mgp=c(0,0.5,1),mex=1,cex=0.7,lwd=1,xaxs = "i", yaxs = "i",adj=0)
pos <- barplot(data.mean,horiz=T,axes=F,axisnames=F,width=0.8,space=0.2,xlim=c(0,max(data.mean+data.sd)*1.2),border=NA)
srt=pos[2]-pos[1]
segments(x0=data.mean,y0=pos,x1=data.mean+data.sd,y1=pos,lwd=0.5)
segments(x0=data.mean+data.sd,y0=pos-0.2*srt,x1=data.mean+data.sd,y1=pos+0.2*srt,lwd=0.5)
axis(side=3,at=c(0,0.00006,0.00012),label=c(0,0.00006,0.00012),xpd=T,lwd=0.5,line=0.5)
mtext("Relative Abundance",side=3,line=1.7,cex=0.7,adj=0.3)

dev.off()
