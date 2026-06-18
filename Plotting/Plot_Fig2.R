library(ggplot2)

df_cumsum.uq <- readRDS("Input_Fig2.Rdata")

ggplot(df_cumsum.uq,
       aes(x=tissue,y=total_n,fill=tissue))+
  geom_point(shape=23,size=3)+
  coord_flip()+guides(color="none",fill="none")+
  scale_fill_manual(values=df_cumsum.uq$color)+
  scale_color_manual(values=df_cumsum.uq$color)+
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.background  = element_rect(fill = "white", color = NA),
    
    axis.line = element_line(
      linewidth = 0.4
    ),
    axis.text.y =element_text(color=df_cumsum.uq$color,
                              size=9,family="Helvetica",angle=0 ))+
  labs(y="Number of TWAS models",x=NULL)
