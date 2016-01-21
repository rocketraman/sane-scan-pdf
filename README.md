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

## Requirements

* bash
* pnmtops (netpbm-progs)
* ps2pdf (ghostscript)

## Optional

* unpaper (for software deskew)
* flock (usually provided by util-linux) (for properly ordered verbose logs)
