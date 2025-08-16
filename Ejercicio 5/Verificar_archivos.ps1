function Validar-Archivo{
    param(
        [string]$ruta
    )

    try{
        if(Test-Path $ruta){
            $contenido = Get-Content $ruta -ErrorAction Stop
            return "Archivo encontrado y accesible: $ruta"
        }else{
            throw "El archivo no existe"
        }
    }catch{
        return "Error $_"
    }finally{
        Write-Host "Validacion finalizada par: $ruta" -ForegroundColor Cyan
    }
}

Validar-Archivo -ruta "C:\archivo_inexistente.txt"

Validar-Archivo -ruta "C:\Users\lalot\Escritorio\Programacion\PC\archivo.txt"


$tamano = Get-ChildItem -Path "C:\Users\lalot\Escritorio\Programacion\PC\archivo.txt"
Write-Host "El tamaño del archivo es >>> $($tamano.Length)" 