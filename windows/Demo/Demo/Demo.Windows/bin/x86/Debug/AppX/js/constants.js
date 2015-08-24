(function () {
    "use strict";
    WinJS.Namespace.define("Surfnet", {
        Constants: WinJS.Class.define(
            function init() {
            },
            {
            },
            {
                AUTH_URL: "https://nonweb.demo.surfconext.nl/php-oauth-as/authorize.php",
                HTTP_CLIENT_ID: "5dcbbc877e9955e3b29d7ca0baa4c7c5",
                SFOAUTH_CLIENT_ID: "5dcbbc877e9955e3b29d7ca0baa4c7c6",
                SFOAUTH_CLIENT_ID_PHONE: "5dcbbc877e9955e3b29d7ca0baa4c7c7",
                RESPONSE_TYPE: "token",
                STATE: "&state=demo",
                SCOPE: "authorize",
                EXTRA_CLIENT_ID: "extra_client_id"
            }

        )
    });
})();