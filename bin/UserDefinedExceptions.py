# User-defined exception classes

class Error(Exception):
    '''Base class for other exceptions'''
    pass

class EmptyFileError(Error):
    '''Raised when input file is empty or whitespace only'''
    pass

class EmptySeqError(Error):
    '''Raised when sequence is empty or whitespace only'''
    pass

class FastaFileError(Error):
    '''Raised when file is not a Fasta file'''
    pass

class TreeError(Error):
    '''Raised when input is not a tree'''
    pass
