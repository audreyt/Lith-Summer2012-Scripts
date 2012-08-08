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
Seen = {}

onData(data) =
    | ColName.length => Rows.push { [ColName[i], cell] for cell, i in data }
    | otherwise      => for d in data => ColName.push (ColNameMap[d] || d)

onEnd(say=->) =
    for { name, email, info } in Rows
    | not /不用/.test info and not Seen[email - /\+[^@]/]
        Seen[email - /\+[^@]+/] = true
        say """
            "#name" <#email>
        """
    ColName = []

<- (require \csv)!.fromPath \lith2012.csv
    .on \data onData
    .on \end

onEnd!

<- (require \csv)!.fromPath \lith2012-gits.csv
    .on \data onData
    .on \end

onEnd console.log
