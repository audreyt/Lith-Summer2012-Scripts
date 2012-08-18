#!/usr/bin/env livescript
args = try require(\optimist)argv
const MaskedOutput = args?m
const NamesOnly = args?n
const ColNameMap =
    電話: \phone
    地址: \address
    性別: \gender
    立思講座訊息: \info
    入場券: \whatever
    '從何處來？ ;-)': \from
    '身分證字號 / 護照號碼': \id
    '如需開立三聯式發票，請於下方填入買受人、統一編號與寄送地址，謝謝。': \seq
Rows = []
ColName = []

<- (require \csv)!.fromPath \lith2012.csv

.on \data (data) ->
    | ColName.length => Rows.push { [ColName[i], cell] for cell, i in data }
    | otherwise      => for d in data => ColName.push (ColNameMap[d] || d)

.on \end

HasSticker = <[ 
    1 2 3 4 5 6 7 8 9 12 14 19 20 21 22 24 26 27 34 36 37 38 39 43 44 45 46 47 48 49 55 58 64 65 68 70 75 78 79 80 81 82 83 87 88 90 91 93 95 96 98 100 106 107 113 120 123 127 132 134 136 146 147 149 150 151 153 156 176 180 181 184 194 196 201 227 230 231 234 242 243 245 260 263 264 265 266 267 269 270 271 272 279 282 289 291 292 294 295 299 301 307 311 326 330 331 339 341 342 345 346 347 349 350 351 353 354 355 359 361 363 366 368 370 371 376 377 380 383 384 385 387 388 389 392 395 396 397 400 407 409 413 414 420 423 425 431 432 433 436 447 451 452 455 459 463 468 472 474 475 477 481 482 485 486 487 488 489 492 493 495 503 505 506 509 510 511 512 514 517 518 520 521 523 524 525 526 527 529 530 533 534 536 537 538 539 540 543 544 546
    307 311 326 330 339 341 342 345 346 347 349 350 351 353 354 355 359 361 363 366 368 370 371 376 377 380 383 384 385 387 388 389 392 395 396 397 400 407 409 413 414 420 423 425 431 432 433 436 447 451 452 455 463 468 472 474 475 477 481 482 485 486 487 488 492 493 495 503 506 509 510 511 512 514 517 518 520 521 523 524 525 526 527 529 530 533 537 538 540 543 544 546 547 548 549 551 552 554 555 556 557 558 561 562 563 564 565 569 570 571 572 575 578 579 580 584 585 588 589 591 593 594 595 596 600 602 603 604 606 609 610 611 613 307 311 326 330 339 341 342 345 346 347 349 350 351 353 354 355 359 361 363 366 368 370 371 376 377 380 383 384 385 387 388 389 392 395 396 397 400 407 409 413 414 420 423 425 431 432 433 436 447 451 452 455 463 468 472 474 475 477 481 482 485 486 487 488 492 493 495 503 506 509 510 511 512 514 517 518 520 521 523 524 525 526 527 529 530 533 537 538 540 543 544 546 547 548 549 551 552 554 555 556 557 558
]>

# TODO: Add a new "marker" column:
# ☑   已繳費、有信封（二聯式發票，或現場領取三聯式）
# 🝔   同上，並領取小皂
#     已繳費、沒信封（已領過發票，或以其他方式繳費） 
# $   未繳費（有信封，預備現場繳費，填寫地址用）
for { name, cellphone, phone, address, ticket, reg_no, id, paid_at, seq } in Rows
| /挪威/.test ticket
    marker = ''
    if reg_no in <[ 439 ]> => continue
    # TODO: Cross-check with sticker output for the ○ case
    unless reg_no in HasSticker
        marker = " "
    unless paid_at
        marker = "$" unless reg_no in <[ 160 331 ]>
    if /\d{5}/.test seq
        # console.log reg_no
        marker = null unless reg_no in <[ 51 66 ]>
    marker ||= "☑"
    address = '' unless /.../.test address
    cellphone ||= phone || ''
    cellphone -= /-/g
    cellphone.=replace 886 0
    # cellphone.=replace /^0/ '০'
    id ||= cellphone
    id.=replace /[\u3000\uFF01-\uFF5E]/g ->
        # Fullwidth => Halfwidth
        String.fromCharCode(32 + it.charCodeAt(0) % 256)
    id.=toUpperCase!

    if MaskedOutput
        id = ''
        id = RegExp.$1 if cellphone.match /(\d{4})\s*$/
        name.=replace /(.)./ "$1○"
    else
        marker.=replace /☑/ "🝔" if reg_no <= 175

    if NamesOnly
        id = ''

    console.log "#reg_no\t#name\t#id\t#marker"
