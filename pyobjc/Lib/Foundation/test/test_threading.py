import unittest
import objc
import sys
import time

from objc.test import testbndl

from Foundation import *

# Make sure the interpreter is in 'multi-threaded mode', otherwise new
# threads that are not created in Python will cause a crash.
objc.enableThreading()

class ThreadingTest (unittest.TestCase):
    def setUp(self):
        # Set a very small check interval, this will make it more likely
        # that the interpreter crashes when threading is done incorrectly.
        self._int = sys.getcheckinterval()
        sys.setcheckinterval(1)

    def tearDown(self):
        sys.setcheckinterval(self._int)

    def testNSObjectString(self):

        class PyObjCTestThreadRunnerString (NSObject):
            def init(self):
                self = super(PyObjCTestThreadRunnerString, self).init()
                if self is None: return None

                self.storage = []
                return self

            def run_(self, argument):
                NSAutoreleasePool.alloc().init()
                self.storage.append(argument)

        myObj = PyObjCTestThreadRunnerString.alloc().init()

        NSThread.detachNewThreadSelector_toTarget_withObject_(
                'run:', myObj, u"hello world")

        time.sleep(2)
        self.assertEquals(myObj.storage[0], u"hello world")

    def testNSObject(self):

        class PyObjCTestThreadRunner (NSObject):
            def run_(self, argument):
                NSAutoreleasePool.alloc().init()
                for i in range(100):
                    argument.append(i)

        myObj = PyObjCTestThreadRunner.alloc().init()
        lst = []

        NSThread.detachNewThreadSelector_toTarget_withObject_(
                'run:', myObj, lst)

        lst2 = []
        for i in range(100):
            lst2.append(i*2)

        time.sleep(2)
        self.assertEquals(lst, range(100))

    def testPyObject(self):

        class TestThreadRunner :
            def run_(self, argument):
                for i in range(100):
                    argument.append(i)

        myObj = TestThreadRunner()
        lst = []

        NSThread.detachNewThreadSelector_toTarget_withObject_(
                'run:', myObj, lst)

        lst2 = []
        for i in range(100):
            lst2.append(i*2)

        time.sleep(2)
        self.assertEquals(lst, range(100))

    def testCalling(self):
        class Dummy:
            pass
        class PyObjCTestCalling (NSObject) :
            def call(self):
                return Dummy()

        my = testbndl.PyObjC_TestClass4.alloc().init()
        cb = PyObjCTestCalling.alloc().init()

        NSThread.detachNewThreadSelector_toTarget_withObject_(
                'runThread:', my,  cb)

        time.sleep(2)

        retval = my.returnObject()
        self.assert_(isinstance(retval, Dummy))

if __name__ == "__main__":
    unittest.main()