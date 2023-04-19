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
* Post-scan open scan output(s) in viewer
* Configuration via default and named option groups

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
* xdg-open (for opening scan after completion)

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
   Do not set the mode explicitly, use the hardware default — ignored if --mode is set
 -r, --resolution
   Resolution e.g 300 (default)
 -a, --append
   Append output to existing scan
 -e, --max <pages>
   Max number of pages e.g. 2 (default is all pages)
 -t, --truncate <pages>
   Truncate number of pages from end e.g. 1 (default is none) -- truncation happens after --skip-empty-pages
 -s, --size
   Page Size as type e.g. Letter (default), Legal, A4, no effect if --crop is specified
 -ph, --page-height
   Custom Page Height in mm
 -pw, --page-width
   Custom Page Width in mm
 -x, --device
   Override scanner device name, defaulting to "fujitsu", pass an empty value for no device arg
 -xo, --driver-options
   Send additional options to the scanner driver e.g.
   -xo "--whatever bar --frobnitz baz"
 --no-default-size
   Disable default page size, useful if driver does not support page size/location arguments
 --crop
   Crop to contents (driver must support this)
 --deskew
   Run driver deskew (driver must support this)
 --unpaper
   Run post-processing deskew and black edge detection (requires unpaper)
 --ocr
   Run OCR to make the PDF searchable (requires tesseract)
 --language <lang>
   which language to use for OCR
 --skip-empty-pages
   remove empty pages from resulting PDF document (e.g. one sided doc in duplex mode)
 --white-threshold
   threshold to identify an empty page is a percentage value between 0 and 100. The default is 99.8
 --brightness-contrast-sw
   Alter brightness and contrast via post-processing - prefer specifying brightness and/or
   contrast via --driver-options if supported by your hardware.
 --open
   After scanning, open the scan via xdg-open
 -og, --option-group
   A named option group. Useful for saving collections of options under a name e.g. 'receipt' for easy reuse.
   Use this option in combination with '--help' to show the location and content of the file and edit it manually.

CONFIGURATION
<not shown, system-specific, run `--help` locally>
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

Command line argument `--option-group foo` (or `-og foo`) will read the
`foo` file in the standard XDG home config directory (use `-og foo --help`
to see the exact location) for configuration.

For example, if one wishes to scan receipts always with crop, deskew, unpaper
post-processing, and making them searchable via OCR, a `receipt` option group
can be created by writing the following to a file named `recept` in the
config directory:

```
CROP=1
DESKEW=1
UNPAPER=1
SEARCHABLE=1
```

Command-line arguments will overwride settings in the default and named
configurations.

### Tips

The default scanner device is set to `fujitsu`. If you have another scanner,
you will need to use the `-x`/`--device` argument to specify your scanner,
or save a `DEVICE=something` line to a local config file as shown above.
See below for how to get the list of available devices.

If running via `scanbd`, scanning occurs via the `net` driver rather than the
usual device driver. In this case, it may be necessary to specify the net
driver device in the `scanbd` script, OR perhaps do not specify any device
at all to let the script choose the best device when running outside of
`scanbd`, and when running via `scanbd`. To do this, use an empty device
i.e. `--device ""`.

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

## Blog Post Mentions

The following blog posts talk about scanner automation, and mention use of this
script. If you create a blog post, please submit a PR and add your link here!

* [Stefan Armbruster - Jan 1, 2019 - Running Paperless on FreeNAS](https://blog.armbruster-it.de/2019/01/running-paperless-on-freenas/)
* [Chris Schuld - Jan 8, 2020 - Network Scanner with Fujitsu ScanSnap and a Raspberry Pi](https://chrisschuld.com/2020/01/network-scanner-with-scansnap-and-raspberry-pi/)

## Other Useful Software

* [OCRmyPDF](https://github.com/jbarlow83/OCRmyPDF) - forgot to use the `--ocr` option at scanning time? use this
