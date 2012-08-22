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
    17 18 25 35 41 57 59 66 67 69 71 74 76 77 94 105 114 124 137 145 154 157 158 159 161 167 168 172 173 174 177 178 179 186 189 192 193 200 202 204 210 214 215 218 219 222 228 232 233 235 237 238 246 247 252 253 254 255 257 262 274 276 293 302 303 304 305 317 328 329 365 373 375 381 386 403 404 410 411 412 434 437 441 445 449 450 457 460 461 464 465 469 478 483 484 491 494 496 497 498 499 500 501 504 508 516 519 522 528 531 542 581 582 586 592 598 599 601 607 608 615 616 617 618 619 620 621 622 623 624 625 626 627 628
]>

# TODO: Add a new "marker" column:
# ☑   已繳費、有信封（二聯式發票，或現場領取三聯式）
# 🝔   同上，並領取小皂
#     已繳費、沒信封（已領過發票，或以其他方式繳費） 
# $   未繳費（有信封，預備現場繳費，填寫地址用）
for { name, cellphone, phone, address, ticket, reg_no, id, paid_at, seq } in Rows
| /危險/.test ticket
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
