all:	minarea-seq.t \
	Cv-HoughLines-standard.t \
	flipbook

minarea-seq.t:  minarea.t
	ln -s minarea.t minarea-seq.t

Cv-HoughLines-standard.t:  Cv-HoughLines.t
	ln -s Cv-HoughLines.t Cv-HoughLines-standard.t

flipbook:
	for i in /mnt/images/432 /home/qod/images/432; do \
		test -d $$i && ln -s $$i flipbook; \
	done

clean:
	rm minarea-seq.t Cv-HoughLines-standard.t flipbook
