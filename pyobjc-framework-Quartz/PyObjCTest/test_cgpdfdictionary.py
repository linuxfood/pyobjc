
from PyObjCTools.TestSupport import *
from Quartz.CoreGraphics import *

class TestCGPDFDictionary (TestCase):

    def testTypes(self):
        self.assertIsOpaquePointer(CGPDFDictionaryRef)

    def assertIsPDFGetter(self, function):
        self.assertArgIsIn(function, 1)
        self.assertArgIsNullterminated(function, 1)
        self.assertArgIsOut(function, 2)

    def testIncomplete(self):
        self.assertIsPDFGetter(CGPDFDictionaryGetObject)
        self.assertIsPDFGetter(CGPDFDictionaryGetBoolean)
        self.assertIsPDFGetter(CGPDFDictionaryGetInteger)
        self.assertIsPDFGetter(CGPDFDictionaryGetNumber)
        self.assertIsPDFGetter(CGPDFDictionaryGetName)
        self.assertIsPDFGetter(CGPDFDictionaryGetString)
        self.assertIsPDFGetter(CGPDFDictionaryGetArray)
        self.assertIsPDFGetter(CGPDFDictionaryGetDictionary)
        self.assertIsPDFGetter(CGPDFDictionaryGetStream)

        self.assertArgIsFunction(CGPDFDictionaryApplyFunction, 1, b"vn^t^{CGPDFObject=}^v", False)

    def testFunctions(self):
        CGPDFDictionaryGetCount

if __name__ == "__main__":
    main()
