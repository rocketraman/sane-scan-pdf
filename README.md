# SANE Command-Line Scan to PDF

Sane command-line scanning bash shell script on Linux with OCR and deskew support. The script automates
common scan-to-pdf operations for scanners with an automatic document feeder, such as the awesome Fujitsu
ScanSnap S1500, with output to PDF files.

Tested and run regularly on Fedora, but should work on other distributions with the requirements below.

## Features

* Join scanned pages into a single output file, or specify a name for each page
* Deskew (if supported by scanner driver, or software-based via unpaper)
* Crop (if supported by scanner driver)
* Creates searchable PDFs (with tesseract)
* Duplex (if scanner supports it)
* Specify resolution
* Truncate n pages explicitly from end of scan e.g. duplex scanning with last page truncated
* Skip white-only pages automatically (with ImageMagick)
* Specify page width and height for odd size pages, or common sizes (Letter, Legal, A4)
* Performance: scanner run in parallel with page post-processing
* Limit parallel processing for very fast scanners or constrained environments (if sem installed)

## Requirements

The following dependencies are requirements of the script. See also [Dependencies
Installation](https://github.com/rocketraman/sane-scan-pdf/wiki/Dependencies-Installation).

* bash
* pnmtops (netpbm-progs)
* ps2pdf (ghostscript)
* pdfunite (poppler-utils)
* units (units)
* ImageMagick (if --skip-empty-pages or --ocr is used)

### Optional

* unpaper (for software deskew)
* flock (usually provided by util-linux) (for properly ordered verbose logs)
* tesseract (to make searchable PDFs)
* sem (via gnu-parallels, to constrain resource usage during page processing)
* bc (for whitepage detection percentage calculations)

## Getting Started

```
# scan --help
scan [OPTIONS]... [OUTPUT]

OPTIONS
 -v, --verbose
   Verbose output (this will slow down the scan due to the need to prevent interleaved output)
 -d, --duplex
   Duplex scanning
 -m, --mode
   Mode e.g. Lineart (default), Halftone, Gray, Color, etc. Use --mode-hw-default to not set any mode
 --mode-hw-default
   Do not set the mode explicitly, use the hardware default
 -r, --resolution
   Resolution e.g 300 (default)
 -a, --append
   Append output to existing scan
 -e, --max <pages>
   Max number of pages e.g. 2 (default is all pages)
 -t, --truncate <pages>
   Truncate number of pages from end e.g. 1 (default is none)
 -s, --size
   Page Size as type e.g. Letter (default), Legal, A4, no effect if --crop is specified
 -ph, --page-height
   Custom Page Height in mm
 -pw, --page-width
   Custom Page Width in mm
 -x, --device
   Override scanner device name, defaulting to `fujitsu`
 --crop
   Crop to contents (driver must support this)
 --deskew
   Run driver deskew (driver must support this)
 --unpaper
   Run post-processing deskew and black edge detection (requires unpaper)
 --ocr
   Run OCR to make the PDF searchable (requires tesseract and ImageMagick)
 --skip-empty-pages
   remove empty pages from resulting PDF document (e.g. one sided doc in duplex mode)

OUTPUT
 -o, --output <outputfile>
   Output to named file default=scan.pdf
 -l, --outputlist <outputfile-1...outputfile-n> Output to named files for each scanned page, can be used with append
```

### Configuration

Use `--help` locally to show the location of optional configuration and
pre-scan hook scripts. These scripts may contain environment variables to
pre-configure `scan`. For example the contents of the `default` file may be
something like:

```
DEVICE=something
SEARCHABLE=1
MODE_HW_DEFAULT=1
```

### Tips

The default scanner device is set to `fujitsu`. If you have another scanner,
you will need to use the `-x`/`--device` argument to specify your scanner,
or save a `DEVICE=something` line to a local config file as shown above.
See below for how to get the list of available devices.

The scanners and scanner drivers vary in features they support. This script
provides several options to the underlying scanner driver by default, and
these options may not be supported by your scanner/scanner driver. If
you are receiving an error about `--page-width`/`--page-height` being
unrecognized options, try the `--no-default-size` option. If you receive an
error about the `--mode` value being invalid, try `--mode-hw-default`
and see below for how to retrieve the list of modes that your system understands.

### Helpful Commands

List available scanner devices (for `-x`/`--device` argument):

```
scanadf -L
```

List available device-specific options, including acceptable values for
`-m`/`--mode` and `-r`/`--resolution`:

```
scanadf [-d <device>] --help
```

## Author(s)

* [Raman Gupta](https://github.com/rocketraman/)

With assistance from
[various other contributors](https://github.com/rocketraman/sane-scan-pdf/graphs/contributors)!
Thank you!

## Other Useful Software

* [OCRmyPDF](https://github.com/jbarlow83/OCRmyPDF) - forgot to use the `--ocr` option at scanning time? use this
