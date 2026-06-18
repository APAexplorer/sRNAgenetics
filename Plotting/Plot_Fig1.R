library(ggplot2)
library(scales)

qtl.num <- readRDS("Input_Fig1.Rdata")
p1<- ggplot(qtl.num, aes(x = tissue, y = -num_qtl, fill = tissue)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = setNames(qtl.num$color, qtl.num$tissue)) +
  coord_flip()+guides(fill="none")+#p_theme+
  labs(y="Number of sRNA-QTL pairs",x=NULL)+
  scale_y_continuous(
    limits = c(-450000, 0),   
    breaks = seq(-500000, 0,100000),
    labels = function(x) scales::comma(abs(x)),
    expand = c(0,0)        
  )+
  theme( panel.background = element_rect(fill = "white", color = NA),
         plot.background  = element_rect(fill = "white", color = NA),
         
         axis.line = element_line(
          # arrow = arrow(length = unit(0.15, "cm")),
           linewidth = 0.4
         ),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y =element_text(color=qtl.num$color,
                                  size=9,family="Helvetica",angle=0 ))

print(p1)


p2<-ggplot(qtl.num, aes(x = tissue, y = num_srna, fill = tissue)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = setNames(qtl.num$color, qtl.num$tissue)) +
  coord_flip()+guides(fill="none")+
  labs(y="Number of sRNA events",x=NULL)+
  scale_y_continuous(
    limits = c(0,3500),   
    breaks = seq(0,3500,1000),
    labels = label_comma(),
    expand = c(0,0)           
  )+
 
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background  = element_rect(fill = "white", color = NA),
        
        axis.line = element_line(
         # arrow = arrow(length = unit(0.15, "cm")),
          linewidth = 0.4
        ),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y =element_blank())
print(p2)


p<-cowplot::plot_grid(p1,p2,
                      align = "h", nrow = 1,rel_widths=c(3,1))

print(p)
