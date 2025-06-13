function Cifrar-MensajeHibrido {
    # Solicitar el mensaje largo
    $mensaje = Read-Host "📝 Ingresa el mensaje que deseas cifrar (puede ser largo)"

    # Solicitar la ruta del archivo de clave pública
    $publicKeyPath = Read-Host "📂 Ingresa la ruta completa del archivo de clave pública (.pub)"

    # Verificar que el archivo exista
    if (-Not (Test-Path -Path $publicKeyPath -PathType Leaf)) {
        Write-Output "❌ Archivo de clave pública no encontrado en: $publicKeyPath"
        return
    }

    # Leer la clave pública
    $publicKeyXml = Get-Content -Path $publicKeyPath -Raw
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $rsa.PersistKeyInCsp = $false
    $rsa.FromXmlString($publicKeyXml)

    # Crear AES
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.KeySize = 256
    $aes.GenerateKey()
    $aes.GenerateIV()

    # Convertir mensaje a bytes y aplicar padding PKCS7
    $mensajeBytes = [System.Text.Encoding]::UTF8.GetBytes($mensaje)
    $padLength = 16 - ($mensajeBytes.Length % 16)
    $paddedMessage = $mensajeBytes + ([byte[]]($padLength) * $padLength)

    # Cifrar mensaje con AES
    $encryptor = $aes.CreateEncryptor()
    $mensajeCifrado = $encryptor.TransformFinalBlock($paddedMessage, 0, $paddedMessage.Length)

    # Cifrar clave AES con RSA
    $claveCifrada = $rsa.Encrypt($aes.Key, $true)

    # Mostrar resultados en Base64
    Write-Output "`n🔐 Clave AES cifrada (Base64):"
    [Convert]::ToBase64String($claveCifrada)

    Write-Output "`n📦 IV (Base64):"
    [Convert]::ToBase64String($aes.IV)

    Write-Output "`n🧾 Mensaje cifrado (Base64):"
    [Convert]::ToBase64String($mensajeCifrado)
}

# Ejecutar la función
Cifrar-MensajeHibrido
