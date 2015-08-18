(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/browser/browser.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        ready: function (element, options) {
            this._layoutRoot = element;

            var backButton = this._layoutRoot.querySelector("#backButton");
            backButton.addEventListener("click", this._goBack);

            var browserButton = this._layoutRoot.querySelector("#openBrowser");
            browserButton.addEventListener("click", this._openExternalBrowser);

        },

        _openExternalBrowser: function () {
            var url = "http://www.google.nl";
            var uri = new Windows.Foundation.Uri(url);
            var launcherOptions = new Windows.System.LauncherOptions();
            if (!WinJS.Utilities.isPhone) {
                launcherOptions.desiredRemainingView = Windows.UI.ViewManagement.ViewSizePreference.useNone; // this is not available on Windows Phone
            }
            Windows.System.Launcher.launchUriAsync(uri, launcherOptions);
        },

        _goBack: function () {
            WinJS.Navigation.back(1);
        }

    });
})();
