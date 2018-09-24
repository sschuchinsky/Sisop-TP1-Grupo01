CONF="conf"
LOG="$CONF/log"
GRUPO=$(pwd | sed "s-\(.*Grupo01\).*-\1-")
inicializado=0

function log ()
{
        date +"%x %X-$USER-$1-$2-$3" >> "$LOG/inicializador.log" 
}

function reportar() {
    echo -e "\e[1;31m$1\e[0m"
    echo -e "\e[1;31mPara reparar la instalación corra el script './instalador.sh -r'\e[0m"
}
if [[ -z $MAESTROS ]]; then  
echo "primera vez que es inicializado"
log "inicializador" "INF" "primera vez que es inicializado"
else
echo "se ha inicializado una vez con anterioridad"
log "inicializador" "INF" "se ha inicializado una vez con anterioridad"
inicializado=1
fi
while read linea; do
 #   if [[ -z $linea ]]; then continue; fi

    key=$(echo "$linea" | cut -d- -f1)
    ruta=$(echo "$linea" | cut -d- -f2)
    user=$(echo "$linea" | cut -d- -f3)
echo "$key"
echo "$ruta"
echo "$user"
    case "$key" in
        MAESTROS) export MAESTROS=$ruta;;
        EJECUTABLES) export EJECUTABLES=$ruta;;
        ACEPTADOS) export ACEPTADOS=$ruta;;
        RECHAZADOS) export RECHAZADOS=$ruta;;
        PROCESADOS) export PROCESADOS=$ruta;;
        SALIDA) export SALIDA=$ruta;;
        LOGS) export LOGS=$ruta;;
	NOVEDADES) export NOVEDADES=$ruta;;
	CONF) export CONF=$ruta;;
	GRUPO) export GRUPO=$ruta;;
	
    esac
    if [[ -z $flag ]]; then flag=$user; fi


    if [[ $flag != $user ]]; then
      reportar "Error de usuario, tiene que ser el mismo para todas rutas" 
      log "inicializador" "INF" "Error de usuario, tiene que ser el mismo para todas rutas"
    fi
done < "$GRUPO/conf/tpconfig.txt"

log "inicializador" "INF" "cambio de permisos en MAESTROS y EJECUTABLES"
echo "cambio de permisos en MAESTROS y EJECUTABLES"
find "$MAESTROS" -type f -exec chmod u+r {} +
find "$EJECUTABLES" -type f -exec chmod u+rx {} +

for x in MAESTROS EJECUTABLES ACEPTADOS RECHAZADOS VALIDADOS REPORTES LOGS; do
    if [ -v $x ]; then
        echo "no esta $x en archivo de configuracion"
	log "inicializador" "INF" "no esta $x en archivo de configuracion"
    else
	echo "esta $x en archivo de configuracion"
	log "inicializador" "INF" "esta $x en archivo de configuracion"
    fi
    if [ ! -d ${!x} ]; then
        reportar "directorio de $x no existe"
	log "inicializador" "INF" "directorio de $x no existe falta un componente"
    fi
done

$EJECUTABLES/start.sh

	
