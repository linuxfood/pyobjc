/*
 * NSMovie mappings for special methods:
 * - QTMovie
 * - initWithMovie:
 *
 * Note: Python 2.3 is needed to make use of this functionality
 */
#include <Python.h>
#include <Foundation/Foundation.h>
#include "pyobjc-api.h"

#ifdef MACOSX

#include "pymactoolbox.h"

static PyObject* 
call_NSMovie_QTMovie(
	PyObject* method, PyObject* self, PyObject* arguments)
{
	PyObject* result;
	struct objc_super super;
	void*     movie;

	if  (!PyArg_ParseTuple(arguments, "")) {
		return NULL;
	}

	PyObjC_DURING
		PyObjC_InitSuper(&super, 
			PyObjCSelector_GetClass(method),
			PyObjCObject_GetObject(self));


		movie = objc_msgSendSuper(&super,
				PyObjCSelector_GetSelector(method));
	PyObjC_HANDLER
		PyObjCErr_FromObjC(localException);
		result = NULL;
		movie = NULL;
	PyObjC_ENDHANDLER

	if (movie == NULL) {
		if (PyErr_Occurred()) return NULL;
		result = Py_None;
		Py_INCREF(result);
	} else {
		result = MovieObj_New((Movie)movie);
	}

	return result;
}

static void 
imp_NSMovie_QTMovie(
	void* cif __attribute__((__unused__)), 
	void* resp, 
	void** args, 
	void* callable)
{
	id self = *(id*)args[0];
	//SEL _meth = *(SEL*)args[1];
	Movie* pretval = (Movie*)resp;

	PyObject* result;
	PyObject* arglist = NULL;
	PyObject* pyself = NULL;
	int cookie = 0;

	PyGILState_STATE state = PyGILState_Ensure();

	arglist = PyTuple_New(1);
	if (arglist == NULL) goto error;

	pyself = PyObjCObject_NewTransient(self, &cookie);
	if (pyself == NULL) goto error;
	PyTuple_SetItem(arglist, 0, pyself); 
	Py_INCREF(pyself);

	result = PyObject_Call((PyObject*)callable, arglist, NULL);
	Py_DECREF(arglist); arglist = NULL;
	PyObjCObject_ReleaseTransient(pyself, cookie); pyself = NULL;
	if (result == NULL) goto error;

	MovieObj_Convert(result, pretval);
	Py_DECREF(result);

	if (PyErr_Occurred()) goto error;
	
	PyGILState_Release(state);
	return;


error:
	Py_XDECREF(arglist);
	if (pyself) {
		PyObjCObject_ReleaseTransient(pyself, cookie); 
	}
	*pretval = NULL;
	PyObjCErr_ToObjCWithGILState(&state);
}


static PyObject* 
call_NSMovie_initWithMovie_(
	PyObject* method, PyObject* self, PyObject* arguments)
{
	PyObject* result;
	struct objc_super super;
	void*     movie;
	id        objc_result;

	if  (!PyArg_ParseTuple(arguments, "O&", MovieObj_Convert, &movie)) {
		return NULL;
	}

	PyObjC_DURING
		PyObjC_InitSuper(&super, 
			PyObjCSelector_GetClass(method),
			PyObjCObject_GetObject(self));

		objc_result = objc_msgSendSuper(&super,
				PyObjCSelector_GetSelector(method), movie);
	PyObjC_HANDLER
		PyObjCErr_FromObjC(localException);
		objc_result = nil;
		result = NULL;
	PyObjC_ENDHANDLER
	
	if (objc_result == nil && PyErr_Occurred()) return NULL;

	result = PyObjC_IdToPython(objc_result);

	return result;
}

static void 
imp_NSMovie_initWithMovie_(
	void* cif __attribute__((__unused__)), 
	void* resp, 
	void** args, 
	void* callable)
{
	id self = *(id*)args[0];
	//SEL _meth = *(SEL*)args[1];
	Movie movie = *(Movie*)args[2];
	id* pretval = (id*)resp;

	PyObject* result;
	PyObject* arglist = NULL;
	PyObject* v;
	PyObject* pyself = NULL;
	int cookie = 0;

	PyGILState_STATE state = PyGILState_Ensure();

	arglist = PyTuple_New(1);
	if (arglist == NULL) goto error;

	pyself = PyObjCObject_NewTransient(self, &cookie);
	if (pyself == NULL) goto error;
	PyTuple_SetItem(arglist, 0, pyself); 
	Py_INCREF(pyself);
	
	v = MovieObj_New(movie);
	if (v == NULL) goto error;
	PyTuple_SET_ITEM(arglist, 1, v);

	result = PyObject_Call((PyObject*)callable, arglist, NULL);
	Py_DECREF(arglist); arglist = NULL;
	PyObjCObject_ReleaseTransient(pyself, cookie); pyself = NULL;
	if (result == NULL) goto error;

	*pretval = PyObjC_PythonToId(result);
	if (*pretval == nil && PyErr_Occurred()) goto error;

	PyGILState_Release(state);
	return;

error:
	Py_XDECREF(arglist);
	if (pyself) {
		PyObjCObject_ReleaseTransient(pyself, cookie); 
	}
	*pretval = nil;
	PyObjCErr_ToObjCWithGILState(&state);
}

#endif

static int 
_pyobjc_install_NSMovie(void)
{

#ifdef MACOSX
	if (PyObjC_RegisterMethodMapping(objc_lookUpClass("NSMovie"), 
		@selector(QTMovie),
		call_NSMovie_QTMovie,
		imp_NSMovie_QTMovie) < 0 ) {

		return -1;
	}

	if (PyObjC_RegisterMethodMapping(objc_lookUpClass("NSMovie"), 
		@selector(initWithMovie:),
		call_NSMovie_initWithMovie_,
		imp_NSMovie_initWithMovie_) < 0 ) {

		return -1;
	}
#endif /* MACOSX */

	return 0;
}