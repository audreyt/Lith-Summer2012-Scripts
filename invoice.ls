#!/usr/bin/env livescript
const IsPrintingStickerOnly = false
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

priceOf = ->
    | /五場套票/.test it => 3650
    | /四場套票/.test it => 2920
    | /優惠套票/.test it => 1480
    | /學生票/.test   it => 750
    | otherwise          => throw "Impossible: #it"

<- (require \csv)!.fromPath \lith2012.csv

.on \data (data) ->
    | ColName.length => Rows.push { [ColName[i], cell] for cell, i in data }
    | otherwise      => for d in data => ColName.push (ColNameMap[d] || d)

.on \end

AlreadyPrinted = <[
    23 33 50 54 97 101 103 104 116 130 175 183 191 273 280 283 286 287 298 308 312 315 318 319 321 327 335 336 338 348 378 402 406 417 439 440 444 454 458
]>
StickerNames = []

for { reg_no, name, ticket, seq, paid_at } in Rows
| /手記/.test ticket and not /高更/.test ticket and not /攻殼/.test ticket and reg_no not in AlreadyPrinted and (not /\d{5}/.test seq or reg_no in <[ 50 ]>) and (paid_at or IsPrintingStickerOnly)
    name -= /\s/g

    if IsPrintingStickerOnly
        console.log "#reg_no\n\n"
        StickerNames.push name
        if StickerNames.length is 8
            for n in StickerNames => console.log n
            StickerNames = []
        continue

    price = priceOf ticket
    ticket = ticket .replace /】/g  "】\n"
                    .replace /預售/ "   預售"
                    .replace /\+ /g "+"

    console.log """
2012-08-05
======================
夏天．愛思考．系列講座

 #ticket
----------------------
  報名人：#name
    合計：$#price
    序號：##reg_no
----------------------
 立思科技藝術有限公司
 營業人統編：53343434

   http://lith.tw/
======================
.
"""

for n in StickerNames => console.log n if IsPrintingStickerOnly

1
