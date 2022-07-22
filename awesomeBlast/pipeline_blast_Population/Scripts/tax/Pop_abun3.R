setwd("D:/work/Target/TTD/")
options(stringsAsFactors = F)
##############################  Function    ######################################
library(tidyverse)
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


##############################  Data_clean ######################################

Data_VFDB <- read.table('population_abun_tax_fmt.txt',sep = "\t",header = T,fill=TRUE, na.strings = "")
#Data_VFDB <- Data_VFDB[-ncol(Data_VFDB)]
Data_VFDB <- Data_VFDB[complete.cases(Data_VFDB$Abundance),]
#Data_CARD <- read_tsv('CARD_12_population_abun_taxa.txt',col_names = T)
#Data_CARD <- Data_CARD[complete.cases(Data_CARD$Abundance),]
Data_VFDB$Abundance <- as.numeric(Data_VFDB$Abundance)
data_vfdb <- Data_VFDB %>% 
              group_by(pop_id,Genus) %>% 
              summarise(
                Abun = sum(Abundance)
              )
vfdb_genus_mean <- data_vfdb %>% 
                    group_by(Genus) %>% 
                    summarise(
                      Abun_mean_vfdb = mean(Abun),
                      N_vfdb = n(),
                      standard_deviation_vfdb = sd(Abun),
                      standard_error_vfdb = sd(Abun)/sqrt(N_vfdb)
                    )
vfdb_genus_mean[is.na(vfdb_genus_mean)] <- 0


######
VFs_count <- select(Data_VFDB,"Genus") %>% 
  group_by(Genus) %>% 
  summarise(
    No_Targets =n()
  )

ARGs_taxa <- read_tsv('ratio_45.txt',col_names = T)
ARGs_count <- ARGs_taxa
Status <- read_tsv('Status_45.txt',col_names = T)
Status[is.na(Status)] <- "Unclassfied"
Counts <- inner_join(VFs_count,ARGs_count)
Status <- Status %>% group_by(Genus) %>%
  summarise(N.drug=sum(No.Drug))

Counts <- merge(Counts,Status)
Counts <- Counts[complete.cases(Counts[,1]),]
######


Genus_mean <- vfdb_genus_mean

Taxa <- select(Data_VFDB,Phylum,Class,Order,Family,Genus)
Taxa[is.na(Taxa)] <- "Unclassified"

Taxa <- Taxa[!duplicated(Taxa),]

Data <- inner_join(Taxa,Genus_mean)
Data <- inner_join(Data,Counts)

ord <- order(Data[[1]],Data[[2]],Data[[3]],Data[[4]],Data[[5]],Data[[6]],decreasing = F)
Data <- Data[ord,]
#write.table(Data,"VFDB_CARD_merge.txt",sep = '\t',quote = F,col.names = T,row.names = F)

Data[1:5] <- apply(Data[1:5], 2, F_ifno)
plot.data.left <- Data[c(1:5,7)]

plot.data.mid <- Data[6:9]
plot.data.right <- Data[11:12]
plot.data.add <- Data[13]
ww<-as.numeric(apply(plot.data.left,2, F_width))
ww[6] <- ww[6] * 1.5
##############################  plot          ######################################

pdf("Abun_taxa.plot4.pdf",w=16,h=nrow(plot.data.left)/6)
layout(mat=matrix(c(0,1,2,0,0,3,4,0,0,5,6,0,0,7,8,0,0,9,10,0),nrow=4,byrow=F),heights=c(0.6,2.3,nrow(plot.data.left)-1,0.5),widths = c(5,1,1,1,3))

par(mar= c(0,1,0,1),mex=0.5,lwd=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,sum(ww)),ylim=c(0,2),col="white",bg='grey90')
rect(xleft=-5, ybottom=0, xright=sum(ww[1:5])+5,xpd=T,ytop=2,col="grey90",border=NA) ### 0-down

H1 <- 1.4
H2 <- 0.48
cex1 <- 1.6
cex2 <- 0.8

N_of_taxa <- c()
for (i in 1:ncol(plot.data.left)) {
  N_of_taxa[i] <- length(plot.data.left[complete.cases(plot.data.left[,i]),i,drop = T])
}
segments(x0 = 1,y0 = 0,x1 = ww[1]-1,y1 = 0)
text(x = mean(c(ww[1],0)), y = H1,srt = 0,cex=cex1,font=2,labels = colnames(plot.data.left)[1],xpd = TRUE)
text(x = mean(c(ww[1],0)), y = H2,srt = 0,cex=cex2,font=1,labels = paste0("(No. = ",N_of_taxa[1],")"),xpd = T)

segments(x0 = ww[1] + 1,y0 = 0,x1 = sum(ww[1:2]) - 1,y1 = 0)
text(x = mean(c(ww[1],sum(ww[1:2]))), y = H1,srt = 0,cex=cex1,font=2,labels = colnames(plot.data.left)[2],xpd = TRUE)
text(x = mean(c(ww[1],sum(ww[1:2]))), y = H2,srt = 0,cex=cex2,font=1,labels = paste0("(No. = ",N_of_taxa[2],")"),xpd = TRUE)

segments(x0 = sum(ww[1:2]) + 1,y0 = 0,x1 = sum(ww[1:3]) - 1,y1 = 0)
text(x = mean(c(sum(ww[1:3]),sum(ww[1:2]))), y = H1,srt = 0,cex=cex1,font=2,labels =colnames(plot.data.left)[3],xpd = TRUE)
text(x = mean(c(sum(ww[1:3]),sum(ww[1:2]))), y = H2,srt = 0,cex=cex2,font=1,labels = paste0("(No. = ",N_of_taxa[3],")"),xpd = TRUE)

segments(x0 = sum(ww[1:3]) + 1,y0 = 0,x1 = sum(ww[1:4]) - 1,y1 = 0)
text(x = mean(c(sum(ww[1:3]),sum(ww[1:4]))),y = H1,srt =0,cex=cex1,font=2,labels = colnames(plot.data.left)[4],xpd = TRUE)
text(x = mean(c(sum(ww[1:3]),sum(ww[1:4]))), y = H2,srt = 0,cex=cex2,font=1,labels = paste0("(No. = ",N_of_taxa[4],")"),xpd = TRUE)

segments(x0 = sum(ww[1:4]) + 1,y0 = 0,x1 = sum(ww[1:5]) - 1,y1 = 0)
text(x = mean(c(sum(ww[1:5]),sum(ww[1:4]))), y = H1,srt = 0,cex=cex1,font=2,labels = colnames(plot.data.left)[5],xpd = TRUE)
text(x = mean(c(sum(ww[1:5]),sum(ww[1:4]))), y = H2,srt = 0,cex=cex2,font=1,labels = paste0("(No. = ",N_of_taxa[5],")"),xpd = TRUE)

segments(x0 = sum(ww[1:5]) + 1,y0 = 0,x1 = sum(ww[1:6]) - 1,y1 = 0)
text(x = mean(c(sum(ww[1:6]),sum(ww[1:5]))), y = H1,srt = 0,cex=cex1,font=2,labels = "Targets",xpd = TRUE)
text(x = mean(c(sum(ww[1:6]),sum(ww[1:5]))), y = H2,srt = 0,cex=cex2,font=1,labels = paste0("(No. = ",N_of_taxa[6],")"),xpd = TRUE)

par(mar = c(0,1,1,1),mex=1,cex=0.7,lwd=1,xaxs = "i", yaxs = "i",adj=0)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,sum(ww)),ylim=c(0,nrow(plot.data.left)),bg="red")

xx <- ww[1]/2
for(i in 1:(ncol(plot.data.left))){
  lab <- plot.data.left[complete.cases(plot.data.left[,i]),i,drop = T]
  yy <- F_grid(plot.data.left[,i])
  
  text(x=xx,y=rowMeans(yy),srt =0,adj=0.5,labels=lab,font=3,xpd = TRUE)
  if(i != (ncol(plot.data.left)))
  {
    segments(x0=xx+ww[i]/2,y0=yy[,1],x1=xx+ww[i]/2,y1=yy[,2])
    segments(x0=xx+ww[i]/2,y0=yy[,1],x1=xx+ww[i]/2+1,y1=yy[,1])
    segments(x0=xx+ww[i]/2,y0=yy[,2],x1=xx+ww[i]/2+1,y1=yy[,2])
  }
  xx <- xx+ww[i]/2+ww[i+1]/2
}

Mycol <- rep('grey',nrow(plot.data.mid))
Mycol[which(plot.data.mid$Abun_mean_vfdb>mean(plot.data.mid$Abun_mean_vfdb))] <- '#177cb0'

par(mar= c(0,1,0,1),mex=0.5,lwd=2,cex=0.8,font=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,1),ylim=c(0,2),col="white",bg='grey90')
text(x = 0.5, y = H1,srt = 0,labels ="The average Abundance\n of Targets",font=2,cex = 0.8,xpd = TRUE)
lim <- max(plot.data.mid$Abun_mean_vfdb + plot.data.mid$standard_error_vfdb)
par(mar = c(1,1,0.9,1),mgp = c(2,0.55,0.5),mex=1,cex=0.5,lwd=1,xaxs = "i", yaxs = "i",adj=0)
pos <- barplot(plot.data.mid$Abun_mean_vfdb,horiz = T,axes = F,xlim = c(0,lim*1.1),col = Mycol,border = NA)
axis(3,at = c(0,0.00013),labels = c(0,0.00013),tcl = -0.28)
error.bar(plot.data.mid$Abun_mean_vfdb,pos,plot.data.mid$standard_error_vfdb)


Mycol <- rep(c('#177cb0','grey'),length(plot.data.right$none))


par(mar= c(0,1,0,1),mex=0.5,lwd=2,cex=0.8,font=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,1),ylim=c(0,2),col="white",bg='grey90')
text(x = 0.5, y = H1,srt = 0,labels ="No. of species",font=2,xpd = TRUE)
par(mar = c(1,1,0.9,1),mgp = c(2,0.55,0.5),mex=1,cex=0.5,lwd=1,xaxs = "i", yaxs = "i",adj=0)
pos <- barplot(t(as.matrix(plot.data.right)),beside = F,horiz = T,axes = F,
               xlim = c(0,90),border = NA,yaxt = 'n',col = Mycol,
               legend.text = colnames(plot.data.right),args.legend = list(x=65,y=75,bty = "n",horiz = F))
axis(3,at = c(0,30,60,90),labels = c(0,30,60,90),tcl = -0.28)


par(mar= c(0,1,0,1),mex=0.5,lwd=2,cex=0.8,font=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,1),ylim=c(0,2),col="white",bg='grey90')
text(x = 0.5, y = H1,srt = 0,labels ="No. of Drugs",font=2,xpd = TRUE)
par(mar = c(1,1,0.9,1),mgp = c(2,0.55,0.5),mex=1,cex=0.5,lwd=1,xaxs = "i", yaxs = "i",adj=0)
barplot(t(as.matrix(plot.data.add[1])),horiz = T,axes = F,xlim = c(0,80),border = NA,yaxt = 'n')
axis(3,at = c(0,20,40,60,80),labels = c(0,20,40,60,80),tcl = -0.28)

###最右边部分
plot.data.right <- read.table("max_strain.txt",header = T,sep = "\t")
Genus <- left_join(plot.data.left,plot.data.right)
plot.data.right <- Genus[,c(7,8,9,10,5)]

Mycol=c('lightcoral','lightgray')
names(Mycol)=c('max','other')
#ll=c()

d_bar <- as.matrix(plot.data.right[,c(2,3)],nrow = 2)

ll <- plot.data.right[,c(2,4)] 
ll$species[ll$max == 0] <- NA  


# Mycol <- rep('grey',length(plot.data.right))
# Mycol[which(plot.data.right>mean(plot.data.right))] <- '#177cb0'


par(mar= c(0,1,0,1),mex=0.5,lwd=2,cex=0.8,font=2,xaxs = "i", yaxs = "i",adj=0.5)
plot(0,0,xlab="",ylab="",axes=F,xlim=c(0,1),ylim=c(0,2),col="white",bg='grey90')
text(x = 0.5, y = H1,srt = 0,labels ="Abundance",font=2,xpd = TRUE)
# par(mar = c(1,1,0.9,1),mgp = c(2,0.55,0.5),mex=1,cex=0.5,lwd=1,xaxs = "i", yaxs = "i",adj=0)
# pos <- barplot(plot.data.right,horiz = T,axes = F,xlim = c(0,0.025),col = 'grey',border = NA)
# axis(3,at = c(0,0.025),labels = c(0,0.025),tcl = -0.28)
# abline(v = mean(plot.data.right),col = '#ff2d51',lwd = 1.2)
# text(0.01,pos[60],labels = paste0("Mean = ",signif(mean(plot.data.right),digits = 5)),srt = -90,font=2,xpd = TRUE,cex = 2.2)
# 
# 
# Mycol <- rep(c('#177cb0','grey'),length(plot.data.right$none))


#par(mar= c(0,1,1,1),mex=0.5,lwd=2,cex=0.8,font=2,xaxs = "i", yaxs = "i",adj=0.5)
par(mar = c(1,1,0.9,1),mgp = c(2,0.55,0.5),mex=1,cex=0.5,lwd=1,xaxs = "i", yaxs = "i",adj=0)

pos <- barplot(xlab="",ylab="",axes=F,yaxt="n",xlim=c(0,max(1.2*plot.data.right$sum)),
               horiz=T,height=t(d_bar),col=Mycol[colnames(d_bar)],
               legend.text = colnames(d_bar),args.legend = list(x=0.03,y=56,bty = "n",horiz = F))
axis(side=3,tck = -0.01,at=c(0,max(plot.data.right$sum)),labels=c(0,format(max(plot.data.right$sum),scientific = T,digits = 3)),line=0.5)
#axis(side=2,at=c(0,yy4),labels=NA)

text(x=max(0.5*plot.data.right$sum),y=pos,adj=0,labels=ll$species)



dev.off()





