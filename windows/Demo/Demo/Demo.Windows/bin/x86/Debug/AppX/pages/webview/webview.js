(function () {
    "use strict";

    WinJS.UI.Pages.define("/pages/webview/webview.html", {
        // This function is called whenever a user navigates to this page. It
        // populates the page elements with the app's data.
        _layoutRoot: null,
        _webview: null,
        ready: function (element, options) {

            this._layoutRoot = element;
            this._webview = this._layoutRoot.querySelector("#webview");

            var backButton = this._layoutRoot.querySelector("#backButton");
            backButton.addEventListener("click", this._goBack);
            var constants = Surfnet.Constants;
            var urlString = constants.AUTH_URL + "?client_id=" + constants.HTTP_CLIENT_ID + "&response_type=" + constants.RESPONSE_TYPE + "&state=" + constants.STATE + "&scope=" + constants.SCOPE;

            this._webview.navigate(urlString);
        },

        _goBack: function () {
            WinJS.Navigation.back(1);
        }


    });
})();
