

missing_levels<-c(-4,-8,-9)

replace_na<-function(x){z<-ifelse(x%in%missing_levels,NA,x);z}

test_data<-seq(-8,12,by=4)

list_of_vars<-c("var1","var2")

df%>%
  mutate_at(.vars=list_of_vars,.funs=replace_na)->df