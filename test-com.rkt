#lang racket

#|
(require ffi/unsafe
         ffi/unsafe/define
         ffi/com)

(define-ffi-definer mil-define (ffi-lib "mil"))

(define M_NULL (_cpointer 'M_NULL))

(define _MIL_ID _long)

(mil-define MappAlloc (_fun _long _MIL_ID -> _MIL_ID))

(get-ffi-obj MappAlloc (ffi-lib "mil") (_fun _long _MIL_ID -> _MIL_ID))
|#

(require ffi/unsafe/com
         ffi/com-registry
         racket/gui
         racket/trace)
(require (only-in lang/htdp-advanced string-contains?))

(define mil-control-lst
  (for/list ([x (com-all-controls)]
             #:when ((lambda (x) (string-contains? "ActiveMIL" x)) x)) x))

(define mil-image (com-create-instance  "mil.image"))
(define mil-display (com-create-instance  "mil.display"))
(define mil-system (com-create-instance  "mil.system"))

(define mil-app (com-create-instance  "mil.application"))
(define mil-calib (com-create-instance  "mil.calibration"))
(define mil-blob (com-create-instance  "mil.blobanalysis"))
(define mil-char (com-create-instance  "mil.characterrecognition"))
(define mil-code (com-create-instance  "mil.code"))
(define mil-digitizer (com-create-instance  "mil.digitizer"))
(define mil-edge (com-create-instance  "mil.edgefinder"))
(define mil-graphic (com-create-instance  "mil.graphiccontext"))
(define mil-imgproc (com-create-instance  "mil.imageprocessing"))
(define mil-measure (com-create-instance  "mil.measurement"))
(define mil-model (com-create-instance  "mil.modelfinder"))
(define mil-patmatch (com-create-instance  "mil.patternmatching"))
(define mil-threading (com-create-instance  "mil.threading"))

(com-set-property! mil-system "automaticallocation" #t)
(com-set-property! mil-display "imagename" mil-image)
(com-set-property! mil-display "ownersystem" mil-system)
(com-set-property! (com-get-property mil-display "image") "candisplay" #t)
(com-invoke mil-system "allocate")
(com-invoke mil-image "allocate")
(com-invoke mil-image "load" "C://Documents and Settings//TECHNODIGM//Desktop//ids.rkt//mil//80brightness_1stpiece_1.bmp" #t)
(com-invoke mil-display "allocate")

(define frame (new frame%
                   [label "hai"]))
(define canvas (new canvas%
                    [parent frame]))