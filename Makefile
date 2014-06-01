
DATA = belmont.tsv kentucky.tsv preakness.tsv

all: $(DATA) triplecrown.png

belmont.tsv: belmont-stakes-winners.wikitable parse.awk
	./parse.awk $< > $@

kentucky.tsv: kentucky-derby-winners.wikitable parse.awk
	./parse.awk $< > $@

preakness.tsv: preakness-stakes-winners.wikitable parse.awk
	./parse.awk $< > $@

triplecrown.png: triplecrown.R $(DATA)
	Rscript --vanilla $<
