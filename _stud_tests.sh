#!/usr/bin/env bash

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# IPP - cls - doplňkové testy - 2015/2016
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Činnost:
# - vytvoří výstupy studentovy úlohy v daném interpretu na základě sady testů
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Popis (README):
#
# Struktura skriptu _stud_tests.sh (v kódování UTF-8):
# Každý test zahrnuje až 4 soubory (vstupní soubor, případný druhý vstupní
# soubor, výstupní soubor, soubor logující chybové výstupy *.err (zde vynechány)
# a soubor logující návratový kód skriptu *.!!!).
# Pro spuštění testů je nutné do stejného adresáře zkopírovat i
# váš skript. V komentářích u jednotlivých testů jsou uvedeny dodatečné
# informace jako očekávaný návratový kód.
# Tyto doplňující testy obsahují i několik testů rozšíření (viz konec skriptu).
#
# Proměnné ve skriptu _stud_tests.sh pro konfiguraci testů:
#  INTERPRETER - využívaný interpret
#  EXTENSION - přípona souboru s vaším skriptem (jméno skriptu je dáno úlohou)
#  LOCAL_IN_PATH/LOCAL_OUT_PATH - testování různých cest ke vstupním/výstupním
#    souborům
#
# Další soubory archivu s doplňujícími testy:
# V adresáři ref-out najdete referenční soubory pro výstup (*.out nebo *.xml),
# referenční soubory s návratovým kódem (*.!!!) a pro ukázku i soubory s
# logovaným výstupem ze standardního chybového výstupu (*.err). Pokud některé
# testy nevypisují nic na standardní výstup nebo na standardní chybový výstup,
# tak může odpovídající soubor v adresáři chybět nebo mít nulovou velikost.
#
# Doporučení a poznámky k testování:
# Tento skript neobsahuje mechanismy pro automatické porovnávání výsledků vašeho
# skriptu a výsledků referenčních (viz adresář ref-out). Pokud byste rádi
# využili tohoto skriptu jako základ pro váš testovací rámec, tak doporučujeme
# tento mechanismus doplnit.
# Dále doporučujeme testovat různé varianty relativních a absolutních cest
# vstupních a výstupních souborů, k čemuž poslouží proměnné začínající
# LOCAL_IN_PATH a LOCAL_OUT_PATH (neomezujte se pouze na zde uvedené triviální
# varianty).
# Výstupní soubory mohou při spouštění vašeho skriptu již existovat a pokud není
# u zadání specifikováno jinak, tak se bez milosti přepíší!
# Výstupní soubory nemusí existovat a pak je třeba je vytvořit!
# Pokud běh skriptu skončí s návratovou hodnotou různou od nuly, tak není
# vytvoření souboru zadaného parametrem --output nutné, protože jeho obsah
# stejně nelze považovat za validní.
# V testech se jako pokaždé určitě najdou nějaké chyby nebo nepřesnosti, takže
# pokud nějakou chybu najdete, tak na ni prosím upozorněte ve fóru příslušné
# úlohy (konstruktivní kritika bude pozitivně ohodnocena). Vyhrazujeme si také
# právo testy měnit, opravovat a případně rozšiřovat, na což samozřejmě
# upozorníme na fóru dané úlohy.
#
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#!!!!POZOR NA UMIESTENIE TESK!!!
TASK=cls
#INTERPRETER="php -d open_basedir=\"\""
#EXTENSION=php
INTERPRETER=python3
EXTENSION=py

# cesty ke vstupním a výstupním souborům
LOCAL_IN_PATH="./" # (simple relative path)
LOCAL_IN_PATH2="" #Alternative 1 (primitive relative path)
LOCAL_IN_PATH3=`pwd`"/" #Alternative 2 (absolute path)
LOCAL_OUT_PATH="./moj-out/" # (simple relative path)
LOCAL_OUT_PATH2="./moj-out/" #Alternative 1 (primitive relative path)
LOCAL_OUT_PATH3=`pwd`"/moj-out/" #Alternative 2 (absolute path)
# cesta pro ukládání chybového výstupu studentského skriptu
LOG_PATH="./moj-out/"
COUNT=0
ALL=0
mkdir -p moj-out

#10 test for invalid arguments;  Expected return code for all: 1

#test000
$INTERPRETER $TASK.$EXTENSION notThis 2> ${LOG_PATH}test000.err
echo -n $? > ${LOG_PATH}test000.!!!

#test001
$INTERPRETER $TASK.$EXTENSION  --invalidArgument 2> ${LOG_PATH}test001.err
echo -n $? > ${LOG_PATH}test001.!!!

#test002
$INTERPRETER $TASK.$EXTENSION  --input=${LOCAL_IN_PATH}test01.in --output=${LOCAL_OUT_PATH}test01.out --input=${LOCAL_IN_PATH}test01.in 2> ${LOG_PATH}test002.err
echo -n $? > ${LOG_PATH}test002.!!!

#test003
$INTERPRETER $TASK.$EXTENSION  --help --input=f 2> ${LOG_PATH}test003.err
echo -n $? > ${LOG_PATH}test003.!!!

#test004
$INTERPRETER $TASK.$EXTENSION  --help slovo 2> ${LOG_PATH}test004.err
echo -n $? > ${LOG_PATH}test004.!!!

#test005
$INTERPRETER $TASK.$EXTENSION  $TASK.$EXTENSION 2> ${LOG_PATH}test005.err
echo -n $? > ${LOG_PATH}test005.!!!

#test006
$INTERPRETER $TASK.$EXTENSION  --input 2> ${LOG_PATH}test006.err
echo -n $? > ${LOG_PATH}test006.!!!

#test007
$INTERPRETER $TASK.$EXTENSION  --input= 2> ${LOG_PATH}test007.err
echo -n $? > ${LOG_PATH}test007.!!!

#test008
$INTERPRETER $TASK.$EXTENSION  --pretty-xml= 2> ${LOG_PATH}test008.err
echo -n $? > ${LOG_PATH}test008.!!!

#test009
$INTERPRETER $TASK.$EXTENSION  --input=${LOCAL_IN_PATH}test01.in --output=${LOCAL_OUT_PATH}test009.out --pretty-xml=4 --details=C --seach="hello" --what 2> ${LOG_PATH}test009.err
echo -n $? > ${LOG_PATH}test009.!!!

#non existing file on input (if file with that name exists in your computer, you have some problems)
$INTERPRETER $TASK.$EXTENSION  --input=ILoveWindows 2> ${LOG_PATH}test00a.err
echo -n $? > ${LOG_PATH}test00a.!!!

#not a file, but directory, error 2
$INTERPRETER $TASK.$EXTENSION  --input=ILoveWindows/ 2> ${LOG_PATH}test00b.err
echo -n $? > ${LOG_PATH}test00b.!!!

#missing permission (if you run it as sudo, ask yourself -> Why?)
$INTERPRETER $TASK.$EXTENSION  --input=/etc/shadow 2> ${LOG_PATH}test00c.err
echo -n $? > ${LOG_PATH}test00c.!!!

#help with option? error 1
$INTERPRETER $TASK.$EXTENSION  --help=me 2> ${LOG_PATH}test00d.err
echo -n $? > ${LOG_PATH}test00d.!!!

#invalit output - no permission
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test01.in --output=/bin/kill 2> ${LOG_PATH}test00e.err
echo -n $? > ${LOG_PATH}test00e.!!!

# technically test01 but with output to stdout; Expected output: test00f.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test01.in >${LOCAL_OUT_PATH}test00f.out 2> ${LOG_PATH}test00f.err
echo -n $? > ${LOG_PATH}test00f.!!!

# test01: zakladni strom dedicnosti; Expected output: test01.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test01.in --output=${LOCAL_OUT_PATH}test01.out 2> ${LOG_PATH}test01.err
echo -n $? > ${LOG_PATH}test01.!!!

# test02: vypis bazove tridy; Expected output: test02.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test02.in > ${LOCAL_OUT_PATH}test02.out --details=A 2> ${LOG_PATH}test02.err
echo -n $? > ${LOG_PATH}test02.!!!

# test03: vypis dedici tridy; Expected output: test03.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test03.in --output=${LOCAL_OUT_PATH}test03.out --details=D 2> ${LOG_PATH}test03.err
echo -n $? > ${LOG_PATH}test03.!!!

# test04: dedeni ciste virtualni metody => vsechny tridy abstraktni; Expected output: test04.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION < ${LOCAL_IN_PATH3}test04.in > ${LOCAL_OUT_PATH}test04.out 2> ${LOG_PATH}test04.err
echo -n $? > ${LOG_PATH}test04.!!!

# test05: prepsani ciste virtualni metody => dedici tridy nejsou abstraktni; Expected output: test05.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test05.in --output=${LOCAL_OUT_PATH}test05.out 2> ${LOG_PATH}test05.err
echo -n $? > ${LOG_PATH}test05.!!!

# test06: dedici schema diamant => konflikt pri dedeni; Expected output: test06.out; Expected return code: 21
$INTERPRETER $TASK.$EXTENSION --output=${LOCAL_OUT_PATH3}test06.out < ${LOCAL_IN_PATH}test06.in --details=D 2> ${LOG_PATH}test06.err
echo -n $? > ${LOG_PATH}test06.!!!

# test07: dedici schema diamant => zabraneni konfliktu prepsanim konf. clenu; Expected output: test07.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --details=D --input=${LOCAL_IN_PATH}test07.in --output=${LOCAL_OUT_PATH2}test07.out 2> ${LOG_PATH}test07.err
echo -n $? > ${LOG_PATH}test07.!!!

# test08: reseni konfliktu pri dedeni kl. slovem using; Expected output: test08.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test08.in --output=${LOCAL_OUT_PATH3}test08.out --details=C 2> ${LOG_PATH}test08.err
echo -n $? > ${LOG_PATH}test08.!!!

# test09: ukazka hlubsiho vypisu lesu dedicnosti; Expected output: test09.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH2}test09.in --output=${LOCAL_OUT_PATH}test09.out 2> ${LOG_PATH}test09.err
echo -n $? > ${LOG_PATH}test09.!!!

# test10: vypsani detailu vsech trid v souboru; Expected output: test10.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --details --input=${LOCAL_IN_PATH3}test10.in --output=${LOCAL_OUT_PATH}test10.out 2> ${LOG_PATH}test10.err
echo -n $? > ${LOG_PATH}test10.!!!

# test11: Vyhledavani pomoci XPath; Expected output: test11.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test11.in --output=${LOCAL_OUT_PATH2}test11.out --details --search="/model/class[*/attributes/attribute/@name='var']/@name" 2> ${LOG_PATH}test11.err
echo -n $? > ${LOG_PATH}test11.!!!

# test12: BONUS: vypis konfliktniho clenu ve tride; Expected output: test12.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH3}test12.in --output=${LOCAL_OUT_PATH}test12.out --details=C --conflicts 2> ${LOG_PATH}test12.err
echo -n $? > ${LOG_PATH}test12.!!!

# test13: Nevypsani zdedeneho clenu, ktery byl v dedene tride private a ktery neni pure virtual metodou; Expected output:  test13.out; Exptected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH3}test13.in --output=${LOCAL_OUT_PATH}test13.out --details=B 2> ${LOG_PATH}test13.err
echo -n $? > ${LOG_PATH}test13.!!!

# test014: Test 09 but with awful format (for weak parsers); Expected output: test014.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH2}test014.in --output=${LOCAL_OUT_PATH}test014.out 2> ${LOG_PATH}test014.err
echo -n $? > ${LOG_PATH}test014.!!!

# test014: Test similiar to test08, but conflict in fuctions solved with using. Expected output: test015.out Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH2}test015.in --output=${LOCAL_OUT_PATH}test015.out --details=D 2> ${LOG_PATH}test015.err
echo -n $? > ${LOG_PATH}test015.!!!

# test016: Test 09, but with function and instances definition; Expected output: test09.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH2}test016.in --output=${LOCAL_OUT_PATH}test016.out 2> ${LOG_PATH}test016.err
echo -n $? > ${LOG_PATH}test016.!!!

# test016: Test 03, but with funky names of variables, methods, and classes; Expected output: test09.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH2}test017.in --output=${LOCAL_OUT_PATH}test017.out --details=____ 2> ${LOG_PATH}test017.err
echo -n $? > ${LOG_PATH}test017.!!!

# test018: test 10, but with forward class declaration; Expected output: test018.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --details --input=${LOCAL_IN_PATH3}test018.in --output=${LOCAL_OUT_PATH}test018.out 2> ${LOG_PATH}test018.err
echo -n $? > ${LOG_PATH}test018.!!!

# test019: Static methods and instances; Expected output: test019.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --details --input=${LOCAL_IN_PATH3}test019.in --output=${LOCAL_OUT_PATH}test019.out 2> ${LOG_PATH}test019.err
echo -n $? > ${LOG_PATH}test019.!!!

# test020: Instance and method has type of class; Expected output: test020.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --details=B --input=${LOCAL_IN_PATH3}test020.in --output=${LOCAL_OUT_PATH}test020.out 2> ${LOG_PATH}test020.err
echo -n $? > ${LOG_PATH}test020.!!!

# test021: Declared class cannot be used as base class; Expected output: -; Expected return code: 4
$INTERPRETER $TASK.$EXTENSION --details=B --input=${LOCAL_IN_PATH3}test021.in --output=${LOCAL_OUT_PATH}test021.out 2> ${LOG_PATH}test021.err
echo -n $? > ${LOG_PATH}test021.!!!

# test22: Test 11 but result from Xpath is a whole element: test22.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test11.in --output=${LOCAL_OUT_PATH2}test022.out --details=B --search="/class/." 2> ${LOG_PATH}test022.err
echo -n $? > ${LOG_PATH}test022.!!!

# test23: test for methods and instances declaration and definitions - INVALID: test23.out; Expected return code: 4
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test023.in --output=${LOCAL_OUT_PATH2}test023.out --details=B 2> ${LOG_PATH}test023.err
echo -n $? > ${LOG_PATH}test023.!!!

# test24: method redefinition: test24.out; Expected return code: 4
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test024.in --output=${LOCAL_OUT_PATH2}test024.out 2> ${LOG_PATH}test024.err
echo -n $? > ${LOG_PATH}test024.!!!

# test25: instance redefinition: test25.out; Expected return code: 4
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test025.in --output=${LOCAL_OUT_PATH2}test025.out 2> ${LOG_PATH}test025.err
echo -n $? > ${LOG_PATH}test025.!!!

# test26: overloading: test26.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test026.in --output=${LOCAL_OUT_PATH2}test026.out --details=A 2> ${LOG_PATH}test026.err
echo -n $? > ${LOG_PATH}test026.!!!

# test27: Contructor and Destructor: test27.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test027.in --output=${LOCAL_OUT_PATH2}test027.out --details 2> ${LOG_PATH}test027.err
echo -n $? > ${LOG_PATH}test027.!!!

# test28: Destructor overload: test28.out; Expected return code: 4
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test028.in --output=${LOCAL_OUT_PATH2}test028.out --details 2> ${LOG_PATH}test028.err
echo -n $? > ${LOG_PATH}test028.!!!

# test29: duplicate base class: test29.out; Expected return code: 4
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test029.in --output=${LOCAL_OUT_PATH2}test029.out --details 2> ${LOG_PATH}test029.err
echo -n $? > ${LOG_PATH}test029.!!!

# test30: conflict: test30.out; Expected return code: 21
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test030.in --output=${LOCAL_OUT_PATH2}test030.out --details 2> ${LOG_PATH}test030.err
echo -n $? > ${LOG_PATH}test030.!!!

# test31D: prettyXML test: test31D.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test01.in --output=${LOCAL_OUT_PATH2}test031D.outD --details=D --pretty-xml=7 2> ${LOG_PATH}test031D.err
echo -n $? > ${LOG_PATH}test031D.!!!

# test32: not a conflict: test032.out; Expected return code: 0
$INTERPRETER $TASK.$EXTENSION --input=${LOCAL_IN_PATH}test032.in --output=${LOCAL_OUT_PATH2}test032.out 2> ${LOG_PATH}test032.err
echo -n $? > ${LOG_PATH}test032.!!!


#Print results
RED='\033[0;31m'
END='\033[0m'
GREEN='\033[1;32m'
BRED='\033[1;31m'

for i in `ls ./ref-out/ | grep -e '.*\.out$'`
    do
        ((ALL++))
        java -jar jexamxml/jexamxml.jar ./moj-out/"$i" ./ref-out/"$i" delta.xml ./cls_options 1>/dev/null
        m=$?
        if [ ! -s ./ref-out/"$i" ]; then
            d=`diff -aN ./moj-out/"${i%.out}.!!!" ./ref-out/"${i%.out}.!!!" 2> /dev/null`
            if [ $? -ne 0 ]; then
                printf "${GREEN}---------------------------------------------------${END}\n"
                printf "Test: ${BRED}$i${END} \n"
                ((COUNT++))
                printf "${RED}Wrong error code:${END}\n $d \n"
            fi
        elif [ "$m" -eq 1 ]; then
            printf "${GREEN}---------------------------------------------------${END}\n"
            printf "Test: ${BRED}$i${END} \n"
            ((COUNT++))
            printf "${RED}Wrong output:${END}\n "
            echo `head -n 10 delta.xml`
            d=`diff -aN ./moj-out/"${i%.out}.!!!" ./ref-out/"${i%.out}.!!!" 2> /dev/null`
            if [ $? -ne 0 ]; then
                printf "${RED}Wrong error code:${END}\n $d \n"
            fi
        elif [ "$m" -ne 0 ]; then
            printf "${GREEN}---------------------------------------------------${END}\n"
            printf "Test: ${BRED}$i${END} \n"
            ((COUNT++))
            printf "${RED}Failed because of JExamXml. JExamXml not where it should be, missing java...${END}\n"
            printf "${RED}OR same output files are missing!! make sure you save to correct files${END}\n"
            printf "${RED}OR you ended with error and thus no outputfile was written${END}\n"
        else
            d=`diff -aN ./moj-out/"${i%.out}.!!!" ./ref-out/"${i%.out}.!!!" 2> /dev/null`
            if [ $? -ne 0 ]; then
                printf "${GREEN}---------------------------------------------------${END}\n"
                printf "Test: ${BRED}$i${END} \n"
                ((COUNT++))
                printf "${RED}Wrong error code:${END}\n $d \n"
            fi
        fi
    done
    #one for pretty-XML=7
    ((ALL++))
    d=`grep -o '^\([[:space:]]*\)' "${LOCAL_OUT_PATH2}"test031D.outD`
    f=`cat ./ref-out/test031D.outD`
    v=`diff -aN <(echo "$d") <(echo "$f")`
    if [ $? -ne 0 ]; then
      printf "${GREEN}---------------------------------------------------${END}\n"
      ((COUNT++))
      printf "${RED}Wrong format when pretty-xml=7, test031D \n"
    fi



    rm moj-out/*
    PASSED=$((ALL-COUNT))
    printf "${GREEN}===================================================${END}\n"
    printf "Failed ${BRED}$COUNT${END} "`[[ $COUNT -eq 1 ]] && echo -n "test" || echo -n "tests"`;
    printf " from $ALL tests.\n"
    printf "If maths is not your strong suit: you passed ${GREEN}$PASSED${END} ";
    printf "`[[ $PASSED -eq 1 ]] && echo -n "test" || echo -n "tests"`\n";
