function Descifrar-MensajeRSA {
    # Solicitar el mensaje cifrado en Base64
    $mensajeCifradoBase64 = Read-Host "Ingresa el mensaje cifrado (en formato Base64)"

    # Solicitar la ruta del archivo de clave privada
    $privateKeyPath = Read-Host "Ingresa la ruta completa del archivo de clave privada (por ejemplo: C:\Users\usuario\clave_privada)"

    # Validar que el archivo exista
    if (-Not (Test-Path -Path $privateKeyPath -PathType Leaf)) {
        Write-Output "❌ La ruta proporcionada $privateKeyPath no apunta a un archivo válido. Recuerda usar la privada"
        return
    }

    # Leer la clave privada desde el archivo
    try {
        $privateKeyXml = Get-Content -Path $privateKeyPath -Raw
    } catch {
        Write-Output "❌ Error al leer el archivo. Verifica que tengas permisos de lectura."
        return
    }

    # Crear el objeto RSA y cargar la clave privada
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $rsa.PersistKeyInCsp = $false
    $rsa.FromXmlString($privateKeyXml)

    # Limpiar espacios y saltos de línea del mensaje cifrado
    $mensajeCifradoBase64 = $mensajeCifradoBase64 -replace '\s+', ''

    # Convertir el mensaje cifrado de Base64 a bytes
    try {
        $mensajeCifradoBytes = [Convert]::FromBase64String($mensajeCifradoBase64)
        
    } catch {
        Write-Output "❌ El mensaje ingresado no está en formato Base64 válido."
        return
    }

    # Intentar descifrar el mensaje
    try {
        $mensajeDescifradoBytes = $rsa.Decrypt($mensajeCifradoBytes, $true)
        $mensajeDescifrado = [System.Text.Encoding]::UTF8.GetString($mensajeDescifradoBytes)

        # Mostrar el mensaje descifrado
        Write-Output "`n🔓 Mensaje descifrado:"
        Write-Output $mensajeDescifrado
    } catch {
        Write-Output "❌ No se pudo descifrar el mensaje. Verifica que la clave privada sea correcta y que el mensaje no esté dañado."
    }
}

# Ejecutar la función
Descifrar-MensajeRSA
