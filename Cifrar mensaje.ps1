function Cifrar-MensajeRSA {
    # Solicitar el mensaje a cifrar
    $mensaje = Read-Host "Ingresa el mensaje que deseas cifrar"

    # Solicitar la ruta del archivo de clave pública
    $publicKeyPath = Read-Host "Ingresa la ruta completa del archivo (debes de incluir la extensión .pub, ej. C:\Users\usuario\clave_publica.pub)"

    # Validar que el archivo exista y sea un archivo (no una carpeta)
    if (-Not (Test-Path -Path $publicKeyPath -PathType Leaf)) {
        Write-Output "❌ La ruta proporcionada '$publicKeyPath' no apunta a un archivo válido; Recuerda incluir el .pub"
        return
    }

    # Leer la clave pública desde el archivo
    try {
        $publicKeyXml = Get-Content -Path $publicKeyPath -Raw
    } catch {
        Write-Output "❌ Error al leer el archivo. Verifica que tengas permisos de lectura."
        return
    }

    # Crear el objeto RSA y cargar la clave pública
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $rsa.PersistKeyInCsp = $false
    $rsa.FromXmlString($publicKeyXml)

    # Convertir el mensaje a bytes
    $mensajeBytes = [System.Text.Encoding]::UTF8.GetBytes($mensaje)

    # Cifrar el mensaje usando OAEP padding
    $mensajeCifrado = $rsa.Encrypt($mensajeBytes, $true)

    # Convertir a Base64 para facilitar su visualización y almacenamiento
    $mensajeCifradoBase64 = [Convert]::ToBase64String($mensajeCifrado)

    # Mostrar el resultado
    Write-Output "`n🔐 Mensaje cifrado (Base64):"
    Write-Output $mensajeCifradoBase64
    Set-Clipboard -Value $mensajeCifradoBase64
    Write-Output "`n📋 El mensaje cifrado se ha copiado al portapapeles."

}

# Ejecutar la función
Cifrar-MensajeRSA
