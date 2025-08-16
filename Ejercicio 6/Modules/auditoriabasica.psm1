function Obtener-usuariosInactivos{
<#
.SYNOPSIS
Obtiene los usuarios locales habilitados que nunca han inicado sesion.

.DESCRIPTION
Esta funcion busca cuentas locales habilitadas que no tienen ultima fecha de inicio de sesion.

.EXAMPLE
Obtener-UsuariosInactivos

.NOTES
Puede ayudar a detectar cuentas inecesarias o riesgosas en auditoias basicas.
#>

    Get-LocalUser | Where-Object{$_.Enabled -eq $true -and -not $_.LastLogon} -ErrorAction Stop
}

function Obtener-ServiciosExternos{
<#
.SYNOPSIS
Obtiene los servicios en ejecucion que no pertenecen expliciamente a Windows.

.DESCRIPTION
Esta funcion filtra servicios activos cuyo nombre descriptivo no contiene el termino 'Windows'.

.EXAMPLE
Obtener-ServiciosExternos

.NOTES
Puede ayudar a detectar software de terceros en ejecucion en segundo plano.
#>

    Get-Service | Where-Object{$_.Status -eq "Running" -and $_.DisplayName -notmatch "Windows"}
}