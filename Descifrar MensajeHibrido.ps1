function Descifrar-MensajeHibrido {
    # Solicitar ruta de la clave privada
    $privateKeyPath = Read-Host "🔐 Ingresa la ruta del archivo de clave privada (.xml)"

    if (-Not (Test-Path -Path $privateKeyPath -PathType Leaf)) {
        Write-Output "❌ Archivo de clave privada no encontrado."
        return
    }

    # Leer clave privada
    $privateKeyXml = Get-Content -Path $privateKeyPath -Raw
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $rsa.PersistKeyInCsp = $false
    $rsa.FromXmlString($privateKeyXml)

    # Solicitar datos cifrados
    $claveAESBase64 = Read-Host "🔐 Ingresa la clave AES cifrada (Base64)"
    $ivBase64 = Read-Host "📦 Ingresa el IV (Base64)"
    $mensajeCifradoBase64 = Read-Host "🧾 Ingresa el mensaje cifrado (Base64)"

    try {
        # Convertir de Base64 a bytes
        $claveAESBytes = [Convert]::FromBase64String($claveAESBase64)
        $ivBytes = [Convert]::FromBase64String($ivBase64)
        $mensajeCifradoBytes = [Convert]::FromBase64String($mensajeCifradoBase64)

        # Descifrar clave AES con RSA
        $claveAES = $rsa.Decrypt($claveAESBytes, $true)

        # Crear objeto AES
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = $claveAES
        $aes.IV = $ivBytes

        # Descifrar mensaje
        $decryptor = $aes.CreateDecryptor()
        $mensajeDescifradoBytes = $decryptor.TransformFinalBlock($mensajeCifradoBytes, 0, $mensajeCifradoBytes.Length)

        # Eliminar padding PKCS7
        $padLength = $mensajeDescifradoBytes[-1]
        $mensajeSinPadding = $mensajeDescifradoBytes[0..($mensajeDescifradoBytes.Length - $padLength - 1)]

        # Convertir a texto
        $mensajeDescifrado = [System.Text.Encoding]::UTF8.GetString($mensajeSinPadding)

        Write-Output "`n✅ Mensaje descifrado:"
        Write-Output $mensajeDescifrado
    }
    catch {
        Write-Output "❌ Error durante el descifrado. Verifica que los datos y la clave sean correctos."
    }
}

# Ejecutar la función
Descifrar-MensajeHibrido
