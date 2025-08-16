$usuarios= Get-LocalUser

$SinLogin=@()
$ConLogin=@()

foreach($u in $usuarios){
    if(-not $u.LastLogon){
        $SinLogin += "$($u.Name): Estado = $($u.Enabled) , Ultimo accesso = NUNCA"
    }else{
        $ConLogin += "$($u.Name): Estado = $($u.Enabled) , Ultimo accesso = $($u.LastLogon)" 
    }
}

$SinLogin | Out-File -FilePath "C:\Users\lalot\Escritorio\Programacion\PC\usuarios_sin_login.txt"
$ConLogin | Out-File -FilePath "C:\Users\lalot\Escritorio\Programacion\PC\usuarios_con_login.txt"

Write-Output "'n Usuarios que Nunca han iniciado sesion:"
$SinLogin | Foreach-Object {Write-Output $_}

Write-Output "'n Usuarios que si han iniciado sesion:"
$ConLogin | Foreach-Object {Write-Output $_}