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

<- (require \csv)!.fromPath \lith2012.csv

.on \data (data) ->
    | ColName.length => Rows.push { [ColName[i], cell] for cell, i in data }
    | otherwise      => for d in data => ColName.push (ColNameMap[d] || d)

.on \end

# TODO: Add a new "marker" column:
#     已繳費、有信封（二聯式發票，或現場領取三聯式）
# ○   已繳費、沒信封（已領過發票，或以其他方式繳費） 
# $   未繳費（有信封，預備現場繳費，填寫地址用）
for { name, cellphone, phone, address, ticket, reg_no, id, paid_at } in Rows
| /手記/.test ticket
    # name -= /\s/g
    marker = ''
    if reg_no in <[ 439 ]>
        continue
    # TODO: Cross-check with sticker output for the ○ case
    unless paid_at
        marker = "$" unless reg_no in <[ 160 ]>
    address = '' unless /.../.test address
    cellphone ||= phone || ''
    cellphone -= /-/g
    cellphone.=replace 886 0
    id ||= cellphone
    id.=replace /[\u3000\uFF01-\uFF5E]/g ->
        # Fullwidth => Halfwidth
        String.fromCharCode(32 + it.charCodeAt(0) % 256)
    id.=toUpperCase!
    console.log "#reg_no\t#name\t#id\t#marker"
