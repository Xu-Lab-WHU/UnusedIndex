/*****************************************************************************
  slopBed.cpp

  (c) 2009 - Aaron Quinlan
  Hall Laboratory
  Department of Biochemistry and Molecular Genetics
  University of Virginia
  aaronquinlan@gmail.com

  Licensed under the GNU General Public License 2.0 license.
******************************************************************************/
#include "lineFileUtilities.h"
#include "slopBed.h"


BedSlop::BedSlop(string &bedFile, string &genomeFile, bool forceStrand, 
                 float leftSlop, float rightSlop, bool fractional,
                 bool printHeader) {

    _bedFile     = bedFile;
    _genomeFile  = genomeFile;
    _forceStrand = forceStrand;
    _leftSlop    = leftSlop;
    _rightSlop   = rightSlop;
    _fractional  = fractional;
    _printHeader = printHeader;

    _bed    = new BedFile(bedFile);
    _genome = new GenomeFile(genomeFile);

    // get going, slop it up.
    SlopBed();
}


BedSlop::~BedSlop(void) {

}


void BedSlop::SlopBed() {

    BED bedEntry;     // used to store the current BED line from the BED file.

    _bed->Open();
    // report header first if asked.
    if (_printHeader == true) {
        _bed->PrintHeader();
    }        
    while (_bed->GetNextBed(bedEntry)) {    
        if (_bed->_status == BED_VALID) {
            if (_fractional == false) {
                AddSlop(bedEntry);
            }
            else {
                _leftSlop  = _leftSlop  * (float)bedEntry.size();
                _rightSlop = _rightSlop * (float)bedEntry.size();
                AddSlop(bedEntry);
            }
            _bed->reportBedNewLine(bedEntry);
        }
    }
    _bed->Close();
}


void BedSlop::AddSlop(BED &bed) {

    // special handling if the BED entry is on the negative
    // strand and the user cares about strandedness.
    CHRPOS chromSize = (CHRPOS)_genome->getChromSize(bed.chrom);

    if ( (_forceStrand) && (bed.strand == "-") ) {
        if ( ((int)bed.start - (int)_rightSlop) >= 0 )
            bed.start = bed.start - (int)_rightSlop;
        else
            bed.start = 0;

        if ( ((CHRPOS)bed.end + (CHRPOS)_leftSlop) <= chromSize )
            bed.end = bed.end + (int)_leftSlop;
        else
            bed.end = chromSize;
    }
    else {
    	if ( ((int)bed.start - (int)_leftSlop) >= 0 )
            bed.start = bed.start - (int)_leftSlop;
        else
            bed.start = 0;

        if ( ((CHRPOS)bed.end + (CHRPOS)_rightSlop) <= chromSize )
            bed.end = bed.end + (int)_rightSlop;
        else
            bed.end = chromSize;
    }
}


