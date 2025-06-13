function Generar-ClavesRSA {
    param (
        [int]$keySize = 4096
    )

    <# Este script fue creado para correr en PowerShell, no requiere licencia o permisos adicionales ya que usa la librería de criptografía preinstalada en SO Microsoft #>

    # Nombre de la carpeta donde se almacenarán las llaves
    $folderName = Read-Host "Ingresa el nombre de la carpeta que va a contener las llaves (se creará dentro de tu ruta de usuario)"

    # Obtener la ruta del perfil del usuario
    $userProfilePath = [Environment]::GetFolderPath("UserProfile")

    # Concatenar la ruta completa
    $keysFolderPath = Join-Path -Path $userProfilePath -ChildPath $folderName

    # Verificar si la carpeta ya existe
    if (Test-Path -Path $keysFolderPath) {
        Write-Output "⚠️ La carpeta '$folderName' ya existe en la siguiente ruta: $keysFolderPath"
        return  # Detiene la ejecución de la función sin cerrar PowerShell
    }

    # Crear la carpeta
    New-Item -ItemType Directory -Path $keysFolderPath -Force | Out-Null
    Write-Output "✅ Se ha creado la carpeta para las llaves"

    # Definir las rutas completas para los archivos de clave
    $publicKeyPath = Join-Path -Path $keysFolderPath -ChildPath "clave_publica.pub"
    $privateKeyPath = Join-Path -Path $keysFolderPath -ChildPath "clave_privada"

    # --- Generar el par de claves RSA ---
    Write-Host "🔐 Generando par de claves RSA de $keySize bits..."
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider($keySize)

    # Exportar claves
    $publicKeyXml = $rsa.ToXmlString($false)
    $privateKeyXml = $rsa.ToXmlString($true)

    # Guardar claves en archivos
    $publicKeyXml | Out-File -FilePath $publicKeyPath -Encoding UTF8
    $privateKeyXml | Out-File -FilePath $privateKeyPath -Encoding UTF8

    # Mostrar la ruta final
    Write-Output "⚠️ Ten cuidado al compartir la pública, el explorador de archivos puede esconderte la extensión de la llave!"
    Write-Output "🚨 Advertencia: la clave privada es confidencial. No la compartas con nadie."
    Write-Output "¿Te gustó?, luego me invita a un tintico 🧑‍💻 jbarreto. La Clave pública 🔑 y la Clave privada 🔒 se han generado con éxito, encuéntralas en la siguiente ruta: $keysFolderPath"
    
}

# Ejecutar la función
Generar-ClavesRSA
