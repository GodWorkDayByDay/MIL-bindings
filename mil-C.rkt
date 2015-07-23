#lang racket

#|

void MilApplication(HWND UserWindowHandle)
{
   /* MIL variables */
   MIL_ID MilApplication,  /* MIL Application identifier.  */
          MilSystem,       /* MIL System identifier.       */
          MilDisplay,      /* MIL Display identifier.      */
          MilDigitizer,    /* MIL Digitizer identifier.    */
          MilImage;        /* MIL Image buffer identifier. */
          
   long BufSizeX;
   long BufSizeY;
   long BufSizeBand;

   /* Allocate a MIL application. */
   MappAlloc(M_DEFAULT, &MilApplication);

   /* Allocate a MIL system. */
   MsysAlloc("M_DEFAULT", M_DEFAULT, M_DEFAULT, &MilSystem);

   /* Allocate a MIL display. */
   MdispAlloc(MilSystem, M_DEFAULT, "M_DEFAULT", M_WINDOWED, &MilDisplay);

...

|#

(require ffi/unsafe
         ffi/unsafe/define
         ffi/unsafe/alloc)

(define-ffi-definer mil-define (ffi-lib "./dlls/mil"))

;; CUSTOM TYPES
(define _MIL_ID _long)
(define _MIL_TEXT_PTR (_cpointer _bytes))
(define _MIL_INT64 _int64)
(define _MIL_INT32 _int32)

;; MACROS
(define M_NULL 0)
(define M_DEFAULT 268435456)
(define M_WINDOWED 16777216)
(define M_SYSTEM_DEFAULT_STRING (malloc _MIL_TEXT_PTR))
(ptr-set! M_SYSTEM_DEFAULT_STRING _bytes #"M_SYSTEM_DEFAULT")
(define M_DEFAULT_STRING (malloc _MIL_TEXT_PTR))
(ptr-set! M_DEFAULT_STRING _bytes #"M_DEFAULT")

;; DECLARED VARIABLES
(define MilApplication (malloc _MIL_ID))
(define MilSystem (malloc _MIL_ID))
(define MilDisplay (malloc _MIL_ID))

(mil-define MappAlloc       (_fun _long _MIL_ID -> _MIL_ID))
(mil-define MsysAlloc       (_fun _MIL_TEXT_PTR _long _long _MIL_ID -> _MIL_ID))
(mil-define MbufAllocColor  (_fun _MIL_ID _long _long _long _long _MIL_INT64 _MIL_ID -> _MIL_ID))
(mil-define MdispAlloc      (_fun _MIL_ID _long _MIL_TEXT_PTR _long _MIL_ID -> _MIL_ID))

(mil-define MappFree       (_fun _MIL_ID -> _void))
(mil-define MsysFree       (_fun _MIL_ID -> _void))
(mil-define MdispFree      (_fun _MIL_ID -> _void))

(define ApplicationIdentifier (MappAlloc M_DEFAULT (ptr-ref MilApplication _MIL_ID)))
(define SystemIdentifier (MsysAlloc (ptr-ref M_SYSTEM_DEFAULT_STRING _MIL_TEXT_PTR) M_DEFAULT M_DEFAULT (ptr-ref MilSystem _MIL_ID)))
(define DisplayIdentifier (MdispAlloc (ptr-ref MilSystem _MIL_ID) M_DEFAULT (ptr-ref M_DEFAULT_STRING _MIL_TEXT_PTR) M_WINDOWED (ptr-ref MilDisplay _MIL_ID)))

(MsysFree SystemIdentifier)
(MappFree ApplicationIdentifier)
(MdispFree DisplayIdentifier)

(free MilApplication)
(free MilSystem)
(free MilDisplay)
(free M_SYSTEM_DEFAULT_STRING)
(free M_DEFAULT_STRING)




