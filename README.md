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
* Truncate n pages from end of scan e.g. duplex scanning with last page truncated
* Specify page width and height for odd size pages, or common sizes (Letter, Legal, A4)
* Performance: scanner run in parallel with page post-processing

## Requirements

* bash
* pnmtops (netpbm-progs)
* ps2pdf (ghostscript)
* pdfunite

### Optional

* unpaper (for software deskew)
* flock (usually provided by util-linux) (for properly ordered verbose logs)
* tesseract (to make searchable PDFs)

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
   Mode e.g. Lineart (default), Halftone, Gray, Color, etc.
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
 --crop
   Crop to contents (driver must support this)
 --deskew
   Run driver deskew (driver must support this)
 --unpaper
   Run post-processing deskew and black edge detection (requires unpaper)
 --ocr
   Run OCR to make the PDF searchable (requires tesseract)

OUTPUT
 -o, --output <outputfile>
   Output to named file default=scan.pdf
 -l, --outputlist <outputfile-1...outputfile-n> Output to named files for each scanned page, can be used with append
```
