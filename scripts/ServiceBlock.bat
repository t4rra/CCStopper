@echo off
setlocal EnableDelayedExpansion
mode con: cols=100 lines=46

:: Asks for Administrator Permissions
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

set LOCAL_ADDRESS=127.0.0.1
set BLOCKED_ADDRESSES="ic.adobe.io" "52.6.155.20" "52.10.49.85" "23.22.30.141" "34.215.42.13" "52.84.156.37" "65.8.207.109" "3.220.11.113" "3.221.72.231" "3.216.32.253" "3.208.248.199" "3.219.243.226" "13.227.103.57" "34.192.151.90" "34.237.241.83" "44.240.189.42" "52.20.222.155" "52.208.86.132" "54.208.86.132" "63.140.38.120" "63.140.38.160" "63.140.38.169" "63.140.38.219" "wip.adobe.com" "adobeereg.com" "18.228.243.121" "18.230.164.221" "54.156.135.114" "54.221.228.134" "54.224.241.105" "100.24.211.130" "162.247.242.20" "wip1.adobe.com" "wip2.adobe.com" "wip3.adobe.com" "wip4.adobe.com" "3dns.adobe.com" "ereg.adobe.com" "199.232.114.137" "bam.nr-data.net" "practivate.adobe" "ood.opsource.net" "crl.verisign.net" "3dns-1.adobe.com" "3dns-2.adobe.com" "3dns-3.adobe.com" "3dns-4.adobe.com" "hl2rcv.adobe.com" "genuine.adobe.com" "www.adobeereg.com" "www.wip.adobe.com" "www.wip1.adobe.com" "www.wip2.adobe.com" "www.wip3.adobe.com" "www.wip4.adobe.com" "ereg.wip.adobe.com" "ereg.wip.adobe.com" "activate.adobe.com" "adobe-dns.adobe.com" "ereg.wip1.adobe.com" "ereg.wip2.adobe.com" "ereg.wip3.adobe.com" "ereg.wip4.adobe.com" "ereg.wip1.adobe.com" "ereg.wip2.adobe.com" "ereg.wip3.adobe.com" "ereg.wip4.adobe.com" "cc-api-data.adobe.io" "practivate.adobe.ntp" "practivate.adobe.ipp" "practivate.adobe.com" "adobe-dns-1.adobe.com" "adobe-dns-2.adobe.com" "adobe-dns-3.adobe.com" "adobe-dns-4.adobe.com" "lm.licenses.adobe.com" "hlrcv.stage.adobe.com" "prod.adobegenuine.com" "practivate.adobe.newoa" "activate.wip.adobe.com" "activate-sea.adobe.com" "uds.licenses.adobe.com" "k.sni.global.fastly.net" "activate-sjc0.adobe.com" "activate.wip1.adobe.com" "activate.wip2.adobe.com" "activate.wip3.adobe.com" "activate.wip4.adobe.com" "na1r.services.adobe.com" "lmlicenses.wip4.adobe.com" "na2m-pr.licenses.adobe.com" "wwis-dubc1-vip60.adobe.com" "workflow-ui-prod.licensingstack.com"
set "HOST_FILE=%WINDIR%\system32\drivers\etc\hosts"

echo Hosts file : "!HOST_FILE!"
echo:
call :CHECK_FILE_ATTRIBUTES HOST_FILE || (
    goto :END
)
call :CHECK_FILE_NEWLINE HOST_FILE || (
    >>"!HOST_FILE!" (
        echo:
    ) || (
        goto :WRITING_FAILURE
    )
)
if defined start_counter (
    set start_counter=
)
set /a blocked_addresses[#]=0, number_of_lines_after_commented_line=0
for %%A in (!BLOCKED_ADDRESSES!) do (
    set /a blocked_addresses[#]+=1
)
for /f "usebackqdelims=" %%A in ("%WINDIR%\system32\drivers\etc\hosts") do (
    if defined start_counter (
        set /a number_of_lines_after_commented_line+=1
    )
    if "%%A"=="%COMMENTED_LINE%" (
        set /a start_counter=1, number_of_lines_after_commented_line=0
    )
)
if !number_of_lines_after_commented_line! leq !blocked_addresses[#]! (
    set commented_entry=1
)
for %%A in (!BLOCKED_ADDRESSES!) do (
    echo Adding to the hosts file: !LOCAL_ADDRESS! %%~A
    >NUL FINDSTR /ixc:"!LOCAL_ADDRESS! %%~A" "!HOST_FILE!" && (
        >"!HOST_FILE!.tmp" (
            findstr /ixvc:"!LOCAL_ADDRESS! %%~A" "!HOST_FILE!"
        ) || (
            goto :WRITING_FAILURE
        )
        for /l %%. in (1,1,100000) do rem
        move /y "!HOST_FILE!.tmp" "!HOST_FILE!" || (
            goto :WRITING_FAILURE
        )
    )
    if not defined commented_entry (
        set commented_entry=1
        >>"!HOST_FILE!" (
            echo %COMMENTED_LINE%
        ) || (
            goto :WRITING_FAILURE
        )
    )
    >>"!HOST_FILE!" (
        echo !LOCAL_ADDRESS! %%~A
    ) || (
        goto :WRITING_FAILURE
    )
)


netsh advfirewall firewall show rule name="CCStopper-CreditCardBlock" > nul
if errorlevel 1 (
    netsh advfirewall firewall add rule name="CCStopper-CreditCardBlock" dir=out program="%programfiles(x86)%\Common Files\Adobe\Adobe Desktop Common\ADS\Adobe Desktop Service.exe" profile=any action=block
) else (
    echo firewall rule exists!
)

cls
echo:
echo:
echo                   _______________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|                            CCSTOPPER                          ^|
echo                  ^|                         Made by eaaasun                       ^|
echo                  ^|                       ServiceBlock Module                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                       Patching completed.                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Exit                                                 ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:1 /N /M ">                                         Select [1]: "

cls
if errorlevel 1 (
    goto END
)
echo:

:END
start cmd /k %~dp0\..\CCStopper.bat
exit

:WRITING_FAILURE
call :CHECK_FILE_ATTRIBUTES HOST_FILE && (
    echo ERROR: Something went wrong and the script could not write in your hosts file.
)
pause
goto END

:CHECK_FILE_ATTRIBUTES
call :GET_FILE_ATTRIBUTES %1
if defined attributes (
    if not "!attributes:R=!"=="!attributes!" (
        echo Cannot write in "!%1!" because it is in read-only.
        exit /b 1
    )
)
exit /b 0

:GET_FILE_ATTRIBUTES
if not exist "!%1!" (
    exit /b
)
for %%A in ("!%1!") do (
    set "attributes=%%~aA"
)
for /f "delims=" %%A in ('2^>nul attrib "!%1!"') do (
    set "_attributes=%%A"
)
for /f "tokens=1*delims=:" %%A in ("$!_attributes!") do (
    if not "%%B"=="" (
        set "_attributes=%%A"
        set "_attributes=!_attributes:~1,-1!"
        if defined _attributes (
            set "attributes=!attributes!!_attributes!"
        )
    )
    if defined _attributes (
        set _attributes=
    )
)
if defined attributes (
    for %%A in (-," ") do (
        if defined attributes (
            set "attributes=!attributes:%%~A=!"
        )
    )
    if defined attributes (
        for /f "delims==" %%A in ('2^>nul set attribute_[') do (
            set %%A=
        )
        for /l %%A in (0,1,51) do (
            for %%B in ("!attributes:~%%A,1!") do (
                if not "%%~B"=="" (
                    for %%C in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
                        if /i "%%C"=="%%~B" (
                            if not defined attribute_[%%C] (
                                set attribute_[%%C]=1
                                if defined _attributes (
                                    if "!_attributes:%%C=!"=="!_attributes!" (
                                        set "_attributes=!_attributes!%%C"
                                    )
                                ) else (
                                    set "_attributes=%%C"
                                )
                            )
                        )
                    )
                )
            )
        )
        set "attributes=!_attributes!"
    )
)
exit /b

:CHECK_FILE_NEWLINE
if not exist "!%1!" (
    exit /b 0
)
<"!%1!" >nul (
    for %%A in ("!%1!") do (
        for /l %%. in (2 1 %%~zA) do (
            pause
        )
        set /p write_newline=
    )
)
if defined write_newline (
    set write_newline=
    exit /b 1
)
exit /b 0
