# Baseline

For basing lines

## Installation

This requires ruby, but no other gems. Isn't that nice? To check if you have ruby installed on your system, open up the command line and type:

    ruby -v

If you don't have ruby, [this website](https://www.ruby-lang.org/en/) should help you install it.

Once you have ruby installed, either download this as a zip or clone it from github. Once you have it set up, you may want to put it in your `$PATH`.

## Running

The standard syntax for baseline is:

    baseline fit [--terse] [--out=FILE] [--beamstop=BS] FILE

Use the `--terse` flag to get a very terse file with just formatted data in it. Use `--beamstop` to indicate the domain of the beamstop. By default, data will output to STDOUT - redirect with pipes or with `--output`.

You can also make graphs with this, if you have [gnuplot](http://gnuplot.info/) installed on your machine. To check if you have gnuplot installed, try:

    gnuplot --version

To make shiny graphs:

    baseline graph [--professional] [--terse|--verbose] [--beamstop=BS] [--out=location] FILE

Use `--professional` for publication-type graphs without helpful markers, `--terse` or `--verbose` to control output as the graph is being made, `--beamstop` and `--out` as above. This will cause baseline to run gnuplot and give you a `.png` file in the same directory as the PXRD file.

## Questions etc.

[Get in touch](mailto:jan@1klb.com)