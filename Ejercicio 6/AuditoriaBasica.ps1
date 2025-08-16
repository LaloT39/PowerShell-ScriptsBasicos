Clear-Host 

Import-Module AuditoriaBasica 

 

Write-Host "=== Auditoría básica de usuarios y servicios ===" 

Write-Host "1. Mostrar usuarios inactivos" 

Write-Host "2. Mostrar servicios externos activos" 

$opcion = Read-Host "Selecciona una opción (1 o 2)" 

 

switch ($opcion) { 

    "1" { 

        $usuarios = Obtener-UsuariosInactivos 

        $usuarios | Format-Table Name, Enabled, LastLogon -AutoSize 

        $usuarios | Export-Csv -Path "C:\Users\lalot\Escritorio\Programacion\PC\users_inac.csv" -NoTypeInformation -ErrorAction Stop

        Write-Host "`n📄 Reporte generado: ussers_inac.csv" 

    } 

    "2" { 

        $servicios = Obtener-ServiciosExternos 

        $servicios | Format-Table DisplayName, Status, StartType -AutoSize 

        $servicios | ConvertTo-Html | Out-File "C:\Users\lalot\Escritorio\Programacion\PC\serv_e.html" -ErrorAction Stop

        Write-Host "`n📄 Reporte generado: serv_e.html" 

    } 

    default { 

        Write-Host "Opción no válida." 

    } 

} 