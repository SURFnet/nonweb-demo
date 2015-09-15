(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/home/home.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {
            // TODO: Initialize the page here.
            var browserButton = element.querySelector("#browserButton");
            var webviewButton = element.querySelector("#webviewButton");
            var brokerButton = element.querySelector("#brokerButton");


            browserButton.addEventListener("click", function () {
                WinJS.Navigation.navigate("/pages/browser/browser.html");
            });
            webviewButton.addEventListener("click", function () {
                WinJS.Navigation.navigate("/pages/webview/webview.html");
            });
            brokerButton.addEventListener("click", function () {
            WinJS.Navigation.navigate("/pages/broker/broker.html");

                                //
            });
        },

    });
})();
