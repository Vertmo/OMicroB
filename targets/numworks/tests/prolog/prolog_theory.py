# Fichier Prolog, pas Python
# Une theorie : des faits.
# Cf. OMicroB OCaml Prolog
# Par Lilian Besson (Naereen)
cat(tom).
cat(ajani).
mouse(jerry).
mouse(mickey).

fast(X) <-- mouse(X).
stupid(X) <-- cat(X).

ishuntedby(X, Y) <-- mouse(X), cat(Y).