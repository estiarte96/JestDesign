# Implementación de la Política de Cookies (Cookiebot)

Este documento detalla cómo se ha implementado la gestión del consentimiento de cookies en el sitio web de **EST Ingenieros** utilizando la plataforma **Cookiebot CMP** para cumplir con normativas como el RGPD y la LSSI.

## 1. Integración del Banner de Consentimiento
Se ha añadido el script principal de Cookiebot en la etiqueta `<head>` de todas las páginas HTML del sitio. Este script se encarga de mostrar el banner a los nuevos usuarios y gestionar sus preferencias.

```html
<script id="Cookiebot" src="https://consent.cookiebot.com/uc.js" 
        data-cbid="1caf3909-123e-4e98-b2f5-b97f18ce963b"
        data-blockingmode="auto" 
        type="text/javascript"></script>
```

## 2. Control de Scripts de Seguimiento (Google Analytics)
Para garantizar que no se activen cookies de seguimiento antes de que el usuario dé su consentimiento, se han modificado los scripts de Google Analytics. Se ha cambiado su `type` a `text/plain` y se ha añadido el atributo `data-cookieconsent="statistics"`.

```html
<script type="text/plain" data-cookieconsent="statistics" async 
        src="https://www.googletagmanager.com/gtag/js?id=G-TBZK1N6QGS"></script>
<script type="text/plain" data-cookieconsent="statistics">
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }
    gtag('js', new Date());
    gtag('config', 'G-TBZK1N6QGS');
</script>
```

## 3. Página de Declaración de Cookies
Se ha creado un archivo específico `politica-cookies.html` que incluye el script de declaración dinámica de Cookiebot. Este script genera automáticamente un informe detallado de todas las cookies detectadas en el sitio, su finalidad y su caducidad.

```html
<script id="CookieDeclaration" 
        src="https://consent.cookiebot.com/1caf3909-123e-4e98-b2f5-b97f18ce963b/cd.js" 
        type="text/javascript" async></script>
```

## 4. Opciones de Usuario en el Footer
En el archivo `footer.html`, se han añadido dos enlaces clave para la transparencia y el control del usuario:

1.  **Enlace a la Política**: Acceso directo a `politica-cookies.html`.
2.  **Configuración de Cookies**: Un botón que permite al usuario revocar o cambiar su consentimiento en cualquier momento mediante la función `Cookiebot.renew()`.

```html
<a href="politica-cookies.html">Política de Cookies</a>
<a href="#" onclick="try { Cookiebot.renew(); } catch(e) { console.error(e); } return false;">
   Configuración de Cookies
</a>
```

## 5. Funcionamiento General
1.  **Bloqueo Automático**: Cookiebot escanea el sitio y bloquea las cookies no esenciales hasta que se obtiene el consentimiento.
2.  **Registro de Consentimientos**: La plataforma almacena de forma anónima los consentimientos de los usuarios como prueba de cumplimiento.
3.  **Transparencia**: El usuario puede ver en tiempo real qué cookies se están utilizando y para qué.
