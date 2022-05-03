@REM Checks for existence of a line in hosts file and adds it if it doesn't exist
@REM Thanks:
@REM https://stackoverflow.com/a/46453499
@REM https://github.com/sh32devnull 

setlocal EnableDelayedExpansion

@REM set "hosts=C:\WINDOWS\System32\drivers\etc\hosts"
@REM Not using real hosts file b/c im not risking it lmao
set "hosts=%userprofile%\Desktop\test.txt"


@echo off
setlocal enabledelayedexpansion

set  "arrayline[0]=127.0.0.1 ic.adobe.io"
set  "arrayline[1]=127.0.0.1 wip.adobe.com"
set  "arrayline[2]=127.0.0.1 adobeereg.com"
set  "arrayline[3]=127.0.0.1 wip1.adobe.com"
set  "arrayline[4]=127.0.0.1 wip2.adobe.com"
set  "arrayline[5]=127.0.0.1 wip3.adobe.com"
set  "arrayline[6]=127.0.0.1 wip4.adobe.com"
set  "arrayline[7]=127.0.0.1 3dns.adobe.com"
set  "arrayline[8]=127.0.0.1 ereg.adobe.com"
set  "arrayline[9]=127.0.0.1 practivate.adobe"
set  "arrayline[10]=127.0.0.1 3dns-1.adobe.com"
set  "arrayline[11]=127.0.0.1 3dns-2.adobe.com"
set  "arrayline[12]=127.0.0.1 3dns-3.adobe.com"
set  "arrayline[13]=127.0.0.1 3dns-4.adobe.com"
set  "arrayline[14]=127.0.0.1 hl2rcv.adobe.com"
set  "arrayline[15]=127.0.0.1 genuine.adobe.com"
set  "arrayline[16]=127.0.0.1 www.adobeereg.com"
set  "arrayline[17]=127.0.0.1 www.wip.adobe.com"
set  "arrayline[18]=127.0.0.1 www.wip1.adobe.com"
set  "arrayline[19]=127.0.0.1 www.wip2.adobe.com"
set  "arrayline[20]=127.0.0.1 www.wip3.adobe.com"
set  "arrayline[21]=127.0.0.1 www.wip4.adobe.com"
set  "arrayline[22]=127.0.0.1 ereg.wip.adobe.com"
set  "arrayline[23]=127.0.0.1 ereg.wip.adobe.com"
set  "arrayline[24]=127.0.0.1 activate.adobe.com"
set  "arrayline[25]=127.0.0.1 adobe-dns.adobe.com"
set  "arrayline[26]=127.0.0.1 ereg.wip1.adobe.com"
set  "arrayline[27]=127.0.0.1 ereg.wip2.adobe.com"
set  "arrayline[28]=127.0.0.1 ereg.wip3.adobe.com"
set  "arrayline[29]=127.0.0.1 ereg.wip4.adobe.com"
set  "arrayline[30]=127.0.0.1 ereg.wip1.adobe.com"
set  "arrayline[31]=127.0.0.1 ereg.wip2.adobe.com"
set  "arrayline[32]=127.0.0.1 ereg.wip3.adobe.com"
set  "arrayline[33]=127.0.0.1 ereg.wip4.adobe.com"
set  "arrayline[34]=127.0.0.1 cc-api-data.adobe.io"
set  "arrayline[35]=127.0.0.1 practivate.adobe.ntp"
set  "arrayline[36]=127.0.0.1 practivate.adobe.ipp"
set  "arrayline[37]=127.0.0.1 practivate.adobe.com"
set  "arrayline[38]=127.0.0.1 adobe-dns-1.adobe.com"
set  "arrayline[39]=127.0.0.1 adobe-dns-2.adobe.com"
set  "arrayline[40]=127.0.0.1 adobe-dns-3.adobe.com"
set  "arrayline[41]=127.0.0.1 adobe-dns-4.adobe.com"
set  "arrayline[42]=127.0.0.1 lm.licenses.adobe.com"
set  "arrayline[43]=127.0.0.1 hlrcv.stage.adobe.com"
set  "arrayline[44]=127.0.0.1 prod.adobegenuine.com"
set  "arrayline[45]=127.0.0.1 practivate.adobe.newoa"
set  "arrayline[46]=127.0.0.1 activate.wip.adobe.com"
set  "arrayline[47]=127.0.0.1 activate-sea.adobe.com"
set  "arrayline[48]=127.0.0.1 uds.licenses.adobe.com"
set  "arrayline[49]=127.0.0.1 activate-sjc0.adobe.com"
set  "arrayline[50]=127.0.0.1 activate.wip1.adobe.com"
set  "arrayline[51]=127.0.0.1 activate.wip2.adobe.com"
set  "arrayline[52]=127.0.0.1 activate.wip3.adobe.com"
set  "arrayline[53]=127.0.0.1 activate.wip4.adobe.com"
set  "arrayline[54]=127.0.0.1 na1r.services.adobe.com"
set  "arrayline[55]=127.0.0.1 lmlicenses.wip4.adobe.com"
set  "arrayline[56]=127.0.0.1 na2m-pr.licenses.adobe.com"
set  "arrayline[57]=127.0.0.1 wwis-dubc1-vip60.adobe.com"
set  "arrayline[58]=127.0.0.1 workflow-ui-prod.licensingstack.com"

::read it using a FOR /L statement
for /l %%n in (0,1,58) do (
    findstr /c:"!arrayline[%%n]!" "%hosts%" 1>nul 2>nul || (
      (echo (!arrayline[%%n]!)>>"%hosts%" 
    )
)
echo "complete"
pause