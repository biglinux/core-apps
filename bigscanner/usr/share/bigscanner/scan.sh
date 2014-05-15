#!/bin/bash

#Cria pasta de configuração
mkdir -p  "~/.config/bigscanner" 2> /dev/null

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
body {margin-left: 5px; margin-top: 120px; margin-right: 0px; margin-bottom: 0px; background-image: url(/content$./fundo.png); background-attachment:fixed;}
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

##########################
#Confere se é para digitalizar e digitaliza
##########################
if [ "$p_digitalizar" = "sim" ]
then
    mkdir -p "$(cat "~/.config/bigscanner/pasta.conf")/$(cat "~/.config/bigscanner/ano.conf")/$(cat "~/.config/bigscanner/mes.conf")"
    scanimage -p -d $(cut -f1 -d" " "~/.config/bigscanner/scanner.conf") --mode $(cat "~/.config/bigscanner/cor.conf") --resolution $(cat "~/.config/bigscanner/dpi.conf") > "~/.config/bigscanner/.bigscannertmp.pnm"; convert "~/.config/bigscanner/.bigscannertmp.pnm" -quality $(cat "~/.config/bigscanner/qualidade.conf")% -resize $(cat "~/.config/bigscanner/redimensionar.conf")% "$(cat "~/.config/bigscanner/pasta.conf")/$(cat "~/.config/bigscanner/ano.conf")/$(cat "~/.config/bigscanner/mes.conf")/$(cat "~/.config/bigscanner/dia.conf")-$(cat "~/.config/bigscanner/numero.conf")-$(cat "~/.config/bigscanner/complementar.conf").jpg"
fi


###########
#Inicia formulario
###########
echo "<form action=\"/execute$./scan_processando.sh\" method=post>"


    #####################
    #Inicia a lista scanners disponíveis
    #####################

    #Interface
    echo "<table align=center><tr><td><table><td><tr>"
    echo $"Selecione o scanner"
    echo "<a href=/execute$./scan_processando.sh?atualizar_scanner=sim>" $"(Clique aqui para atualizar a lista de scanners)" "</a>"

    #Confere se é para atualizar a pasta
    if [ "$p_atualizar_pasta" = "sim" ]
    then
        if [ "$(cat ~/.config/bigscanner/pasta.conf)" != "" ]
	then
	    kdialog --getexistingdirectory $(cat "~/.config/bigscanner/pasta.conf") > "~/.config/bigscanner/pasta.conf"
	else
	    kdialog --getexistingdirectory $HOME > "~/.config/bigscanner/pasta.conf"
	fi
    fi
    #Confere se é para atualizar a lista de scanners
    if [ "$p_atualizar_scanner" = "sim" ]
    then
	echo "<font color=red>" $"* Lista Atualizada!" "</font>"
	rm "~/.config/bigscanner/lista_de_scanners.conf"
    fi

    echo "<br></tr><tr>"

    echo "<select name=\"scanner\">"


    #Confere se existe uma lista de scanners, caso não exista gera uma.
    if [ "$(cat "~/.config/bigscanner/lista_de_scanners.conf" 2> /dev/null)" = "" ]
    then
	#Gera lista de scanners no arquivo lista_de_scanners.conf
	scanimage -L | sed 's|device `||g' | sed "s|'||g" > "~/.config/bigscanner/lista_de_scanners.conf"
    fi

    #Altera delimitador padrão de espaço para quebra de linha
    ORI_IFS=$IFS
    IFS=$'
'

    #Inicia loop com scanners disponíveis
    for scanner in $(cat "~/.config/bigscanner/lista_de_scanners.conf")
    do
	#Confere o arquivo scanner.conf, para quando utilizar o programa novamente recordar o scanner utilizado na última vez
	if [ "$scanner" = "$(cat "~/.config/bigscanner/scanner.conf 2> /dev/null")" ]
	then
	    #Caso o scanner coincida com o armazenado no arquivo scanner.conf utiliza a opção selected
	    echo "<option value=\"$scanner\" selected=\"selected\">$scanner</option>"
	else
	    #Caso não coincida o scanner com o armazenado no arquivo scanner.conf não utiliza a opção selected
	    echo "<option value=\"$scanner\">$scanner</option>"
	fi
    #Finaliza loop do scanner
    done

    #Restaura delimitador padrão
    IFS=$ORI_IFS

    #Finaliza lista com os scanners
    echo "</select>"

    #Interface
    echo "</tr></td></table>"

    ################
    #Inicia a lista com os anos
    ################
    #Interface
    echo "<table><tr><td width=100>"
    echo $"Ano"
    echo "</td><td width=100>"
    echo $"Mês"
    echo "</td><td width=100>"
    echo $"Dia"
    echo "</td><td width=100>"
    echo $"Número"
    echo "</td><td width=100>"
    echo $"Complemento"
    echo "</td><td></tr><tr><td>"

    echo "<select name=\"ano\">"

    #Inicia loop que vai do ano 2011 ao 2015
    for ano in $(seq -f %02g 2011 2015)
    do
	#Confere o arquivo ano.conf, para quando utilizar o programa novamente recordar o ano utilizado na última vez
	if [ "$ano" = "$(cat "~/.config/bigscanner/ano.conf" 2> /dev/null)" ]
	then
	    #Caso o ano coincida com o armazenado no arquivo ano.conf utiliza a opção selected
	    echo "<option value=\"$ano\" selected=\"selected\">$ano</option>"
	else
	    #Caso não coincida o ano com o armazenado no arquivo ano.conf não utiliza a opção selected
	    echo "<option value=\"$ano\">$ano</option>"
	fi
    #Finaliza loop do ano 2011 ao 2015
    done

    #Finaliza lista com os anos
    echo "</select>"
    echo "</td><td>"


    #################
    #Inicia a lista com os meses
    #################
    echo "<select name=\"mes\">"

    #Inicia loop que vai do mes 1 ao 12
    for mes in $(seq -f %02g 1 12)
    do
	#Confere o arquivo mes.conf, para quando utilizar o programa novamente recordar o mes utilizado na última vez
	if [ "$mes" = "$(cat "~/.config/bigscanner/mes.conf" 2> /dev/null)" ]
	then
	    #Caso o mes coincida com o armazenado no arquivo mes.conf utiliza a opção selected
	    echo "<option value=\"$mes\" selected=\"selected\">$mes</option>"
	else
	    #Caso não coincida o mes com o armazenado no arquivo mes.conf não utiliza a opção selected
	    echo "<option value=\"$mes\">$mes</option>"
	fi
    #Finaliza loop do mes 1 ao 12
    done

    #Finaliza lista com os meses
    echo "</select>"
    echo "</td><td>"


    ################
    #Inicia a lista com os dias
    ################
    echo "<select name=\"dia\">"

    #Inicia loop que vai do dia 1 ao 31
    for dia in $(seq -f %02g 1 31)
    do
	#Confere o arquivo dia.conf, para quando utilizar o programa novamente recordar o dia utilizado na última vez
	if [ "$dia" = "$(cat "~/.config/bigscanner/dia.conf" 2> /dev/null)" ]
	then
	    #Caso o dia coincida com o armazenado no arquivo dia.conf utiliza a opção selected
	    echo "<option value=\"$dia\" selected=\"selected\">$dia</option>"
	else
	    #Caso não coincida o dia com o armazenado no arquivo dia.conf não utiliza a opção selected
	    echo "<option value=\"$dia\">$dia</option>"
	fi
    #Finaliza loop do dia 1 ao 31
    done

    #Finaliza lista com os dias
    echo "</select>"
    echo "</td><td>"


    ############################
    #Inicia a lista com os números de identificação
    ############################
    echo "<select name=\"numero\">"

    #Inicia loop que vai do numero 1 ao 99
    for numero in $(seq -f %02g 1 99)
    do
	#Confere o arquivo numero.conf, para quando utilizar o programa novamente recordar o número utilizado na última vez
	if [ "$numero" = "$(cat "~/.config/bigscanner/numero.conf" 2> /dev/null)" ]
	then
	    #Caso o número coincida com o armazenado no arquivo numero.conf utiliza a opção selected
	    echo "<option value=\"$numero\" selected=\"selected\">$numero</option>"
	else
	    #Caso não coincida o número com o armazenado no arquivo numero.conf não utiliza a opção selected
	    echo "<option value=\"$numero\">$numero</option>"
	fi
    #Finaliza loop do número 1 ao 99
    done

    #Finaliza lista com os números
    echo "</select>"
    echo "</td><td>"


    ###################################
    #Inicia espaço para complementar o nome como desejado
    ###################################
    echo "<input type=\"text\" value=\"$(cat "~/.config/bigscanner/complementar.conf")\" name=\"complementar\">"
    #Não precisa finalizar o espaço complementar, veja que o último complemento utilizado fica salvo no arquivo complementar.conf
    echo "</td></tr></table>"


    ############################
    #Inicia a lista com opções de resolução (dpi)
    ############################
    #Interface
    echo "<br><table><tr><td width=100>"
    echo $"Resolução"
    echo "</td><td width=100>"
    echo $"Cores"
    echo "</td><td width=100>"
    echo $"Qualidade"
    echo "</td><td width=100>"
    echo $"Zoom"
    echo "</td><td></tr><tr><td>"


    echo "<select name=\"dpi\">"

    #Inicia loop que vai de dpis
    for dpi in 75 100 150 200 300 600 1200
    do
	#Confere o arquivo dpi.conf, para quando utilizar o programa novamente recordar o dpi utilizado na última vez
	if [ "$dpi" = "$(cat "~/.config/bigscanner/dpi.conf" 2> /dev/null)" ]
	then
	    #Caso o dpi coincida com o armazenado no arquivo dpi.conf utiliza a opção selected
	    echo "<option value=\"$dpi\" selected=\"selected\">$dpi</option>"
	else
	    #Caso não coincida o dpi com o armazenado no arquivo dpi.conf não utiliza a opção selected
	    echo "<option value=\"$dpi\">$dpi</option>"
	fi
    #Finaliza loop de dpis
    done

    #Finaliza lista com os dpis
    echo "</select>"
    echo "</td><td>"


    ############################
    #Inicia a lista com opções de resolução (dpi)
    ############################
    echo "<select name=\"cor\">"

    #Inicia loop de cor
    for cor in Color Gray Lineart
    do
	#Confere o arquivo cor.conf, para quando utilizar o programa novamente recordar o cor utilizado na última vez
	if [ "$cor" = "$(cat "~/.config/bigscanner/cor.conf" 2> /dev/null)" ]
	then
	    #Caso a cor coincida com o armazenado no arquivo cor.conf utiliza a opção selected
	    echo "<option value=\"$cor\" selected=\"selected\">$cor</option>"
	else
	    #Caso não coincida a cor com o armazenado no arquivo cor.conf não utiliza a opção selected
	    echo "<option value=\"$cor\">$cor</option>"
	fi
    #Finaliza loop de cor
    done

    #Finaliza lista de cor
    echo "</select>"
    echo "</td><td>"


    #########################
    #Inicia a lista com qualidade da imagem
    #########################
    echo "<select name=\"qualidade\">"

    #Inicia loop que vai do qualidade 1 a 100
    for qualidade in $(seq -f %02g 20 5 100)
    do
	#Confere o arquivo qualidade.conf, para quando utilizar o programa novamente recordar o número utilizado na última vez
	if [ "$qualidade" = "$(cat "~/.config/bigscanner/qualidade.conf" 2> /dev/null)" ]
	then
	    #Caso o número coincida com o armazenado no arquivo qualidade.conf utiliza a opção selected
	    echo "<option value=\"$qualidade\" selected=\"selected\">$qualidade</option>"
	else
	    #Caso não coincida o número com o armazenado no arquivo qualidade.conf não utiliza a opção selected
	    echo "<option value=\"$qualidade\">$qualidade</option>"
	fi
    #Finaliza loop do número 1 ao 99
    done

    #Finaliza lista com os números
    echo "</select>"
    echo "</td><td>"


    ################################
    #Inicia a lista com redimensionamento da imagem
    ################################
    echo "<select name=\"redimensionar\">"

    #Inicia loop que vai do redimensionar 1 a 300
    for redimensionar in $(seq -f %02g 10 10 200)
    do
	#Confere o arquivo redimensionar.conf, para quando utilizar o programa novamente recordar o número utilizado na última vez
	if [ "$redimensionar" = "$(cat "~/.config/bigscanner/redimensionar.conf" 2> /dev/null)" ]
	then
	    #Caso o número coincida com o armazenado no arquivo redimensionar.conf utiliza a opção selected
	    echo "<option value=\"$redimensionar\" selected=\"selected\">$redimensionar</option>"
	else
	    #Caso não coincida o número com o armazenado no arquivo redimensionar.conf não utiliza a opção selected
	    echo "<option value=\"$redimensionar\">$redimensionar</option>"
	fi
    #Finaliza loop do número 1 ao 99
    done

    #Finaliza lista com os números
    echo "</select>"
    echo "</td><td>"


    ################################
    #Pasta a ser utilizada
    ################################
    echo "<input type=\"text\" value=\"$(cat "~/.config/bigscanner/pasta.conf")\" name=\"pasta\">"
    echo "<button type=button onClick=parent.location='/execute$./scan.sh?atualizar_pasta=sim'>" $"Selecionar pasta" "</button>"




    echo "</td></tr></table></td></tr></table>"

echo "<br><br><br><br><center><input type=\"submit\" style=\"height: 55px; width: 300px\" value=\"" $"Digitalizar" "\"></center>"

#Encerra formulário
echo "</form>"