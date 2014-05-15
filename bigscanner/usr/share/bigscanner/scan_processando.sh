#!/bin/bash

#Evita conflito com acentos
echo '<meta http-equiv=Content-Type content=text/html; charset=UTF-8>'

#Adicionar suporte a tradução
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=big-scan

#Titulo
echo "<title>" $"Big Scanner" "</title>"

#Tamanho da janela
echo '
<script language="JavaScript">
window.resizeTo(940,480);
function NoResize(){
  window.resizeTo(940,480);
}
</script>
'

#Tema
echo "<style>
body {margin-left: 5px; margin-top: 170px; margin-right: 0px; margin-bottom: 0px; background-image: url(/content$./fundo.png); background-attachment:fixed;}
a:link {color: #0057ae;text-decoration:none;}
a:hover {text-decoration:underline;}
body{
        background-color:  #dfe7ee;
        color:  #181615;
        font-size: 9pt;
        font-family: 'DejaVu Sans';
        font-weight: normal;
        font-style: none;
}
table {font-size: 13;}
table.kdecolor {
background-color:  #ffffff;
}

</style>"



#Confere se é para atualizar a lista de scanners
if [ "$p_atualizar_scanner" = "sim" ]
then
    echo "<meta http-equiv=\"REFRESH\" content=\"0;url=/execute$./scan.sh?atualizar_scanner=sim\">"
    echo "<font color=red size=+3><center>" $"Atualizando a lista de scanners..." "</font>"
    exit
fi

#Confere se realmente é para salvar as configurações no hd
if [ "$p_sobrescrever" = "" ]
then
    #Salvando configuração no hd
    echo "$p_scanner" > "~/.config/bigscanner/scanner.conf"
    echo "$p_ano" > "~/.config/bigscanner/ano.conf"
    echo "$p_mes" > "~/.config/bigscanner/mes.conf"
    echo "$p_dia" > "~/.config/bigscanner/dia.conf"
    echo "$p_numero" > "~/.config/bigscanner/numero.conf"
    echo "$p_complementar" > "~/.config/bigscanner/complementar.conf"
    echo "$p_dpi" > "~/.config/bigscanner/dpi.conf"
    echo "$p_cor" > "~/.config/bigscanner/cor.conf"
    echo "$p_qualidade" > "~/.config/bigscanner/qualidade.conf"
    echo "$p_redimensionar" > "~/.config/bigscanner/redimensionar.conf"
    echo "$p_pasta" > "~/.config/bigscanner/pasta.conf"

    #Confere se o arquivo já existe
    if [ -e "$(cat "~/.config/bigscanner/pasta.conf")/$(cat "~/.config/bigscanner/ano.conf")/$(cat "~/.config/bigscanner/mes.conf")/$(cat "~/.config/bigscanner/dia.conf")-$(cat "~/.config/bigscanner/numero.conf")-$(cat "~/.config/bigscanner/complementar.conf").jpg" ]
    then
	echo "<font color=red size=+2><center>" $"O arquivo já existe, deseja sobrescrever?" "</font>"

	echo "<br><br><button type=button style=\"height: 35px; width: 100px\" onClick=parent.location='/execute$./scan_processando.sh?sobrescrever=sim'>" $"Sim" "</button>"
	echo "<button type=button style=\"height: 35px; width: 100px\" onClick=parent.location='/execute$./scan.sh'>" $"Não" "</button>"
	exit
   fi

fi

#Digitalizando
echo "<meta http-equiv=\"REFRESH\" content=\"0;url=/execute$./scan.sh?digitalizar=sim\">"
echo "<font color=red size=+3><center>" $"Digitalizando, aguarde..." "</font>"
