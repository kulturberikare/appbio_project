# Our own exception classes

class Error(Exception):
    '''Base class for other exceptions'''
    pass

class EmptyError(Error):
    '''Raised when input is empty'''
    pass

class FastaError(Error):
    pass

class TreeError(Error):
    '''Raised when input is not a tree'''
    pass
