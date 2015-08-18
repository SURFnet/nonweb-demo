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
            var constants = Surfnet.Constants;
            var urlString = constants.AUTH_URL + "?client_id=" + constants.HTTP_CLIENT_ID + "&response_type=" + constants.RESPONSE_TYPE + "&state=" + constants.STATE + "&scope=" + constants.SCOPE;
            var startURI = new Windows.Foundation.Uri(urlString);
            var launcherOptions = new Windows.System.LauncherOptions();
            if (!WinJS.Utilities.isPhone) {
                launcherOptions.desiredRemainingView = Windows.UI.ViewManagement.ViewSizePreference.useNone; // this is not available on Windows Phone
            }
            Windows.System.Launcher.launchUriAsync(startURI, launcherOptions);
        },

        _goBack: function () {
            WinJS.Navigation.back(1);
        }

    });
})();
