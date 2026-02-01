# Guía para configurar Google Apps Script (Gratis y con Subida de Archivos)

Para recibir los pedidos con archivos adjuntos directamente en tu Google Drive y recibir notificaciones por correo sin límites de pago, sigue estos pasos:

## 1. Crear el Script en Google Drive
1. Ve a **Google Drive** y crea una nueva **Hoja de Cálculo de Google**. Llámala "Pedidos 3D".
2. En el menú superior, ve a **Extensiones** > **Apps Script**.
3. Se abrirá una nueva pestaña. Borra todo el código que aparece y pega el siguiente código:

```javascript
// --- COPIA DESDE AQUÍ ---
var EMAILS_DESTINO = ["p.estiarte@gmail.com"]; // Pon aquí tu email (separados por comas si hay más)
var CARPETA_NOMBRE = "Adjuntos_Pedidos_3D"; // Nombre de la carpeta en Drive para los archivos

function doPost(e) {
  try {
    var params = e.parameter;
    var nombre = params.Nombre;
    var email = params.Email;
    var material = params.Material;
    var precio = params.Precio;
    var archivoNombre = params.NombreArchivo || "Sin nombre";
    
    // 1. Guardar en Hoja de Cálculo
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    var fecha = new Date();
    
    // 2. Gestionar Archivo (si existe)
    var fileUrl = "Sin archivo adjunto";
    if (e.postData && e.postData.contents && e.postData.type.indexOf("multipart/form-data") == -1) {
       // Si enviaste base64 (método avanzado)
       // Para simplificar, usaremos el método blob si viene codificado
    }
    
    // NOTA: Para subir archivos desde HTML simple a Apps Script se requiere un truco con FileReader (Base64).
    // El script recibe el archivo codificado en Base64 desde el frontend.

    var data = JSON.parse(e.postData.contents);
    nombre = data.nombre;
    email = data.email;
    material = data.material;
    precio = data.precio;
    var fileData = data.fileData; // Base64
    var fileName = data.fileName;
    var mimeType = data.mimeType;

    if (fileData && fileName) {
      var folder = getFolder(CARPETA_NOMBRE);
      var decoded = Utilities.base64Decode(fileData);
      var blob = Utilities.newBlob(decoded, mimeType, fileName);
      var file = folder.createFile(blob);
      fileUrl = file.getUrl();
      
      // Hacer público el enlace o dejarlo privado (por defecto es privado, solo tú puedes verlo)
      // file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
    }

    // Guardar fila
    sheet.appendRow([fecha, nombre, email, material, precio, fileUrl]);

    // 3. Enviar Email de Notificación
    var asunto = "Nuevo Pedido 3D: " + nombre;
    var cuerpo = "Detalles del pedido:\n\n" +
                 "Cliente: " + nombre + "\n" +
                 "Email: " + email + "\n" +
                 "Material: " + material + "\n" +
                 "Precio Estimado: " + precio + "\n" +
                 "Archivo: " + fileUrl + "\n\n" +
                 "Revisa la hoja de cálculo para más detalles.";
                 
    MailApp.sendEmail({
      to: EMAILS_DESTINO.join(","),
      subject: asunto,
      body: cuerpo
    });

    return ContentService.createTextOutput(JSON.stringify({"result":"success", "fileUrl": fileUrl}))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({"result":"error", "error": error.toString()}))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function getFolder(name) {
  var folders = DriveApp.getFoldersByName(name);
  if (folders.hasNext()) {
    return folders.next();
  } else {
    return DriveApp.createFolder(name);
  }
}
// --- HASTA AQUÍ ---
```

## 2. Publicar el Script
1. Haz clic en el botón azul **Implementar** (arriba a la derecha) > **Nueva implementación**.
2. En la ventana que aparece:
   - Haz clic en el engranaje "Seleccionar tipo" > **Aplicación web**.
   - Descripción: "API Pedidos".
   - Ejecutar como: **Yo** (tu email).
   - Quién tiene acceso: **Cualquier usuario** (Esto es importante para que funcione desde la web).
3. Dale a **Implementar**.
4. Te pedirá permisos, autoriza todo con tu cuenta.
5. Copia la **URL de la aplicación web** (será algo como `https://script.google.com/macros/s/.../exec`).

## 3. Configurar tu Web
1. Abre el archivo `Calculadora3D.html`.
2. Busca la variable `const GOOGLE_SCRIPT_URL` (que añadiré ahora).
3. Pega ahí tu URL copiada.

¡Listo! Ahora los archivos irán a tu Drive y recibirás un aviso gratis.
