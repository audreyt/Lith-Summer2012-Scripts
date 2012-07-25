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

<- (require \csv)!.fromPath \lith2012-gits.csv

.on \data (data) ->
    | ColName.length => Rows.push { [ColName[i], cell] for cell, i in data }
    | otherwise      => for d in data => ColName.push (ColNameMap[d] || d)

.on \end

for { name, cellphone, phone, address, ticket, reg_no, id } in Rows
| /攻殼/.test ticket and reg_no not in [ 225 ]
    # name -= /\s/g
    address = '' unless /.../.test address
    cellphone ||= phone || ''
    cellphone -= /-/g
    cellphone.=replace 886 0
    id ||= cellphone
    console.log "*#reg_no\t#name\t#id"
