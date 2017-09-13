Chunk Options, Naming Things
================
Will Doyle
September 13, 2017

Chunk Options
=============

From: <https://yihui.name/knitr/options/#chunk-options>

Text Results

*tl;d rTo drop everything but graphics:*

{r, echo=FALSE, results='hide', warning=FALSE, message=FALSE}

-   echo: (TRUE; logical or numeric) whether to include R source code in the output file; besides TRUE/FALSE which completely turns on/off the source code, we can also use a numeric vector to select which R expression(s) to echo in a chunk, e.g. echo=2:3 means only echo the 2nd and 3rd expressions, and echo=-4 means to exclude the 4th expression

-   results: ('markup'; character) takes these possible values markup: mark up the results using the output hook, e.g. put results in a special LaTeX environment asis: output as-is, i.e., write raw results from R into the output document hold: hold all the output pieces and push them to the end of a chunk hide hide results; this option only applies to normal R output (not warnings, messages or errors) note markup and asis are equivalent to verbatim and tex in Sweave respectively (you can still use the latter two, but they can be misleading, e.g., verbatim does not really mean verbatim in R, and tex seems to be restricted to LaTeX)

-   collapse: (FALSE; logical; applies to Markdown output only) whether to, if possible, collapse all the source and output blocks from one code chunk into a single block (by default, they are written to separate blocks)

-   warning: (TRUE; logical) whether to preserve warnings (produced by warning()) in the output like we run R code in a terminal (if FALSE, all warnings will be printed in the console instead of the output document); it can also take numeric values as indices to select a subset of warnings to include in the output

-   error: (TRUE; logical) whether to preserve errors (from stop()); by default, the evaluation will not stop even in case of errors!! if we want R to stop on errors, we need to set this option to FALSE when the chunk option include = FALSE, error knitr will stop on error, because it is easy to overlook potential errors in this case message: (TRUE; logical) whether to preserve messages emitted by message() (similar to warning)

-   split: (FALSE; logical) whether to split the output from R into separate files and include them into LaTeX by or HTML; this option only works for .Rnw, .Rtex, and .Rhtml documents (it does not work for R Markdown)

-   include: (TRUE; logical) whether to include the chunk output in the final output document; if include=FALSE, nothing will be written into the output document, but the code is still evaluated and plot files are generated if there are any plots in the chunk, so you can manually insert figures; note this is the only chunk option that is not cached, i.e., changing it will not invalidate the cache

-   strip.white: (TRUE; logical) whether to remove the white lines in the beginning or end of a source chunk in the output

-   class.output: (NULL; character) useful for HTML output, appends classes that can be used in conjunction with css, so you can apply custom formatting.

Naming things:
==============

<http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf>
