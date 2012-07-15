#!/usr/bin/env livescript
ColNameMap =
    電話: \tel
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

for { reg_no, name } in Rows
    name -= /\s/g
    console.log "特 #reg_no\t#name"
