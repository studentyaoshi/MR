Args <- commandArgs(TRUE)
input1 <- Args[1] #exposure data
input2 <- Args[2] #outcome dat

output1 <- Args[3]
output2 <- Args[4]
output3 <- Args[5]

library(simex)

data1<-read.table(input1,header=T)
data2<-read.table(input2,header=T)

betaXG<-data1$beta
sebetaXG<-data1$se
betaYG<-data2$beta
sebetaYG<-data2$se

Isq=function(y,s){k=length(y);w=1/s^2;sum.w=sum(w);
k=length(y);mu.hat=sum(y*w)/sum.w;
Q=sum(w*(y-mu.hat)^2);Isq=(Q-(k-1))/Q;
Isq=max(0,Isq);return(Isq);
}

I_2 <- Isq(betaXG,sebetaXG)
I_2<-as.data.frame(I_2)

BYG=betaYG*sign(betaXG)
BXG=abs(betaXG)

fit4<-lm(BYG~BXG,weights=1/sebetaYG^2,x=TRUE,y=TRUE)
mod.sim<-simex(fit4,B=10000,measurement.error=sebetaXG,SIMEXvariable="BXG",fitting.method="quad",asymptotic="FALSE")


re2<-summary(mod.sim)
re3<-as.data.frame(re2$coefficients)

write.table(I_2,output1,quote=F,row.names=F,col.names=F,sep="\t") ##I2_GX
write.table(re3[1,],output2,quote=F,row.names=F,col.names=F,sep="\t") ## SIMEX Intercept
write.table(re3[2,],output3,quote=F,row.names=F,col.names=F,sep="\t") ## SIMEX Slope














