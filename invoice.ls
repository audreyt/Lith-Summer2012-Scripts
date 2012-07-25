#!/usr/bin/env livescript
ColNameMap =
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

for { reg_no, name, ticket, seq } in Rows
| /高更/.test ticket and not /攻殼/.test ticket and reg_no not in [ 225 ] and not seq
    name -= /\s/g
    price = priceOf ticket
    ticket = ticket .replace /】/g  "】\n"
                    .replace /預售/ "   預售"

    console.log """
2012-07-29
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
