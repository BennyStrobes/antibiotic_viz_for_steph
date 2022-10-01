
args = commandArgs(trailingOnly=TRUE)
library(ggplot2)
library(cowplot)
options(bitmapType = 'cairo', device = 'pdf')



gtex_v8_figure_theme <- function() {
	return(theme(plot.title = element_text(face="plain",size=11), text = element_text(size=11),axis.text=element_text(size=11), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.text = element_text(size=11), legend.title = element_text(size=11)))
}


make_bar_plot <- function(df) {
	ordered_names = as.character(df$Antibiotic.Category)
	df$antibiotic_name = factor(df$Antibiotic.Category, levels=ordered_names)
	p <- ggplot(data=df, aes(x=antibiotic_name, y=Percent)) +
		geom_bar(stat="identity", position=position_dodge(), color='dodgerblue3', fill='dodgerblue3') + gtex_v8_figure_theme() +
		theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
		labs(x="", y="% total cases")
	return(p)

}

make_or_plot <- function(df, ordered_names, title_name) {

	#ordered_names = as.character(df$antibiotic_name)

	a <- df$aa 
	b <- df$bb
	c <- df$cc 
	d <- df$dd

	orat <- (a/b)/(c/d)
	# Get 95% CIs
	log_bounds <- 1.96*sqrt((1.0/a) - (1.0/b) + (1.0/c) - (1.0/d))
	upper_bound <- orat*exp(log_bounds)
	lower_bound <- orat*exp(-log_bounds)

	df2 <- data.frame(antibiotic_name=as.character(df$antibiotic_name), odds_ratio=orat, lower_bounds=lower_bound, upper_bounds=upper_bound)

	df2$antibiotic_name = factor(df2$antibiotic_name, levels=ordered_names)


	pp <-  ggplot() + geom_point(data=df2, mapping=aes(x=antibiotic_name, y=odds_ratio), color="dodgerblue2",size=2.5) +
					geom_errorbar(data=df2, mapping=aes(x=antibiotic_name,ymin=lower_bounds, ymax=upper_bounds),color="dodgerblue3",width=0.0) +
					labs(x = "", y = "Odds ratio", title=title_name) +
					geom_hline(yintercept = 1, size=.23,linetype="dashed") +
					gtex_v8_figure_theme() +
					theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
					theme(plot.title = element_text(hjust = 0.5))

	return(pp)

}


#######################################
# Antibiotic usage percentile bar plot
########################################
df <- read.table('input_data/AbxFreq.csv', header=TRUE, sep=",")
ordered_names = as.character(df$Antibiotic.Category)
barplot <- make_bar_plot(df)
output_file <- paste0("antibiotic_usage_percentage_barplot.pdf")
ggsave(barplot, file=output_file, width=7.2, height=4.0, units="in")



##################################
# Odds ratio for antibiotic usage by allergy status
##################################
# Plot
or_input_file <- paste0("antibiotics_by_allergy_status_data_or.txt")
df_or <- read.table(or_input_file, header=TRUE, sep="\t")
# Load in data
or_plot1 <- make_or_plot(df_or, ordered_names, "Antibiotic usage by allergy status")
output_file <- paste0("allergy_status_by_antibiotic_usage_enrichment_odds_ratio_plot.pdf")
ggsave(or_plot1, file=output_file, width=7.2, height=4.0, units="in")

##################################
# Odds ratio for antibiotic usage by MSRA
##################################
# Plot
or_input_file <- paste0("antibiotics_by_msra_data_or.txt")
df_or <- read.table(or_input_file, header=TRUE, sep="\t")
# Load in data
or_plot2 <- make_or_plot(df_or, ordered_names, "Antibiotic usage by MSRA status")
output_file <- paste0("msra_by_antibiotic_usage_enrichment_odds_ratio_plot.pdf")
ggsave(or_plot2, file=output_file, width=7.2, height=4.0, units="in")


# Merge together in joint plot
joint <- plot_grid(or_plot1, or_plot2, ncol=1, labels=c("A", "B"))
output_file <- paste0("joint_by_antibiotic_usage_enrichment_odds_ratio_plot.pdf")
ggsave(joint, file=output_file, width=7.2, height=7.0, units="in")


