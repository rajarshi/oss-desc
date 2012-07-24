library(lattice)
library(reshape)
library(ggplot2)

acd <- read.table('all-clean.acd', sep='\t', header=TRUE, as.is=TRUE)
cdk <- read.table('all-clean.cdk', sep='\t', header=TRUE, as.is=TRUE)
tmp <- data.frame(ACD=acd$ACD_RuleOf5_PSA, CDK=cdk$TopoPSA)

ggplot(tmp, aes(x=CDK,y=ACD))+
  geom_point(size=1.5,alpha=0.25)+
  geom_smooth()+
#  scale_x_continuous(limits=c(0,1500))+
  xlab('CDK TPSA')+ylab("ACD TPSA")

xyplot(ACD ~ CDK, tmp, type=c('p', 'g'), col='black', cex=0.25,
       xlab=list(label='CDK TPSA', cex=1.2),
       ylab=list(label='ACD TPSA', cex=1.2),
       panel=function(x,y,...) {
         panel.xyplot(x,y,...)
         panel.abline(0, 1, col='red')                  
       }
         )
dev.copy(pdf, '../tpsa-cdk-acd.pdf', 6,6);dev.off()
dev.copy(png, '../tpsa-cdk-acd.png', 400,400);dev.off()


## volumes
moe <- read.csv('vol.moe', header=TRUE, as.is=TRUE)
cdk <- read.table('vol.cdk', header=TRUE, as.is=TRUE, sep=' ')
names(moe) <- c('sid', 'van der Waals Volume (2D)', 'van der Waals Volume (grid based)')
names(cdk) <- c('sid', 'VABC')
tmp <- merge(moe, cdk, by='sid')
tmp <- tmp[ complete.cases(tmp), ]
tmp <- melt(tmp,, id.vars='VABC', measure.vars=c('van der Waals Volume (2D)', 'van der Waals Volume (grid based)'))

ggplot(tmp, aes(x=VABC,y=value))+
  geom_point(size=1,alpha=0.25)+
  geom_smooth()+
  facet_wrap(~variable)+
  scale_x_continuous(limits=c(0,1500))+
  xlab('CDK VABC')+ylab("MOE")

xyplot(value ~ VABC | variable, tmp,
       type=c('p', 'g'), col='black', cex=0.25,
       xlab=list(label='CDK VABC', cex=1.2),
       ylab=list(label='MOE', cex=1.2),
       xlim=range(c(tmp$VABC, tmp$value)),
       ylim=range(c(tmp$VABC, tmp$value)),       
        panel=function(x,y,...) {
         panel.xyplot(x,y,...)
         panel.abline(0, 1, col='red')                  
       })
dev.copy(pdf, '../vol-moe-cdk.pdf', 8,4);dev.off()
dev.copy(png, '../vol-moe-cdk.png', 600,300);dev.off()
